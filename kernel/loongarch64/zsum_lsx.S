#define ASSEMBLER
#include "common.h"
#define N      $r4
#define X      $r5
#define INCX   $r6
#define I      $r17
#define TEMP   $r18
#define t1     $r15
#define t2     $r12
#define t3     $r13
#define t4     $r14
#define a1     $f12
#define a2     $f13
#define a3     $f14
#define a4     $f15
#define s1     $f16
#define VX0    $vr12
#define VX1    $vr13
#define VX2    $vr14
#define VX3    $vr15
#define res1   $vr16
#define res2   $vr17
    PROLOGUE
    vxor.v res1, res1, res1
    vxor.v res2, res2, res2
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.d  TEMP, 1
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    srai.d I, N, 3
    bne INCX, TEMP, .L20
    bge $r0, I, .L13
    .align 3

.L11:
    vld VX0, X, 0 * SIZE
    vld VX1, X, 2 * SIZE
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    vld VX2, X, 4 * SIZE
    vld VX3, X, 6 * SIZE
    vfadd.d res2, VX2, VX3
    vfadd.d res1, res1, res2
    vld VX0, X, 8 * SIZE
    vld VX1, X, 10 * SIZE
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    vld VX2, X, 12 * SIZE
    vld VX3, X, 14 * SIZE
    vfadd.d res2, VX2, VX3
    vfadd.d res1, res1, res2
    addi.d X, X, 16 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L11
    .align 3

.L12:
    vreplvei.d VX1, res1, 1
    vfadd.d res1, VX1, res1
    .align 3

.L13:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L14:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fadd.d a1, a1, a2
    fadd.d s1, a1, s1
    addi.d I, I, -1
    addi.d  X, X, 2 * SIZE
    blt $r0, I, .L14
    b .L999
    .align 3

.L20:
    bge $r0, I, .L23
    .align 3

.L21:
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d VX0, t1, 0
    vinsgr2vr.d VX0, t2, 1
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    vinsgr2vr.d VX1, t1, 0
    vinsgr2vr.d VX1, t2, 1
    add.d X, X, INCX
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d VX0, t3, 0
    vinsgr2vr.d VX0, t4, 1
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    vinsgr2vr.d VX1, t3, 0
    vinsgr2vr.d VX1, t4, 1
    add.d X, X, INCX
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d VX0, t1, 0
    vinsgr2vr.d VX0, t2, 1
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    vinsgr2vr.d VX1, t1, 0
    vinsgr2vr.d VX1, t2, 1
    add.d X, X, INCX
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d VX0, t3, 0
    vinsgr2vr.d VX0, t4, 1
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    vinsgr2vr.d VX1, t3, 0
    vinsgr2vr.d VX1, t4, 1
    add.d X, X, INCX
    vfadd.d res2, VX0, VX1
    vfadd.d res1, res1, res2
    addi.d  I, I, -1
    blt $r0, I, .L21
    .align 3

.L22:
    vreplvei.d VX1, res1, 1
    vfadd.d res1, VX1, res1
    .align 3

.L23:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L24:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fadd.d a1, a1, a2
    fadd.d s1, a1, s1
    addi.d I, I, -1
    add.d  X, X, INCX
    blt $r0, I, .L24
    .align 3

.L999:
    fmov.d $f0, $f16
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
