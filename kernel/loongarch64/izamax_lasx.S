#define ASSEMBLER

#include "common.h"

#define N $r4
#define X $r5
#define INCX $r6
#define I $r12
#define t1 $r13
#define t2 $r15
#define t3 $r18
#define t4 $r16
#define i0 $r17
#define i1 $r14
#define TEMP $r19
#define a0 $f12
#define a1 $f13
#define s1 $f15
#define x1 $xr9
#define x2 $xr10
#define x3 $xr11
#define x4 $xr12
#define VX0 $xr13
#define VX1 $xr14
#define VM0 $xr15
#define VM1 $xr16
#define VINC4 $xr17
#define VINC8 $xr18
#define VI0 $xr20
#define VI1 $xr21
#define VI2 $xr22
#define VI3 $xr8
#define VI4 $xr19
#define VT0 $xr23

    PROLOGUE
    li.d  i0, 0
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.d TEMP, 1
    xvxor.v VM0, VM0, VM0
    slli.d TEMP, TEMP, ZBASE_SHIFT
    slli.d INCX, INCX, ZBASE_SHIFT
    xvxor.v VI3, VI3, VI3 // 0
    li.d I, -1
    xvreplgr2vr.d VI4, I
    xvffint.d.l VI4, VI4 // -1
    bne INCX, TEMP, .L20
    addi.d i0, i0, 1
    srai.d I, N, 2
    bge $r0, I, .L21
    slli.d i0, i0, 2 //4
    xvreplgr2vr.d VINC4, i0
    addi.d i0, i0, -7
    xvinsgr2vr.d VI1, i0, 0 //initialize the index value for vectorization
    addi.d i0, i0, 2
    xvinsgr2vr.d VI1, i0, 1
    addi.d i0, i0, -1
    xvinsgr2vr.d VI1, i0, 2
    addi.d i0, i0, 2
    xvinsgr2vr.d VI1, i0, 3
    addi.d i0, i0, 1
    xvinsgr2vr.d VI0, i0, 0 //1
    addi.d i0, i0, 2
    xvinsgr2vr.d VI0, i0, 1 //3
    addi.d i0, i0, -1
    xvinsgr2vr.d VI0, i0, 2 //2
    addi.d i0, i0, 2
    xvinsgr2vr.d VI0, i0, 3 //4
    .align 3

.L10:
    xvld VX0, X, 0 * SIZE
    xvadd.d VI1, VI1, VINC4
    xvld VX1, X, 4 * SIZE
    addi.d I, I, -1
    xvpickev.d x1, VX1, VX0
    xvpickod.d x2, VX1, VX0
    xvfmul.d x3, VI4, x1
    xvfmul.d x4, VI4, x2
    xvfcmp.clt.d VT0, x1, VI3
    xvfcmp.clt.d VINC8, x2, VI3
    xvbitsel.v x1, x1, x3, VT0
    xvbitsel.v x2, x2, x4, VINC8
    xvfadd.d x1, x1, x2
    xvfmax.d x3, VM0, x1
    xvfcmp.ceq.d VT0, x3, VM0
    addi.d X, X, 8 * SIZE
    xvbitsel.v VM0, x3, VM0, VT0
    xvbitsel.v VI0, VI1, VI0, VT0
    blt $r0, I, .L10
    .align 3

.L15:
    xvpickve.d VI1, VI0, 0
    xvpickve.d VI2, VI0, 1
    xvpickve.d VI3, VI0, 2
    xvpickve.d VI4, VI0, 3
    xvpickve.d x1, VM0, 0
    xvpickve.d x2, VM0, 1
    xvpickve.d x3, VM0, 2
    xvpickve.d x4, VM0, 3
    xvfmax.d VM1, x1, x2
    xvfcmp.ceq.d VT0, VM1, x1
    xvbitsel.v VINC4, VI2, VI1, VT0
    xvfmax.d VM0, x3, x4
    xvfcmp.ceq.d VT0, x3, VM0
    xvbitsel.v VINC8, VI4, VI3, VT0
    xvfmax.d VM0, VM0, VM1
    xvfcmp.ceq.d VT0, VM0, VM1
    xvbitsel.v VI0, VINC8, VINC4, VT0
    //处理尾数相等时取最小序号
    fcmp.ceq.d $fcc0, $f15, $f9
    bceqz $fcc0, .L26
    xvfcmp.clt.d VT0, VI1, VI0
    xvbitsel.v VI0, VI0, VI1, VT0
    b .L26
    .align 3

