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
#define VX0    $xr12
#define VX1    $xr13
#define VX2    $xr14
#define VX3    $xr15
#define res1   $xr16
#define res2   $xr17
#define res3   $xr18
#define res0   $xr19
#define neg1   $xr20
#define VT0    $xr21
#define VT1    $xr22
    PROLOGUE
    xvxor.v res1, res1, res1
    xvxor.v res2, res2, res2
    xvxor.v res0, res0, res0
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.d t1, -1
    xvreplgr2vr.d neg1, t1
    xvffint.d.l neg1, neg1
    li.d  TEMP, 1
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    srai.d I, N, 3
    bne INCX, TEMP, .L20
    bge $r0, I, .L13
    .align 3

.L11:
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvfmul.d VX2, neg1, VX0
    xvfmul.d VX3, neg1, VX1
    xvfcmp.clt.d VT0, VX0, res0
    xvfcmp.clt.d VT1, VX1, res0
    xvbitsel.v VX0, VX0, VX2, VT0
    xvbitsel.v VX1, VX1, VX3, VT1
    xvfadd.d res2, VX0, VX1
    xvfadd.d res1, res1, res2
    xvld VX2, X, 8 * SIZE
    xvld VX3, X, 12 * SIZE
    xvfmul.d VX0, neg1, VX2
    xvfmul.d VX1, neg1, VX3
    xvfcmp.clt.d VT0, VX2, res0
    xvfcmp.clt.d VT1, VX3, res0
    xvbitsel.v VX2, VX2, VX0, VT0
    xvbitsel.v VX3, VX3, VX1, VT1
    xvfadd.d res2, VX2, VX3
    xvfadd.d res1, res1, res2
    addi.d X, X, 16 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L11
    .align 3

.L12:
    xvpickve.d VX1, res1, 1
    xvpickve.d VX2, res1, 2
    xvpickve.d VX3, res1, 3
    xvfadd.d res1, VX1, res1
    xvfadd.d res1, VX2, res1
    xvfadd.d res1, VX3, res1
    .align 3

.L13:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L14:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fabs.d a1, a1
    fabs.d a2, a2
    addi.d I, I, -1
    fadd.d a1, a1, a2
    fadd.d s1, a1, s1
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
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX0, t1, 0
    xvinsgr2vr.d VX0, t2, 1
    xvinsgr2vr.d VX0, t3, 2
    xvinsgr2vr.d VX0, t4, 3
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX1, t1, 0
    xvinsgr2vr.d VX1, t2, 1
    xvinsgr2vr.d VX1, t3, 2
    xvinsgr2vr.d VX1, t4, 3
    xvfmul.d VX2, neg1, VX0
    xvfmul.d VX3, neg1, VX1
    xvfcmp.clt.d VT0, VX0, res0
    xvfcmp.clt.d VT1, VX1, res0
    xvbitsel.v VX0, VX0, VX2, VT0
    xvbitsel.v VX1, VX1, VX3, VT1
    xvfadd.d res2, VX0, VX1
    xvfadd.d res1, res1, res2
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX0, t1, 0
    xvinsgr2vr.d VX0, t2, 1
    xvinsgr2vr.d VX0, t3, 2
    xvinsgr2vr.d VX0, t4, 3
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX1, t1, 0
    xvinsgr2vr.d VX1, t2, 1
    xvinsgr2vr.d VX1, t3, 2
    xvinsgr2vr.d VX1, t4, 3
    xvfmul.d VX2, neg1, VX0
    xvfmul.d VX3, neg1, VX1
    xvfcmp.clt.d VT0, VX0, res0
    xvfcmp.clt.d VT1, VX1, res0
    xvbitsel.v VX0, VX0, VX2, VT0
    xvbitsel.v VX1, VX1, VX3, VT1
    xvfadd.d res2, VX0, VX1
    xvfadd.d res1, res1, res2
    addi.d  I, I, -1
    blt $r0, I, .L21
    .align 3

.L22:
    xvpickve.d VX1, res1, 1
    xvpickve.d VX2, res1, 2
    xvpickve.d VX3, res1, 3
    xvfadd.d res1, VX1, res1
    xvfadd.d res1, VX2, res1
    xvfadd.d res1, VX3, res1
    .align 3

.L23:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L24:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    fabs.d a1, a1
    fabs.d a2, a2
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
