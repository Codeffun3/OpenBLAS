#define ASSEMBLER

#include "common.h"
#define N      $r4
#define X      $r5
#define INCX   $r6
#define Y      $r7
#define INCY   $r8
#define I      $r17
#define TEMP   $r18
#define t1     $r14
#define t2     $r15
#define t3     $r16
#define t4     $r19
#define a1     $f12
#define a2     $f13
#define a3     $f14
#define a4     $f15
#define VX0    $xr12
#define VX1    $xr13
#define VX2    $xr14
#define VX3    $xr15

    PROLOGUE
    bge $r0, N, .L999
    li.d TEMP, 1
    slli.d  TEMP, TEMP, ZBASE_SHIFT
    slli.d  INCX, INCX, ZBASE_SHIFT
    slli.d  INCY, INCY, ZBASE_SHIFT
    srai.d I, N, 3
    bne INCX, TEMP, .L20
    bne INCY, TEMP, .L12 // INCX==1 and INCY!=1
    b .L11  // INCX==1 and INCY==1
.L20:
    bne INCY, TEMP, .L22 // INCX!=1 and INCY!=1
    b .L21 // INCX!=1 and INCY==1

.L11:
    bge $r0, I, .L112
    .align 3

.L111:
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvld VX2, X, 8 * SIZE
    xvld VX3, X, 12 * SIZE
    xvst VX0, Y, 0 * SIZE
    xvst VX1, Y, 4 * SIZE
    xvst VX2, Y, 8 * SIZE
    xvst VX3, Y, 12 * SIZE
    addi.d X, X, 16 * SIZE
    addi.d Y, Y, 16 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L111
    .align 3

.L112:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L113:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    addi.d I, I, -1
    addi.d X, X, 2 * SIZE
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    addi.d Y, Y, 2 * SIZE
    blt $r0, I, .L113
    b .L999
    .align 3

.L12:
    bge $r0, I, .L122
    .align 3

.L121:
    xvld VX0, X, 0 * SIZE
    xvld VX1, X, 4 * SIZE
    xvld VX2, X, 8 * SIZE
    xvld VX3, X, 12 * SIZE
    xvstelm.d VX0, Y, 0 * SIZE, 0
    xvstelm.d VX0, Y, 1 * SIZE, 1
    add.d Y, Y, INCY
    xvstelm.d VX0, Y, 0 * SIZE, 2
    xvstelm.d VX0, Y, 1 * SIZE, 3
    add.d Y, Y, INCY
    xvstelm.d VX1, Y, 0 * SIZE, 0
    xvstelm.d VX1, Y, 1 * SIZE, 1
    add.d Y, Y, INCY
    xvstelm.d VX1, Y, 0 * SIZE, 2
    xvstelm.d VX1, Y, 1 * SIZE, 3
    add.d Y, Y, INCY
    xvstelm.d VX2, Y, 0 * SIZE, 0
    xvstelm.d VX2, Y, 1 * SIZE, 1
    add.d Y, Y, INCY
    xvstelm.d VX2, Y, 0 * SIZE, 2
    xvstelm.d VX2, Y, 1 * SIZE, 3
    add.d Y, Y, INCY
    xvstelm.d VX3, Y, 0 * SIZE, 0
    xvstelm.d VX3, Y, 1 * SIZE, 1
    add.d Y, Y, INCY
    xvstelm.d VX3, Y, 0 * SIZE, 2
    xvstelm.d VX3, Y, 1 * SIZE, 3
    add.d Y, Y, INCY
    addi.d X, X, 16 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L121
    .align 3

.L122:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L123:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    addi.d I, I, -1
    addi.d  X, X, 2 * SIZE
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d  Y, Y, INCY
    blt $r0, I, .L123
    b .L999
    .align 3

.L21:
    bge $r0, I, .L212
    .align 3

.L211:
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
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX2, t1, 0
    xvinsgr2vr.d VX2, t2, 1
    xvinsgr2vr.d VX2, t3, 2
    xvinsgr2vr.d VX2, t4, 3
    ld.d t1, X, 0 * SIZE
    ld.d t2, X, 1 * SIZE
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.d VX3, t1, 0
    xvinsgr2vr.d VX3, t2, 1
    xvinsgr2vr.d VX3, t3, 2
    xvinsgr2vr.d VX3, t4, 3
    xvst VX0, Y, 0 * SIZE
    addi.d  I, I, -1
    xvst VX1, Y, 4 * SIZE
    xvst VX2, Y, 8 * SIZE
    xvst VX3, Y, 12 * SIZE
    addi.d Y, Y, 16 * SIZE
    blt $r0, I, .L211
    .align 3

.L212:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L213:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    addi.d I, I, -1
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d  X, X, INCX
    addi.d  Y, Y, 2 * SIZE
    blt $r0, I, .L213
    b .L999
    .align 3


.L22:
    bgez INCX, .L220
    .align 3

.L220:
    bge $r0, I, .L223
    .align 3

.L222:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    add.d X, X, INCX
    fld.d a3, X, 0 * SIZE
    fld.d a4, X, 1 * SIZE
    add.d X, X, INCX
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d Y, Y, INCY
    fst.d a3, Y, 0 * SIZE
    fst.d a4, Y, 1 * SIZE
    add.d Y, Y, INCY

    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    add.d X, X, INCX
    fld.d a3, X, 0 * SIZE
    fld.d a4, X, 1 * SIZE
    add.d X, X, INCX
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d Y, Y, INCY
    fst.d a3, Y, 0 * SIZE
    fst.d a4, Y, 1 * SIZE
    add.d Y, Y, INCY

    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    add.d X, X, INCX
    fld.d a3, X, 0 * SIZE
    fld.d a4, X, 1 * SIZE
    add.d X, X, INCX
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d Y, Y, INCY
    fst.d a3, Y, 0 * SIZE
    fst.d a4, Y, 1 * SIZE
    add.d Y, Y, INCY

    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    add.d X, X, INCX
    fld.d a3, X, 0 * SIZE
    fld.d a4, X, 1 * SIZE
    add.d X, X, INCX
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d Y, Y, INCY
    fst.d a3, Y, 0 * SIZE
    fst.d a4, Y, 1 * SIZE
    add.d Y, Y, INCY
    addi.d  I, I, -1
    blt $r0, I, .L222
    .align 3

.L223:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L224:
    fld.d a1, X, 0 * SIZE
    fld.d a2, X, 1 * SIZE
    addi.d I, I, -1
    fst.d a1, Y, 0 * SIZE
    fst.d a2, Y, 1 * SIZE
    add.d  X, X, INCX
    add.d  Y, Y, INCY
    blt $r0, I, .L224
    .align 3

.L999:
    move $r4, $r12
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