.L20: // INCX!=1
    addi.d i0, i0, 1
    srai.d I, N, 2
    bge $r0, I, .L21
    slli.d i0, i0, 2 //4
    xvreplgr2vr.d VINC4, i0
    addi.d i0, i0, -7
    xvinsgr2vr.d VI1, i0, 0 //initialize the index value for vectorization
    addi.d i0, i0, 2
    xvinsgr2vr.d VI1, i0, 1
    addi.d i0, i0, -1
    xvinsgr2vr.d VI1, i0, 2
    addi.d i0, i0, 2
    xvinsgr2vr.d VI1, i0, 3
    addi.d i0, i0, 1
    xvinsgr2vr.d VI0, i0, 0 //1
    addi.d i0, i0, 2
    xvinsgr2vr.d VI0, i0, 1 //3
    addi.d i0, i0, -1
    xvinsgr2vr.d VI0, i0, 2 //2
    addi.d i0, i0, 2
    xvinsgr2vr.d VI0, i0, 3 //4
    .align 3

.L24:
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
    xvadd.d VI1, VI1, VINC4
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
    addi.d I, I, -1
    xvfmul.d x3, VI4, x1
    xvfmul.d x4, VI4, x2
    xvfcmp.clt.d VT0, x1, VI3
    xvfcmp.clt.d VINC8, x2, VI3
    xvbitsel.v x1, x1, x3, VT0
    xvbitsel.v x2, x2, x4, VINC8
    xvfadd.d x1, x1, x2
    xvfmax.d x3, VM0, x1
    xvfcmp.ceq.d VT0, x3, VM0
    xvbitsel.v VM0, x3, VM0, VT0
    xvbitsel.v VI0, VI1, VI0, VT0
    blt $r0, I, .L24
    .align 3

.L25:
    xvpickve.d VI1, VI0, 0
    xvpickve.d VI2, VI0, 1
    xvpickve.d VI3, VI0, 2
    xvpickve.d VI4, VI0, 3
    xvpickve.d x1, VM0, 0
    xvpickve.d x2, VM0, 1
    xvpickve.d x3, VM0, 2
    xvpickve.d x4, VM0, 3
    xvfmaxa.d VM1, x1, x2
    xvfcmp.ceq.d VT0, VM1, x1
    xvbitsel.v VINC4, VI2, VI1, VT0
    xvfmaxa.d VM0, x3, x4
    xvfcmp.ceq.d VT0, x3, VM0
    xvbitsel.v VINC8, VI4, VI3, VT0
    xvfmaxa.d VM0, VM0, VM1
    xvfcmp.ceq.d VT0, VM0, VM1
    xvbitsel.v VI0, VINC8, VINC4, VT0
    //处理尾数相等时取最小序号
    fcmp.ceq.d $fcc0, $f15, $f9
    bceqz $fcc0, .L26
    xvfcmp.clt.d VT0, VI1, VI0
    xvbitsel.v VI0, VI0, VI1, VT0
    .align 3

.L26:
    fcmp.ceq.d $fcc0, $f15, $f10
    bceqz $fcc0, .L27
    xvfcmp.clt.d VT0, VI2, VI0
    xvbitsel.v VI0, VI0, VI2, VT0
    .align 3

.L27:
    fcmp.ceq.d $fcc0, $f15, $f11
    bceqz $fcc0, .L28
    xvfcmp.clt.d VT0, VI3, VI0
    xvbitsel.v VI0, VI0, VI3, VT0
    .align 3

.L28:
    fcmp.ceq.d $fcc0, $f15, $f12
    bceqz $fcc0, .L29
    xvfcmp.clt.d VT0, VI4, VI0
    xvbitsel.v VI0, VI0, VI4, VT0
    .align 3

.L29:
    movfr2gr.d i0, $f20
    .align 3

.L21: //N<4
    andi I, N, 3
    bge $r0, I, .L999
    srai.d i1, N, 2
    slli.d i1, i1, 2
    addi.d i1, i1, 1 //current index
    movgr2fr.d $f21, i1
    movgr2fr.d $f20, i0
    .align 3

.L22:
    LD a0, X, 0 * SIZE
    LD a1, X, 1 * SIZE
    addi.d I, I, -1
    FABS a0, a0
    FABS a1, a1
    ADD a0, a0, a1
    fmax.d a1, s1, a0
    fcmp.ceq.d $fcc0, s1, a1
    add.d  X, X, INCX
    fsel s1, a1, s1, $fcc0
    fsel $f20, $f21, $f20, $fcc0
    addi.d i1, i1, 1
    movgr2fr.d $f21, i1
    blt $r0, I, .L22
    movfr2gr.d i0, $f20
    .align 3

.L999:
    move $r4, $r17
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE
