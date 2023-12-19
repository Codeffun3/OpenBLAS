#define ASSEMBLER

#include "common.h"
#define N      $r4
#define X      $r5
#define INCX   $r6
#define Y      $r7
#define INCY   $r8
#define C      $f0
#define S      $f1

#define I      $r12
#define TEMP   $r13
#define t1     $r14
#define t2     $r16
#define t3     $r15
#define t4     $r17
#define XX     $r18
#define YY     $r19
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
#define VT0    $vr10
#define VT1    $vr18
#define VXC    $vr23
#define VXS    $vr9
#define VXZ    $vr11
#define x1     $vr12
#define x2     $vr13
#define x3     $vr14
#define x4     $vr15

    PROLOGUE

    bge $r0, N, .L999
    li.d TEMP, 1
    movgr2fr.d a1, $r0
    ffint.s.l a1, a1
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    slli.d  INCY, INCY, ZBASE_SHIFT
    movfr2gr.s t1, C
    vreplgr2vr.w VXC, t1
    movfr2gr.s t2, S
    vreplgr2vr.w VXS, t2
    movfr2gr.s t3, a1
    vreplgr2vr.w VXZ, t3
    srai.d I, N, 2
    beq INCX, $r0, .L996
    beq INCY, $r0, .L996
    bne INCX, TEMP, .L22 // INCX!=1 or INCY!=1
    bne INCY, TEMP, .L22

.L11:
    bge $r0, I, .L997
    fcmp.ceq.s $fcc0, C, a1
    bcnez $fcc0, .L110
    fcmp.ceq.s $fcc0, S, a1
    bcnez $fcc0, .L112 // C!=0 S==0
    b .L111 // C!=0 S!=0
    .align 3

.L110:
    fcmp.ceq.s $fcc0, S, a1
    bcnez $fcc0, .L114 // C==0 S==0
    b .L113 // C==0 S!=0
    .align 3

.L111: // C!=0 S!=0
    vld VX0, X, 0 * SIZE
    vld VX2, Y, 0 * SIZE
    vld VX1, X, 4 * SIZE
    vld VX3, Y, 4 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
    vfmul.s VX0, x1, VXC
    vfmadd.s VX0, x3, VXS, VX0
    vfmul.s VX1, x1, VXS
    vfmsub.s VX1, x3, VXC, VX1
    vfmul.s VX2, x2, VXC
    vfmadd.s VX2, x4, VXS, VX2
    vfmul.s VX3, x2, VXS
    vfmsub.s VX3, x4, VXC, VX3
    vilvl.w x1, VX2 ,VX0
    vilvh.w x2, VX2, VX0
    vilvl.w x3, VX3 ,VX1
    vilvh.w x4, VX3, VX1
    vst x1, X, 0 * SIZE
    vst x3, Y, 0 * SIZE
    vst x2, X, 4 * SIZE
    vst x4, Y, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    b .L997
    .align 3

.L112: // C!=0 S==0
    vld VX0, X, 0 * SIZE
    vld VX2, Y, 0 * SIZE
    vld VX1, X, 4 * SIZE
    vld VX3, Y, 4 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
    vfmul.s VX0, x1, VXC
    vfmul.s VX1, x3, VXC
    vfmul.s VX2, x2, VXC
    vfmul.s VX3, x4, VXC
    vilvl.w x1, VX2 ,VX0
    vilvh.w x2, VX2, VX0
    vilvl.w x3, VX3 ,VX1
    vilvh.w x4, VX3, VX1
    vst x1, X, 0 * SIZE
    vst x3, Y, 0 * SIZE
    vst x2, X, 4 * SIZE
    vst x4, Y, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L112
    b .L997
    .align 3

.L113: // C==0 S!=0
    vld VX0, X, 0 * SIZE
    vld VX2, Y, 0 * SIZE
    vld VX1, X, 4 * SIZE
    vld VX3, Y, 4 * SIZE
    vpickev.w x1, VX1, VX0
    vpickod.w x2, VX1, VX0
    vpickev.w x3, VX3, VX2
    vpickod.w x4, VX3, VX2
    vfmul.s VX0, x3, VXS
    vfmul.s VX1, x1, VXS
    vfsub.s VX1, VXZ, VX1
    vfmul.s VX2, x4, VXS
    vfmul.s VX3, x2, VXS
    vfsub.s VX3, VXZ, VX3
    vilvl.w x1, VX2 ,VX0
    vilvh.w x2, VX2, VX0
    vilvl.w x3, VX3 ,VX1
    vilvh.w x4, VX3, VX1
    vst x1, X, 0 * SIZE
    vst x3, Y, 0 * SIZE
    vst x2, X, 4 * SIZE
    vst x4, Y, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L113
    b .L997
    .align 3

.L114: // C==0 S==0
    vst VXZ, X, 0 * SIZE
    vst VXZ, Y, 0 * SIZE
    vst VXZ, X, 4 * SIZE
    vst VXZ, Y, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d Y, Y, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L114
    b .L997
    .align 3

