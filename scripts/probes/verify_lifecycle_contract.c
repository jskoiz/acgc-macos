#define _POSIX_C_SOURCE 200809L

#include <inttypes.h>
#include <pthread.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

enum {
    ACGC_VI_HZ = 60,
    ACGC_TRACE_CAPACITY = 32
};

static const uint64_t ACGC_NSEC_PER_SECOND = UINT64_C(1000000000);

typedef enum AcgcLifecycleEventKind {
    ACGC_EVENT_RETRACE = 1,
    ACGC_EVENT_FOCUS_LOST,
    ACGC_EVENT_FOCUS_GAINED,
    ACGC_EVENT_TERMINATION_REQUESTED,
    ACGC_EVENT_TERMINATED
} AcgcLifecycleEventKind;

typedef struct AcgcLifecycleEvent {
    AcgcLifecycleEventKind kind;
    uint64_t at_ns;
    uint64_t frame_index;
} AcgcLifecycleEvent;

typedef struct AcgcLifecycleTrace {
    size_t count;
    AcgcLifecycleEvent events[ACGC_TRACE_CAPACITY];
} AcgcLifecycleTrace;

typedef struct AcgcLifecycleWorker {
    pthread_t thread;
    pthread_mutex_t mutex;
    pthread_cond_t condition;
    int mutex_ready;
    int condition_ready;
    int thread_created;
    int joined;
    int started;
    int stop_requested;
    int stopped;
    int wait_failed;
} AcgcLifecycleWorker;

typedef struct AcgcLifecycle {
    uint64_t now_ns;
    uint64_t vi_epoch_ns;
    uint64_t next_vi_ns;
    uint64_t next_vi_ordinal;
    uint64_t frame_count;
    int focused;
    int terminating;
    int terminated;
    AcgcLifecycleWorker* worker;
    AcgcLifecycleTrace trace;
} AcgcLifecycle;

static uint64_t monotonic_ns(void) {
    struct timespec timestamp;

    if (clock_gettime(CLOCK_MONOTONIC, &timestamp) != 0) {
        return 0;
    }
    return (uint64_t)timestamp.tv_sec * ACGC_NSEC_PER_SECOND +
           (uint64_t)timestamp.tv_nsec;
}

static int vi_deadline(
    uint64_t epoch_ns,
    uint64_t ordinal,
    uint64_t* deadline_ns
) {
    uint64_t offset_ns;

    if (deadline_ns == NULL || ordinal == 0 ||
        ordinal > UINT64_MAX / ACGC_NSEC_PER_SECOND) {
        return 0;
    }
    offset_ns = (ordinal * ACGC_NSEC_PER_SECOND) / ACGC_VI_HZ;
    if (epoch_ns > UINT64_MAX - offset_ns) {
        return 0;
    }
    *deadline_ns = epoch_ns + offset_ns;
    return 1;
}

static int trace_append(
    AcgcLifecycleTrace* trace,
    AcgcLifecycleEventKind kind,
    uint64_t at_ns,
    uint64_t frame_index
) {
    AcgcLifecycleEvent* event;

    if (trace == NULL || trace->count >= ACGC_TRACE_CAPACITY) {
        return 0;
    }
    event = &trace->events[trace->count++];
    event->kind = kind;
    event->at_ns = at_ns;
    event->frame_index = frame_index;
    return 1;
}

static void* lifecycle_worker_main(void* context) {
    AcgcLifecycleWorker* worker = (AcgcLifecycleWorker*)context;

    if (worker == NULL || pthread_mutex_lock(&worker->mutex) != 0) {
        return NULL;
    }
    worker->started = 1;
    (void)pthread_cond_broadcast(&worker->condition);
    while (!worker->stop_requested) {
        if (pthread_cond_wait(&worker->condition, &worker->mutex) != 0) {
            worker->wait_failed = 1;
            break;
        }
    }
    worker->stopped = 1;
    (void)pthread_cond_broadcast(&worker->condition);
    (void)pthread_mutex_unlock(&worker->mutex);
    return NULL;
}

