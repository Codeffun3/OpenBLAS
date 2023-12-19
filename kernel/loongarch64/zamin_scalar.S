#define ASSEMBLER

#include "common.h"

#define N    $r4
#define X    $r5
#define INCX $r6
#define I    $r12
#define t1   $f14
#define t2   $f18
#define t3   $f15
#define t4   $f17
#define s1   $f22
#define s2   $f9
#define s3   $f10
#define s4   $f11
#define TEMP $r16
#define a0   $f20
#define a1   $f21

    PROLOGUE
    MTC s1, $r0
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    LD a0, X, 0 * SIZE
    LD a1, X, 1 * SIZE
    FABS a0, a0
    FABS a1, a1
    ADD s1, a0, a1
    slli.d INCX, INCX, ZBASE_SHIFT
    srai.d I, N, 3
    bge $r0, I, .L23
    .align 3

.L21:
    LD t1, X, 0 * SIZE
    LD t2, X, 1 * SIZE
    add.d X, X, INCX
    LD t3, X, 0 * SIZE
    LD t4, X, 1 * SIZE
    add.d X, X, INCX
    FABS t1, t1
    FABS t2, t2
    FABS t3, t3
    FABS t4, t4
    ADD t1, t1, t2
    ADD t3, t3, t4
#ifdef DOUBLE
    fmin.d s1, t1, t3
#else
    fmin.s s1, t1, t3
#endif
    LD t1, X, 0 * SIZE
    LD t2, X, 1 * SIZE
    add.d X, X, INCX
    LD t3, X, 0 * SIZE
    LD t4, X, 1 * SIZE
    add.d X, X, INCX
    FABS t1, t1
    FABS t2, t2
    FABS t3, t3
    FABS t4, t4
    ADD t1, t1, t2
    ADD t3, t3, t4
#ifdef DOUBLE
    fmin.d s2, t1, t3
#else
    fmin.s s2, t1, t3
#endif
    LD t1, X, 0 * SIZE
    LD t2, X, 1 * SIZE
    add.d X, X, INCX
    LD t3, X, 0 * SIZE
    LD t4, X, 1 * SIZE
    add.d X, X, INCX
    FABS t1, t1
    FABS t2, t2
    FABS t3, t3
    FABS t4, t4
    addi.d I, I, -1
    ADD t1, t1, t2
    ADD t3, t3, t4
#ifdef DOUBLE
    fmin.d s3, t1, t3
#else
    fmin.s s3, t1, t3
#endif
    LD t1, X, 0 * SIZE
    LD t2, X, 1 * SIZE
    add.d X, X, INCX
    LD t3, X, 0 * SIZE
    LD t4, X, 1 * SIZE
    add.d X, X, INCX
    FABS t1, t1
    FABS t2, t2
    FABS t3, t3
    FABS t4, t4
    ADD t1, t1, t2
    ADD t3, t3, t4
#ifdef DOUBLE
    fmin.d s4, t1, t3
#else
    fmin.s s4, t1, t3
#endif
    blt $r0, I, .L21
    .align 3

.L22:
#ifdef DOUBLE
    fmin.d s1, s1, s2
    fmin.d s3, s3, s4
    fmin.d s1, s1, s3
#else
    fmin.s s1, s1, s2
    fmin.s s3, s3, s4
    fmin.s s1, s1, s3
#endif
    .align 3

.L23: //N<8
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L24:
    LD a0, X, 0 * SIZE
    LD a1, X, 1 * SIZE
    addi.d I, I, -1
    FABS a0, a0
    FABS a1, a1
    ADD a0, a0, a1
    add.d  X, X, INCX
#ifdef DOUBLE
    fmin.d s1, a0, s1
#else
    fmin.s s1, a0, s1
#endif
    blt $r0, I, .L24
    .align 3

.L999:
    fmov.s $f0, $f22
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
