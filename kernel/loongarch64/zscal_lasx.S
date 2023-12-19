#define ASSEMBLER

#include "common.h"
#define N      $r4
#define ALPHAR $f0
#define ALPHAI $f1
#define X      $r7
#define INCX   $r8

#define I      $r12
#define TEMP   $r13
#define t1     $r14
#define t2     $r16
#define t3     $r15
#define t4     $r17
#define XX     $r18
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
#define VXZ    $xr12
#define x1     $xr18
#define x2     $xr17
#define x3     $xr16
#define x4     $xr15

    PROLOGUE

    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.d TEMP, 1
    movgr2fr.d a1, $r0
    ffint.d.l a1, a1
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    movfr2gr.d t1, ALPHAR
    xvreplgr2vr.d VXAR, t1
    movfr2gr.d t2, ALPHAI
    xvreplgr2vr.d VXAI, t2
    xvxor.v VXZ, VXZ, VXZ
    srai.d I, N, 2
    bne INCX, TEMP, .L22

.L11:
    bge $r0, I, .L997
    fcmp.ceq.d $fcc0, ALPHAR, a1
    fcmp.ceq.d $fcc1, ALPHAI, a1
    bceqz $fcc0, .L13
    b .L14
    .align 3

.L13:
    bceqz $fcc1, .L114 //alpha_r != 0.0 && alpha_i != 0.0
    b .L113 //alpha_r != 0.0 && alpha_i == 0.0

.L14:
    bceqz $fcc1, .L112  //alpha_r == 0.0 && alpha_i != 0.0
    b .L111 //alpha_r == 0.0 && alpha_i == 0.0
    .align 3

.L111:  //alpha_r == 0.0 && alpha_i == 0.0
    xvst VXZ, X, 0 * SIZE
    xvst VXZ, X, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    b .L997
    .align 3

.L112:  //alpha_r == 0.0 && alpha_i != 0.0
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
    xvfmul.d x3, VXAI, x2
    xvfsub.d x3, VXZ, x3
    xvfmul.d x4, VXAI, x1
    xvilvl.d VX2, x4 ,x3
    xvilvh.d VX3, x4, x3
    xvst VX2, X, 0 * SIZE
    xvst VX3, X, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L112
    b .L997
    .align 3

.L113: //alpha_r != 0.0 && alpha_i == 0.0
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
    xvfmul.d x3, VXAR, x1
    xvfmul.d x4, VXAR, x2
    xvilvl.d VX2, x4 ,x3
    xvilvh.d VX3, x4, x3
    xvst VX2, X, 0 * SIZE
    xvst VX3, X, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L113
    b .L997
    .align 3

.L114:  //alpha_r != 0.0 && alpha_i != 0.0
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
    xvfmul.d VX0, VXAI, x2
    xvfmsub.d x3, VXAR, x1, VX0
    xvfmul.d VX1, VXAI, x1
    xvfmadd.d x4, VXAR, x2, VX1
    xvilvl.d VX2, x4 ,x3
    xvilvh.d VX3, x4, x3
    xvst VX2, X, 0 * SIZE
    xvst VX3, X, 4 * SIZE
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L114
    b .L997
    .align 3

.L22:
    bge $r0, I, .L997
    move XX, X
    fcmp.ceq.d $fcc0, ALPHAR, a1
    fcmp.ceq.d $fcc1, ALPHAI, a1
    bceqz $fcc0, .L23
    b .L24
    .align 3

.L23:
    bceqz $fcc1, .L224 //alpha_r != 0.0 && alpha_i != 0.0
    b .L223 //alpha_r != 0.0 && alpha_i == 0.0

.L24:
    bceqz $fcc1, .L222  //alpha_r == 0.0 && alpha_i != 0.0
    b .L221 //alpha_r == 0.0 && alpha_i == 0.0
    .align 3