static int lifecycle_worker_init(AcgcLifecycleWorker* worker) {
    int status;

    if (worker == NULL) {
        return 0;
    }
    memset(worker, 0, sizeof(*worker));
    status = pthread_mutex_init(&worker->mutex, NULL);
    if (status != 0) {
        return 0;
    }
    worker->mutex_ready = 1;
    status = pthread_cond_init(&worker->condition, NULL);
    if (status != 0) {
        (void)pthread_mutex_destroy(&worker->mutex);
        worker->mutex_ready = 0;
        return 0;
    }
    worker->condition_ready = 1;
    return 1;
}

static int lifecycle_worker_start(AcgcLifecycleWorker* worker) {
    int status;

    if (worker == NULL || !worker->mutex_ready || !worker->condition_ready) {
        return 0;
    }
    status = pthread_create(
        &worker->thread,
        NULL,
        lifecycle_worker_main,
        worker
    );
    if (status != 0) {
        return 0;
    }
    worker->thread_created = 1;
    if (pthread_mutex_lock(&worker->mutex) != 0) {
        return 0;
    }
    while (!worker->started && !worker->wait_failed) {
        if (pthread_cond_wait(&worker->condition, &worker->mutex) != 0) {
            (void)pthread_mutex_unlock(&worker->mutex);
            return 0;
        }
    }
    status = worker->started && !worker->wait_failed;
    (void)pthread_mutex_unlock(&worker->mutex);
    return status;
}

static int lifecycle_worker_stop_and_join(AcgcLifecycleWorker* worker) {
    int stopped;

    if (worker == NULL) {
        return 0;
    }
    if (!worker->thread_created) {
        if (worker->condition_ready) {
            (void)pthread_cond_destroy(&worker->condition);
            worker->condition_ready = 0;
        }
        if (worker->mutex_ready) {
            (void)pthread_mutex_destroy(&worker->mutex);
            worker->mutex_ready = 0;
        }
        return 1;
    }
    if (!worker->joined) {
        if (pthread_mutex_lock(&worker->mutex) != 0) {
            return 0;
        }
        worker->stop_requested = 1;
        (void)pthread_cond_signal(&worker->condition);
        (void)pthread_mutex_unlock(&worker->mutex);
        if (pthread_join(worker->thread, NULL) != 0) {
            return 0;
        }
        worker->joined = 1;
    }
    stopped = worker->stopped && !worker->wait_failed;
    (void)pthread_cond_destroy(&worker->condition);
    (void)pthread_mutex_destroy(&worker->mutex);
    worker->condition_ready = 0;
    worker->mutex_ready = 0;
    worker->thread_created = 0;
    return stopped;
}

static void lifecycle_init(
    AcgcLifecycle* lifecycle,
    AcgcLifecycleWorker* worker
) {
    memset(lifecycle, 0, sizeof(*lifecycle));
    lifecycle->focused = 1;
    lifecycle->next_vi_ordinal = 1;
    lifecycle->worker = worker;
    (void)vi_deadline(
        lifecycle->vi_epoch_ns,
        lifecycle->next_vi_ordinal,
        &lifecycle->next_vi_ns
    );
}

static int lifecycle_advance_to(AcgcLifecycle* lifecycle, uint64_t now_ns) {
    if (lifecycle == NULL || now_ns < lifecycle->now_ns) {
        return 0;
    }
    lifecycle->now_ns = now_ns;
    return 1;
}

static int lifecycle_pump(AcgcLifecycle* lifecycle, uint64_t now_ns) {
    if (!lifecycle_advance_to(lifecycle, now_ns)) {
        return 0;
    }
    if (!lifecycle->focused || lifecycle->terminating || lifecycle->terminated) {
        return 1;
    }
    while (lifecycle->next_vi_ns <= lifecycle->now_ns) {
        if (!trace_append(
                &lifecycle->trace,
                ACGC_EVENT_RETRACE,
                lifecycle->next_vi_ns,
                lifecycle->frame_count)) {
            return 0;
        }
        lifecycle->frame_count++;
        lifecycle->next_vi_ordinal++;
        if (!vi_deadline(
                lifecycle->vi_epoch_ns,
                lifecycle->next_vi_ordinal,
                &lifecycle->next_vi_ns)) {
            return 0;
        }
    }
    return 1;
}

