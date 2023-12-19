#define ASSEMBLER

#include "common.h"
#define N      $r4
#define X      $r5
#define INCX   $r6
#define Y      $r7
#define INCY   $r8
#define I      $r19
#define TEMP   $r10
#define t1     $r11
#define t2     $r12
#define t3     $r13
#define t4     $r14
#define a1     $f12
#define a2     $f13
#define a3     $f14
#define a4     $f15
#define s1     $f16
#define s2     $f17
#define s3     $f18
#define s4     $f19
#define res1   $vr16
#define res2   $vr17
#define res3   $vr18
#define res4   $vr19
#define VX0    $vr12
#define VX1    $vr13
#define VX2    $vr14
#define VX3    $vr15
#define x1     $vr20
#define x2     $vr21
#define x3     $vr22
#define x4     $vr23

    PROLOGUE
    vxor.v res1, res1, res1
    vxor.v res2, res2, res2
    vxor.v res3, res3, res3
    vxor.v res4, res4, res4
    bge $r0, N, .L999
    li.d  TEMP, 2 * SIZE
    slli.d  INCX, INCX, ZBASE_SHIFT
    slli.d  INCY, INCY, ZBASE_SHIFT
    srai.d I, N, 1
    bne INCX, TEMP, .L20
    bne INCY, TEMP, .L12 // INCX==1 and INCY!=1
    b .L11  // INCX==1 and INCY==1
.L20:
    bne INCY, TEMP, .L22 // INCX!=1 and INCY!=1
    b .L21 // INCX!=1 and INCY==1

.L11:
    bge $r0, I, .L997
    .align 3

.L111:
    vld VX0, X, 0 * SIZE
    vld VX1, X, 2 * SIZE
    vld VX2, Y, 0 * SIZE
    vld VX3, Y, 2 * SIZE
    vpickev.d x1, VX1, VX0
    vpickod.d x2, VX1, VX0
    vpickev.d x3, VX3, VX2
    vpickod.d x4, VX3, VX2
    vfmadd.d res1, x1, x3, res1
    vfmadd.d res2, x2, x3, res2
    vfmadd.d res3, x1, x4, res3
    vfmadd.d res4, x2, x4, res4
    addi.d X, X, 4 * SIZE
    addi.d Y, Y, 4 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    b .L996
    .align 3

.L12:
    bge $r0, I, .L997
    .align 3

.L121:
    vld VX0, X, 0 * SIZE
    vld VX1, X, 2 * SIZE
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.d x3, t1, 0
    vinsgr2vr.d x4, t2, 0
    vinsgr2vr.d x3, t3, 1
    vinsgr2vr.d x4, t4, 1
    addi.d X, X, 4 * SIZE
    vpickev.d x1, VX1, VX0
    vpickod.d x2, VX1, VX0
    vfmadd.d res1, x1, x3, res1
    vfmadd.d res2, x2, x3, res2
    vfmadd.d res3, x1, x4, res3
    vfmadd.d res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L121
    b .L996
    .align 3

.L21:
    bge $r0, I, .L997
    .align 3

.L211:
    vld VX2, Y, 0 * SIZE
    vld VX3, Y, 2 * SIZE
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d x1, t1, 0
    vinsgr2vr.d x2, t2, 0
    vinsgr2vr.d x1, t3, 1
    vinsgr2vr.d x2, t4, 1
    addi.d Y, Y, 4 * SIZE
    vpickev.d x3, VX3, VX2
    vpickod.d x4, VX3, VX2
    vfmadd.d res1, x1, x3, res1
    vfmadd.d res2, x2, x3, res2
    vfmadd.d res3, x1, x4, res3
    vfmadd.d res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L211
    b .L996
    .align 3

.L22:
    bge $r0, I, .L997
    .align 3

.L222:
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d x1, t1, 0
    vinsgr2vr.d x2, t2, 0
    vinsgr2vr.d x1, t3, 1
    vinsgr2vr.d x2, t4, 1
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.d x3, t1, 0
    vinsgr2vr.d x4, t2, 0
    vinsgr2vr.d x3, t3, 1
    vinsgr2vr.d x4, t4, 1
    vfmadd.d res1, x1, x3, res1
    vfmadd.d res2, x2, x3, res2
    vfmadd.d res3, x1, x4, res3
    vfmadd.d res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L222
    .align 3

.L996:
    vreplvei.d VX1, res1, 1
    vfadd.d res1, VX1, res1
    vreplvei.d VX1, res2, 1
    vfadd.d res2, VX1, res2
    vreplvei.d VX1, res3, 1
    vfadd.d res3, VX1, res3
    vreplvei.d VX1, res4, 1
    vfadd.d res4, VX1, res4
    .align 3

.L997:
    andi I, N, 1
    bge $r0, I, .L999
    .align 3

.L998:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fld.d a3, Y, 0 * SIZE
    fld.d a4, Y, 1 * SIZE
    fmadd.d s1, a1, a3, s1
    fmadd.d s2, a2, a3, s2
    fmadd.d s3, a1, a4, s3
    fmadd.d s4, a2, a4, s4
    addi.d I, I, -1
    add.d  X, X, INCX
    add.d  Y, Y, INCY
    blt $r0, I, .L998
    .align 3

.L999:
#ifndef CONJ
    SUB $f0, s1, s4
    ADD $f1, s3, s2
#else
    ADD $f0, s1, s4
    SUB $f1, s3, s2
#endif
    jirl    $r0, $r1, 0x0
    .align 3

    EPILOGUE