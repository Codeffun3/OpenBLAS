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
    srai.d I, N, 2
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
    vld VX1, X, 4 * SIZE
    vld VX2, Y, 0 * SIZE
    vld VX3, Y, 4 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
    vfmadd.s res1, x1, x3, res1
    vfmadd.s res2, x2, x3, res2
    vfmadd.s res3, x1, x4, res3
    vfmadd.s res4, x2, x4, res4
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    b .L996
    .align 3

.L12:
    bge $r0, I, .L997
    .align 3

.L121:
    vld VX0, X, 0 * SIZE
    ld.w t1, Y, 0 * SIZE
    ld.w t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.w t3, Y, 0 * SIZE
    ld.w t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.w x3, t1, 0
    vinsgr2vr.w x4, t2, 0
    vinsgr2vr.w x3, t3, 1
    vinsgr2vr.w x4, t4, 1
    vld VX1, X, 4 * SIZE
    ld.w t1, Y, 0 * SIZE
    ld.w t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.w t3, Y, 0 * SIZE
    ld.w t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.w x3, t1, 2
    vinsgr2vr.w x4, t2, 2
    vinsgr2vr.w x3, t3, 3
    vinsgr2vr.w x4, t4, 3
    addi.d X, X, 8 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vfmadd.s res1, x1, x3, res1
    vfmadd.s res2, x2, x3, res2
    vfmadd.s res3, x1, x4, res3
    vfmadd.s res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L121
    b .L996
    .align 3

.L21:
    bge $r0, I, .L997
    .align 3

.L211:
    vld VX2, Y, 0 * SIZE
    ld.w t1, X, 0 * SIZE
    ld.w t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    ld.w t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.w x1, t1, 0
    vinsgr2vr.w x2, t2, 0
    vinsgr2vr.w x1, t3, 1
    vinsgr2vr.w x2, t4, 1
    vld VX3, Y, 4 * SIZE
    ld.w t1, X, 0 * SIZE
    ld.w t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    ld.w t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    addi.d Y, Y, 8 * SIZE
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
    vfmadd.s res1, x1, x3, res1
    vfmadd.s res2, x2, x3, res2
    vfmadd.s res3, x1, x4, res3
    vfmadd.s res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L211
    b .L996
    .align 3

.L22:
    bge $r0, I, .L997
    .align 3

.L222:
    ld.w t1, X, 0 * SIZE
    ld.w t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    ld.w t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.w x1, t1, 0
    vinsgr2vr.w x2, t2, 0
    vinsgr2vr.w x1, t3, 1
    vinsgr2vr.w x2, t4, 1
    ld.w t1, Y, 0 * SIZE
    ld.w t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.w t3, Y, 0 * SIZE
    ld.w t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.w x3, t1, 0
    vinsgr2vr.w x4, t2, 0
    vinsgr2vr.w x3, t3, 1
    vinsgr2vr.w x4, t4, 1
    ld.w t1, X, 0 * SIZE
    ld.w t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    ld.w t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    ld.w t1, Y, 0 * SIZE
    ld.w t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.w t3, Y, 0 * SIZE
    ld.w t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    vinsgr2vr.w x3, t1, 2
    vinsgr2vr.w x4, t2, 2
    vinsgr2vr.w x3, t3, 3
    vinsgr2vr.w x4, t4, 3
    vfmadd.s res1, x1, x3, res1
    vfmadd.s res2, x2, x3, res2
    vfmadd.s res3, x1, x4, res3
    vfmadd.s res4, x2, x4, res4
    addi.d  I, I, -1
    blt $r0, I, .L222
    .align 3

.L996:
    vreplvei.w VX1, res1, 1
    vreplvei.w VX2, res1, 2
    vreplvei.w VX3, res1, 3
    vfadd.s res1, VX1, res1
    vfadd.s res1, VX2, res1
    vfadd.s res1, VX3, res1
    vreplvei.w VX1, res2, 1
    vreplvei.w VX2, res2, 2
    vreplvei.w VX3, res2, 3
    vfadd.s res2, VX1, res2
    vfadd.s res2, VX2, res2
    vfadd.s res2, VX3, res2
    vreplvei.w VX1, res3, 1
    vreplvei.w VX2, res3, 2
    vreplvei.w VX3, res3, 3
    vfadd.s res3, VX1, res3
    vfadd.s res3, VX2, res3
    vfadd.s res3, VX3, res3
    vreplvei.w VX1, res4, 1
    vreplvei.w VX2, res4, 2
    vreplvei.w VX3, res4, 3
    vfadd.s res4, VX1, res4
    vfadd.s res4, VX2, res4
    vfadd.s res4, VX3, res4
    .align 3

.L997:
    andi I, N, 3
    bge $r0, I, .L999
    .align 3

.L998:
    fld.s a1, X, 0 * SIZE
    fld.s a2, X, 1 * SIZE
    fld.s a3, Y, 0 * SIZE
    fld.s a4, Y, 1 * SIZE
    fmadd.s s1, a1, a3, s1
    fmadd.s s2, a2, a3, s2
    fmadd.s s3, a1, a4, s3
    fmadd.s s4, a2, a4, s4
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