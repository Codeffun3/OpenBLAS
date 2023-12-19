#define ASSEMBLER

#include "common.h"
#define N      $r4
#define XX     $r5
#define YY     $r6
#define ALPHAR $f0
#define ALPHAI $f1
#define X      $r7
#define INCX   $r8
#define Y      $r9
#define INCY   $r10

#define I      $r12
#define TEMP   $r13
#define t1     $r14
#define t2     $r16
#define t3     $r15
#define t4     $r17
#define a1     $f12
#define a2     $f13
#define a3     $f14
#define a4     $f15
#define s1     $f16
#define s2     $f17
#define s3     $f18
#define s4     $f19
#define VX0    $xr8
#define VX1    $xr20
#define VX2    $xr21
#define VX3    $xr22
#define VXAR   $xr23
#define VXAI   $xr19
#define x1     $xr18
#define x2     $xr17
#define x3     $xr16
#define x4     $xr15

    PROLOGUE

    bge $r0, N, .L999
    li.d TEMP, 1
    movgr2fr.d a1, $r0
    ffint.d.l a1, a1
    fcmp.ceq.d $fcc0, ALPHAR, a1
    fcmp.ceq.d $fcc1, ALPHAI, a1
    bceqz $fcc0, .L10
    bcnez $fcc1, .L999
.L10:
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    slli.d  INCY, INCY, ZBASE_SHIFT
    movfr2gr.d t1, ALPHAR
    xvreplgr2vr.d VXAR, t1
    movfr2gr.d t2, ALPHAI
    xvreplgr2vr.d VXAI, t2
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
    xvld VX0, X, 0 * SIZE
    xvld VX2, Y, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvld VX3, Y, 4 * SIZE
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
    xvpickev.d x3, VX3, VX2
    xvpickod.d x4, VX3, VX2
#if !defined(CONJ)
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmsub.d VX1, VXAR, x1, VX0
    xvfmadd.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfadd.d x4, x4, VX3
#else
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmadd.d VX1, VXAR, x1, VX0
    xvfmsub.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfsub.d x4, x4, VX3
#endif
    xvilvl.d VX2, x4 ,x3
    xvilvh.d VX3, x4, x3
    xvst VX2, Y, 0 * SIZE
    xvst VX3, Y, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    b .L997
    .align 3

.L12: // INCX==1 and INCY!=1
    bge $r0, I, .L997
    move YY, Y
    .align 3

.L121:
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    xvinsgr2vr.d x3, t1, 0
    xvinsgr2vr.d x4, t2, 0
    xvinsgr2vr.d x3, t3, 2
    xvinsgr2vr.d x4, t4, 2
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    xvinsgr2vr.d x3, t1, 1
    xvinsgr2vr.d x4, t2, 1
    xvinsgr2vr.d x3, t3, 3
    xvinsgr2vr.d x4, t4, 3
    add.d Y, Y, INCY
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
#if !defined(CONJ)
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmsub.d VX1, VXAR, x1, VX0
    xvfmadd.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfadd.d x4, x4, VX3
#else
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmadd.d VX1, VXAR, x1, VX0
    xvfmsub.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfsub.d x4, x4, VX3
#endif
    xvstelm.d x3, YY, 0 * SIZE, 0
    xvstelm.d x4, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 2
    xvstelm.d x4, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 1
    xvstelm.d x4, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 3
    xvstelm.d x4, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L121
    b .L997
    .align 3

.L21:// INCX!=1 and INCY==1
    bge $r0, I, .L997
    .align 3

.L211:
    xvld VX2, Y, 0 * SIZE
    xvld VX3, Y, 4 * SIZE
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d x1, t1, 0
    xvinsgr2vr.d x2, t2, 0
    xvinsgr2vr.d x1, t3, 2
    xvinsgr2vr.d x2, t4, 2
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    xvinsgr2vr.d x1, t1, 1
    xvinsgr2vr.d x2, t2, 1
    xvinsgr2vr.d x1, t3, 3
    xvinsgr2vr.d x2, t4, 3
    add.d X, X, INCX
    xvpickev.d x3, VX3, VX2
    xvpickod.d x4, VX3, VX2
#if !defined(CONJ)
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmsub.d VX1, VXAR, x1, VX0
    xvfmadd.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfadd.d x4, x4, VX3
#else
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmadd.d VX1, VXAR, x1, VX0
    xvfmsub.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfsub.d x4, x4, VX3
#endif
    xvilvl.d VX2, x4 ,x3
    xvilvh.d VX3, x4, x3
    addi.d  I, I, -1
    xvst VX2, Y, 0 * SIZE
    xvst VX3, Y, 4 * SIZE
    addi.d Y, Y, 8 * SIZE
    blt $r0, I, .L211
    b .L997
    .align 3

.L22:
    bge $r0, I, .L997
    move YY, Y
    .align 3

.L222:
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d x1, t1, 0
    xvinsgr2vr.d x2, t2, 0
    xvinsgr2vr.d x1, t3, 1
    xvinsgr2vr.d x2, t4, 1
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d x1, t1, 2
    xvinsgr2vr.d x2, t2, 2
    xvinsgr2vr.d x1, t3, 3
    xvinsgr2vr.d x2, t4, 3
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    xvinsgr2vr.d x3, t1, 0
    xvinsgr2vr.d x4, t2, 0
    xvinsgr2vr.d x3, t3, 1
    xvinsgr2vr.d x4, t4, 1
    ld.d t1, Y, 0 * SIZE
    ld.d t2, Y, 1 * SIZE
    add.d Y, Y, INCY
    ld.d t3, Y, 0 * SIZE
    ld.d t4, Y, 1 * SIZE
    add.d Y, Y, INCY
    xvinsgr2vr.d x3, t1, 2
    xvinsgr2vr.d x4, t2, 2
    xvinsgr2vr.d x3, t3, 3
    xvinsgr2vr.d x4, t4, 3

#if !defined(CONJ)
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmsub.d VX1, VXAR, x1, VX0
    xvfmadd.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfadd.d x4, x4, VX3
#else
    xvfmul.d VX0, VXAI, x2
    xvfmul.d VX2, VXAI, x1
    xvfmadd.d VX1, VXAR, x1, VX0
    xvfmsub.d VX3, x2, VXAR, VX2
    xvfadd.d x3, x3, VX1
    xvfsub.d x4, x4, VX3
#endif
    addi.d  I, I, -1
    xvstelm.d x3, YY, 0 * SIZE, 0
    xvstelm.d x4, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 1
    xvstelm.d x4, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 2
    xvstelm.d x4, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    xvstelm.d x3, YY, 0 * SIZE, 3
    xvstelm.d x4, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    blt $r0, I, .L222
    .align 3

.L997:
    andi I, N, 3
    bge $r0, I, .L999
    .align 3

.L998:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fld.d a3, Y, 0 * SIZE
    fld.d a4, Y, 1 * SIZE
    addi.d I, I, -1
#if !defined(CONJ)
    fmul.d s1, ALPHAI, a2
    fmul.d s2, ALPHAI, a1
    fmsub.d s3, ALPHAR, a1, s1
    fmadd.d s4, a2, ALPHAR, s2
    fadd.d s3, s3, a3
    fadd.d s4, s4, a4
#else
    fmul.d s1, ALPHAI, a2
    fmul.d s2, ALPHAI, a1
    fmadd.d s3, ALPHAR, a1, s1
    fmsub.d s4, a2, ALPHAR, s2
    fadd.d s3, s3, a3
    fsub.d s4, a4, s4
#endif
    fst.d s3, Y, 0 * SIZE
    fst.d s4, Y, 1 * SIZE
    add.d X, X, INCX
    add.d Y, Y, INCY
    blt $r0, I, .L998
    .align 3

.L999:
    move $r4, $r12
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