.L221:  //alpha_r == 0.0 && alpha_i == 0.0
    xvstelm.d VXZ, X, 0, 0
    xvstelm.d VXZ, X, 1 * SIZE, 0
    add.d X, X, INCX
    xvstelm.d VXZ, X, 0, 0
    xvstelm.d VXZ, X, 1 * SIZE, 0
    add.d X, X, INCX
    xvstelm.d VXZ, X, 0, 0
    xvstelm.d VXZ, X, 1 * SIZE, 0
    add.d X, X, INCX
    xvstelm.d VXZ, X, 0, 0
    xvstelm.d VXZ, X, 1 * SIZE, 0
    add.d X, X, INCX
    addi.d  I, I, -1
    blt $r0, I, .L221
    b .L997
    .align 3

.L222:  //alpha_r == 0.0 && alpha_i != 0.0
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
    xvinsgr2vr.d x1, t1, 2
    xvinsgr2vr.d x2, t2, 2
    xvinsgr2vr.d x1, t3, 3
    xvinsgr2vr.d x2, t4, 3
    add.d X, X, INCX

    xvfmul.d x3, VXAI, x2
    xvfsub.d x3, VXZ, x3
    xvfmul.d x4, VXAI, x1
    addi.d  I, I, -1
    xvstelm.d x3, XX, 0 * SIZE, 0
    xvstelm.d x4, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 1
    xvstelm.d x4, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 2
    xvstelm.d x4, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 3
    xvstelm.d x4, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    blt $r0, I, .L222
    b .L997
    .align 3

.L223: //alpha_r != 0.0 && alpha_i == 0.0
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
    xvinsgr2vr.d x1, t1, 2
    xvinsgr2vr.d x2, t2, 2
    xvinsgr2vr.d x1, t3, 3
    xvinsgr2vr.d x2, t4, 3
    add.d X, X, INCX

    xvfmul.d x3, VXAR, x1
    xvfmul.d x4, VXAR, x2
    addi.d  I, I, -1
    xvstelm.d x3, XX, 0 * SIZE, 0
    xvstelm.d x4, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 1
    xvstelm.d x4, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 2
    xvstelm.d x4, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 3
    xvstelm.d x4, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    blt $r0, I, .L223
    b .L997
    .align 3

.L224:  //alpha_r != 0.0 && alpha_i != 0.0
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
    xvinsgr2vr.d x1, t1, 2
    xvinsgr2vr.d x2, t2, 2
    xvinsgr2vr.d x1, t3, 3
    xvinsgr2vr.d x2, t4, 3
    add.d X, X, INCX

    xvfmul.d VX0, VXAI, x2
    xvfmsub.d x3, VXAR, x1, VX0
    xvfmul.d VX1, VXAI, x1
    xvfmadd.d x4, VXAR, x2, VX1
    addi.d  I, I, -1
    xvstelm.d x3, XX, 0 * SIZE, 0
    xvstelm.d x4, XX, 1 * SIZE, 0
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 1
    xvstelm.d x4, XX, 1 * SIZE, 1
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 2
    xvstelm.d x4, XX, 1 * SIZE, 2
    add.d XX, XX, INCX
    xvstelm.d x3, XX, 0 * SIZE, 3
    xvstelm.d x4, XX, 1 * SIZE, 3
    add.d XX, XX, INCX
    blt $r0, I, .L224
    b .L997
    .align 3

.L997:
    andi I, N, 3
    bge $r0, I, .L999
    .align 3

.L998:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    addi.d I, I, -1
    fmul.d s1, ALPHAI, a2
    fmul.d s2, ALPHAI, a1
    fmsub.d s1, ALPHAR, a1, s1
    fmadd.d s2, ALPHAR, a2, s2
    fst.d s1, X, 0 * SIZE
    fst.d s2, X, 1 * SIZE
    add.d X, X, INCX
    blt $r0, I, .L998
    .align 3

.L999:
    move $r4, $r12
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