static int lifecycle_set_focus(
    AcgcLifecycle* lifecycle,
    uint64_t now_ns,
    int focused
) {
    AcgcLifecycleEventKind event_kind;

    if (!lifecycle_advance_to(lifecycle, now_ns) ||
        lifecycle->terminating || lifecycle->terminated ||
        lifecycle->focused == focused) {
        return lifecycle != NULL && now_ns >= lifecycle->now_ns;
    }
    lifecycle->focused = focused;
    event_kind = focused ? ACGC_EVENT_FOCUS_GAINED : ACGC_EVENT_FOCUS_LOST;
    if (!trace_append(
            &lifecycle->trace,
            event_kind,
            now_ns,
            UINT64_MAX)) {
        return 0;
    }
    if (focused) {
        lifecycle->vi_epoch_ns = now_ns;
        lifecycle->next_vi_ordinal = 1;
        return vi_deadline(
            lifecycle->vi_epoch_ns,
            lifecycle->next_vi_ordinal,
            &lifecycle->next_vi_ns
        );
    }
    return 1;
}

static int lifecycle_terminate(AcgcLifecycle* lifecycle, uint64_t now_ns) {
    if (!lifecycle_advance_to(lifecycle, now_ns)) {
        return 0;
    }
    if (lifecycle->terminating || lifecycle->terminated) {
        return 1;
    }
    lifecycle->terminating = 1;
    if (!trace_append(
            &lifecycle->trace,
            ACGC_EVENT_TERMINATION_REQUESTED,
            now_ns,
            UINT64_MAX)) {
        return 0;
    }
    if (lifecycle->worker != NULL) {
        if (!lifecycle_worker_stop_and_join(lifecycle->worker)) {
            return 0;
        }
        lifecycle->worker = NULL;
    }
    lifecycle->terminated = 1;
    if (!trace_append(
            &lifecycle->trace,
            ACGC_EVENT_TERMINATED,
            now_ns,
            UINT64_MAX)) {
        return 0;
    }
    return 1;
}

static void hash_u64(uint64_t* hash, uint64_t value) {
    unsigned int byte;

    for (byte = 0; byte < sizeof(value); byte++) {
        *hash ^= value & UINT64_C(0xff);
        *hash *= UINT64_C(1099511628211);
        value >>= 8;
    }
}

static uint64_t lifecycle_trace_hash(const AcgcLifecycleTrace* trace) {
    uint64_t hash = UINT64_C(1469598103934665603);
    size_t index;

    for (index = 0; index < trace->count; index++) {
        const AcgcLifecycleEvent* event = &trace->events[index];
        hash_u64(&hash, (uint64_t)event->kind);
        hash_u64(&hash, event->at_ns);
        hash_u64(&hash, event->frame_index);
    }
    return hash;
}

static int lifecycle_trace_matches_expected(
    const AcgcLifecycleTrace* trace
) {
    static const AcgcLifecycleEvent expected[] = {
        { ACGC_EVENT_RETRACE, UINT64_C(16666666), UINT64_C(0) },
        { ACGC_EVENT_RETRACE, UINT64_C(33333333), UINT64_C(1) },
        { ACGC_EVENT_RETRACE, UINT64_C(50000000), UINT64_C(2) },
        { ACGC_EVENT_FOCUS_LOST, UINT64_C(60000000), UINT64_MAX },
        { ACGC_EVENT_FOCUS_GAINED, UINT64_C(100000000), UINT64_MAX },
        { ACGC_EVENT_RETRACE, UINT64_C(116666666), UINT64_C(3) },
        { ACGC_EVENT_RETRACE, UINT64_C(133333333), UINT64_C(4) },
        { ACGC_EVENT_TERMINATION_REQUESTED, UINT64_C(140000000), UINT64_MAX },
        { ACGC_EVENT_TERMINATED, UINT64_C(140000000), UINT64_MAX }
    };
    size_t index;

    if (trace == NULL || trace->count != sizeof(expected) / sizeof(expected[0])) {
        return 0;
    }
    for (index = 0; index < trace->count; index++) {
        if (trace->events[index].kind != expected[index].kind ||
            trace->events[index].at_ns != expected[index].at_ns ||
            trace->events[index].frame_index != expected[index].frame_index) {
            return 0;
        }
    }
    return 1;
}

static int run_deterministic_trace(
    AcgcLifecycleTrace* trace,
    uint64_t* trace_hash
) {
    AcgcLifecycleWorker worker = { 0 };
    AcgcLifecycle lifecycle;
    int ok = 0;

    if (trace == NULL || trace_hash == NULL || !lifecycle_worker_init(&worker) ||
        !lifecycle_worker_start(&worker)) {
        (void)lifecycle_worker_stop_and_join(&worker);
        return 0;
    }
    lifecycle_init(&lifecycle, &worker);
    if (!lifecycle_pump(&lifecycle, UINT64_C(16666665)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(16666666)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(33333333)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(50000000)) ||
        !lifecycle_set_focus(&lifecycle, UINT64_C(60000000), 0) ||
        !lifecycle_pump(&lifecycle, UINT64_C(100000000)) ||
        !lifecycle_set_focus(&lifecycle, UINT64_C(100000000), 1) ||
        !lifecycle_pump(&lifecycle, UINT64_C(116666665)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(116666666)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(133333333)) ||
        !lifecycle_terminate(&lifecycle, UINT64_C(140000000)) ||
        !lifecycle_pump(&lifecycle, UINT64_C(200000000)) ||
        !lifecycle_terminate(&lifecycle, UINT64_C(200000000)) ||
        !lifecycle.terminated || lifecycle.worker != NULL ||
        lifecycle.frame_count != 5 ||
        !lifecycle_trace_matches_expected(&lifecycle.trace)) {
        goto cleanup;
    }
    *trace = lifecycle.trace;
    *trace_hash = lifecycle_trace_hash(trace);
    ok = 1;

cleanup:
    if (!lifecycle_worker_stop_and_join(&worker)) {
        ok = 0;
    }
    return ok;
}

static int test_reverse_time_rejection(void) {
    AcgcLifecycle lifecycle;

    lifecycle_init(&lifecycle, NULL);
    return lifecycle_pump(&lifecycle, UINT64_C(10)) &&
           !lifecycle_pump(&lifecycle, UINT64_C(9));
}

int main(void) {
    AcgcLifecycleTrace first_trace;
    AcgcLifecycleTrace second_trace;
    uint64_t first_hash;
    uint64_t second_hash;
    uint64_t first_clock;
    uint64_t second_clock;

    first_clock = monotonic_ns();
    second_clock = monotonic_ns();
    if (first_clock == 0 || second_clock == 0 || second_clock < first_clock) {
        fprintf(stderr, "monotonic clock probe failed\n");
        return 1;
    }
    if (!test_reverse_time_rejection()) {
        fprintf(stderr, "synthetic reverse-time rejection failed\n");
        return 1;
    }
    if (!run_deterministic_trace(&first_trace, &first_hash) ||
        !run_deterministic_trace(&second_trace, &second_hash)) {
        fprintf(stderr, "deterministic lifecycle trace failed\n");
        return 1;
    }
    if (first_hash != second_hash ||
        first_trace.count != second_trace.count ||
        memcmp(&first_trace, &second_trace, sizeof(first_trace)) != 0) {
        fprintf(stderr, "lifecycle trace was not deterministic\n");
        return 1;
    }

    printf("lifecycle contract probe: PASS\n");
    printf("monotonic clock: PASS (CLOCK_MONOTONIC nondecreasing)\n");
    printf("VI/retrace pacing: PASS (60 Hz fixed-phase synthetic schedule, 5 active retraces)\n");
    printf("focus loss/resume: PASS (paused without catch-up; resume re-anchors cadence)\n");
    printf("worker shutdown: PASS (stop signal joined before termination completion)\n");
    printf("deterministic termination trace: PASS (events=%zu hash=%016" PRIx64 ")\n",
           first_trace.count,
           first_hash);
    return 0;
}
