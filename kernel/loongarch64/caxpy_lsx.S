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
#define VX0    $vr8
#define VX1    $vr20
#define VX2    $vr21
#define VX3    $vr22
#define VXAR   $vr23
#define VXAI   $vr19
#define x1     $vr18
#define x2     $vr17
#define x3     $vr16
#define x4     $vr15

    PROLOGUE

    bge $r0, N, .L999
    li.d TEMP, 1
    movgr2fr.d a1, $r0
    ffint.s.l a1, a1
    fcmp.ceq.s $fcc0, ALPHAR, a1
    fcmp.ceq.s $fcc1, ALPHAI, a1
    bceqz $fcc0, .L10
    bcnez $fcc1, .L999
.L10:
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    slli.d  INCY, INCY, ZBASE_SHIFT
    movfr2gr.s t1, ALPHAR
    vreplgr2vr.w VXAR, t1
    movfr2gr.s t2, ALPHAI
    vreplgr2vr.w VXAI, t2
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
    vld VX2, Y, 0 * SIZE
    vld VX1, X, 4 * SIZE
    vld VX3, Y, 4 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
#if !defined(CONJ)
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmsub.s VX1, VXAR, x1, VX0
    vfmadd.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfadd.s x4, x4, VX3
#else
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmadd.s VX1, VXAR, x1, VX0
    vfmsub.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfsub.s x4, x4, VX3
#endif
    vilvl.w VX2, x4 ,x3
    vilvh.w VX3, x4, x3
    vst VX2, Y, 0 * SIZE
    vst VX3, Y, 4 * SIZE
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
    vinsgr2vr.w x3, t1, 2
    vinsgr2vr.w x4, t2, 2
    vinsgr2vr.w x3, t3, 3
    vinsgr2vr.w x4, t4, 3
    add.d Y, Y, INCY
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
#if !defined(CONJ)
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmsub.s VX1, VXAR, x1, VX0
    vfmadd.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfadd.s x4, x4, VX3
#else
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmadd.s VX1, VXAR, x1, VX0
    vfmsub.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfsub.s x4, x4, VX3
#endif
    addi.d  I, I, -1
    vstelm.w x3, YY, 0 * SIZE, 0
    vstelm.w x4, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 1
    vstelm.w x4, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 2
    vstelm.w x4, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 3
    vstelm.w x4, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    addi.d X, X, 8 * SIZE
    blt $r0, I, .L121
    b .L997
    .align 3

.L21:// INCX!=1 and INCY==1
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
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    add.d X, X, INCX
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
#if !defined(CONJ)
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmsub.s VX1, VXAR, x1, VX0
    vfmadd.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfadd.s x4, x4, VX3
#else
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmadd.s VX1, VXAR, x1, VX0
    vfmsub.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfsub.s x4, x4, VX3
#endif
    vilvl.w VX2, x4 ,x3
    vilvh.w VX3, x4, x3
    addi.d  I, I, -1
    vst VX2, Y, 0 * SIZE
    vst VX3, Y, 4 * SIZE
    addi.d Y, Y, 8 * SIZE
    blt $r0, I, .L211
    b .L997
    .align 3

.L22:
    bge $r0, I, .L997
    move YY, Y
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
    vinsgr2vr.w x3, t1, 2
    vinsgr2vr.w x4, t2, 2
    vinsgr2vr.w x3, t3, 3
    vinsgr2vr.w x4, t4, 3
    add.d Y, Y, INCY
#if !defined(CONJ)
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmsub.s VX1, VXAR, x1, VX0
    vfmadd.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfadd.s x4, x4, VX3
#else
    vfmul.s VX0, VXAI, x2
    vfmul.s VX2, VXAI, x1
    vfmadd.s VX1, VXAR, x1, VX0
    vfmsub.s VX3, x2, VXAR, VX2
    vfadd.s x3, x3, VX1
    vfsub.s x4, x4, VX3
#endif
    addi.d  I, I, -1
    vstelm.w x3, YY, 0 * SIZE, 0
    vstelm.w x4, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 1
    vstelm.w x4, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 2
    vstelm.w x4, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    vstelm.w x3, YY, 0 * SIZE, 3
    vstelm.w x4, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    blt $r0, I, .L222
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
    addi.d I, I, -1
#if !defined(CONJ)
    fmul.s s1, ALPHAI, a2
    fmul.s s2, ALPHAI, a1
    fmsub.s s3, ALPHAR, a1, s1
    fmadd.s s4, a2, ALPHAR, s2
    fadd.s s3, s3, a3
    fadd.s s4, s4, a4
#else
    fmul.s s1, ALPHAI, a2
    fmul.s s2, ALPHAI, a1
    fmadd.s s3, ALPHAR, a1, s1
    fmsub.s s4, a2, ALPHAR, s2
    fadd.s s3, s3, a3
    fsub.s s4, a4, s4
#endif
    fst.s s3, Y, 0 * SIZE
    fst.s s4, Y, 1 * SIZE
    add.d X, X, INCX
    add.d Y, Y, INCY
    blt $r0, I, .L998
    .align 3

.L999:
    move $r4, $r12
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
