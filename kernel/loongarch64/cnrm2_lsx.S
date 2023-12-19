#define ASSEMBLER

#include "common.h"

#define N      $r4
#define X      $r5
#define INCX   $r6
#define I      $r17
#define TEMP   $r18
#define t1     $r12
#define t2     $r13
#define t3     $r14
#define t4     $r15
#define a1     $f15
#define a2     $f16
#define res    $f19
#define VX0    $vr15
#define VX1    $vr16
#define VX2    $vr17
#define VX3    $vr18
#define VX4    $vr21
#define res1   $vr19
#define res2   $vr20

   PROLOGUE

#ifdef F_INTERFACE
   LDINT   N,     0(N)
   LDINT   INCX,  0(INCX)
#endif

   vxor.v res1, res1, res1
   vxor.v res2, res2, res2
   bge $r0, N, .L999
   beq $r0, INCX, .L999
   li.d  TEMP, 1
   slli.d TEMP, TEMP, ZBASE_SHIFT
   slli.d INCX, INCX, ZBASE_SHIFT
   srai.d I, N, 2
   bne INCX, TEMP, .L20
   bge $r0,  I, .L997
   .align 3

.L10:
   vld VX0, X, 0 * SIZE
   vfcvtl.d.s VX1, VX0
   vfcvth.d.s VX2, VX0
   vfmadd.d res1, VX1, VX1, res1
   vfmadd.d res2, VX2, VX2, res2
   vld VX0, X, 4 * SIZE
   vfcvtl.d.s VX3, VX0
   vfcvth.d.s VX4, VX0
   vfmadd.d res1, VX3, VX3, res1
   vfmadd.d res2, VX4, VX4, res2
   addi.d I, I, -1
   addi.d X, X, 8 * SIZE
   blt $r0, I, .L10
   b .L996
   .align 3

.L20:
   bge $r0, I, .L997
   .align 3

.L21:
   ld.w t1, X, 0 * SIZE
   ld.w t2, X, 1 * SIZE
   add.d X, X, INCX
   ld.w t3, X, 0 * SIZE
   ld.w t4, X, 1 * SIZE
   vinsgr2vr.w VX0, t1, 0
   vinsgr2vr.w VX0, t2, 1
   vinsgr2vr.w VX0, t3, 2
   vinsgr2vr.w VX0, t4, 3
   add.d X, X, INCX
   vfcvtl.d.s VX1, VX0
   vfcvth.d.s VX2, VX0
   vfmadd.d res1, VX1, VX1, res1
   vfmadd.d res2, VX2, VX2, res2
   ld.w t1, X, 0 * SIZE
   ld.w t2, X, 1 * SIZE
   add.d X, X, INCX
   ld.w t3, X, 0 * SIZE
   ld.w t4, X, 1 * SIZE
   vinsgr2vr.w VX0, t1, 0
   vinsgr2vr.w VX0, t2, 1
   vinsgr2vr.w VX0, t3, 2
   vinsgr2vr.w VX0, t4, 3
   add.d X, X, INCX
   vfcvtl.d.s VX3, VX0
   vfcvth.d.s VX4, VX0
   vfmadd.d res1, VX3, VX3, res1
   vfmadd.d res2, VX4, VX4, res2
   addi.d  I, I, -1
   blt $r0, I, .L21
   b .L996
   .align 3

.L996:
   vfadd.d res1, res1, res2
   vreplvei.d VX1, res1, 1
   vfadd.d res1, VX1, res1
   .align 3

.L997:
   andi I, N, 3
   bge $r0, I, .L999
   .align 3

.L998:
    fld.s a1, X, 0 * SIZE
    fld.s a2, X, 1 * SIZE
    addi.d I, I, -1
    fcvt.d.s a1, a1
    fcvt.d.s a2, a2
    fmadd.d res, a1, a1, res
    fmadd.d res, a2, a2, res
    add.d X, X, INCX
    blt $r0, I, .L998
    .align 3

.L999:
    fsqrt.d res, res
    move $r4, $r17
    fcvt.s.d $f0, $f19
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