.L22:
    bge $r0, I, .L997
    move YY, Y
    move XX, X
    fcmp.ceq.s $fcc0, C, a1
    bcnez $fcc0, .L220
    fcmp.ceq.s $fcc0, S, a1
    bcnez $fcc0, .L222 // C!=0 S==0
    b .L221 // C!=0 S!=0
    .align 3

.L220:
    fcmp.ceq.s $fcc0, S, a1
    bcnez $fcc0, .L224 // C==0 S==0
    b .L223 // C==0 S!=0
    .align 3

.L221: // C!=0 S!=0
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
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    add.d X, X, INCX
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

    vfmul.s VX0, x1, VXC
    vfmadd.s VX0, x3, VXS, VX0
    vfmul.s VX1, x1, VXS
    vfmsub.s VX1, x3, VXC, VX1
    vfmul.s VX2, x2, VXC
    vfmadd.s VX2, x4, VXS, VX2
    vfmul.s VX3, x2, VXS
    vfmsub.s VX3, x4, VXC, VX3
    vstelm.w VX0, XX, 0, 0
    vstelm.w VX2, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 1
    vstelm.w VX2, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 2
    vstelm.w VX2, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 3
    vstelm.w VX2, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    vstelm.w VX1, YY, 0, 0
    vstelm.w VX3, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 1
    vstelm.w VX3, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 2
    vstelm.w VX3, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 3
    vstelm.w VX3, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    addi.d  I, I, -1
    blt $r0, I, .L221
    b .L997
    .align 3

.L222: // C!=0 S==0
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
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    add.d X, X, INCX
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
    vfmul.s VX0, x1, VXC
    vfmul.s VX1, x3, VXC
    vfmul.s VX2, x2, VXC
    vfmul.s VX3, x4, VXC
    vstelm.w VX0, XX, 0, 0
    vstelm.w VX2, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 1
    vstelm.w VX2, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 2
    vstelm.w VX2, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 3
    vstelm.w VX2, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    vstelm.w VX1, YY, 0, 0
    vstelm.w VX3, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 1
    vstelm.w VX3, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 2
    vstelm.w VX3, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 3
    vstelm.w VX3, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    addi.d  I, I, -1
    blt $r0, I, .L222
    b .L997
    .align 3

.L223: // C==0 S!=0
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
    vinsgr2vr.w x1, t1, 2
    vinsgr2vr.w x2, t2, 2
    vinsgr2vr.w x1, t3, 3
    vinsgr2vr.w x2, t4, 3
    add.d X, X, INCX
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
    vfmul.s VX0, x3, VXS
    vfmul.s VX1, x1, VXS
    vfsub.s VX1, VXZ, VX1
    vfmul.s VX2, x4, VXS
    vfmul.s VX3, x2, VXS
    vfsub.s VX3, VXZ, VX3
    vstelm.w VX0, XX, 0, 0
    vstelm.w VX2, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 1
    vstelm.w VX2, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 2
    vstelm.w VX2, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    vstelm.w VX0, XX, 0, 3
    vstelm.w VX2, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    vstelm.w VX1, YY, 0, 0
    vstelm.w VX3, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 1
    vstelm.w VX3, YY, 1 * SIZE, 1
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 2
    vstelm.w VX3, YY, 1 * SIZE, 2
    add.d YY, YY, INCY
    vstelm.w VX1, YY, 0, 3
    vstelm.w VX3, YY, 1 * SIZE, 3
    add.d YY, YY, INCY
    addi.d  I, I, -1
    blt $r0, I, .L223
    b .L997
    .align 3

.L224: // C==0 S==0
    vstelm.w VXZ, XX, 0, 0
    vstelm.w VXZ, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VXZ, XX, 0, 0
    vstelm.w VXZ, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VXZ, XX, 0, 0
    vstelm.w VXZ, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VXZ, XX, 0, 0
    vstelm.w VXZ, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    vstelm.w VXZ, YY, 0, 0
    vstelm.w VXZ, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VXZ, YY, 0, 0
    vstelm.w VXZ, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VXZ, YY, 0, 0
    vstelm.w VXZ, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    vstelm.w VXZ, YY, 0, 0
    vstelm.w VXZ, YY, 1 * SIZE, 0
    add.d YY, YY, INCY
    addi.d  I, I, -1
    blt $r0, I, .L224
    move X, XX
    move Y, YY
    b .L997
    .align 3

.L996:
    move I, N
    b .L998
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
    fmul.s s1, a1, C
    fmadd.s s1, a3, S, s1
    fmul.s s2, a1, S
    fmsub.s s2, a3, C, s2
    fmul.s s3, a2, C
    fmadd.s s3, a4, S, s3
    fmul.s s4, a2, S
    fmsub.s s4, a4, C, s4
    addi.d I, I, -1
    fst.s s1, X, 0 * SIZE
    fst.s s2, Y, 0 * SIZE
    fst.s s3, X, 1 * SIZE
    fst.s s4, Y, 1 * SIZE
    add.d  X, X, INCX
    add.d  Y, Y, INCY
    blt $r0, I, .L998
    .align 3

.L999:
    move $r4, $r12
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE