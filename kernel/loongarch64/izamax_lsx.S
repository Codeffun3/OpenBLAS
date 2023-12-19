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
#define x1 $vr9
#define x2 $vr10
#define x3 $vr11
#define x4 $vr12
#define VX0 $vr13
#define VX1 $vr14
#define VM0 $vr15
#define VM1 $vr16
#define VINC4 $vr17
#define VINC8 $vr18
#define VI0 $vr20
#define VI1 $vr21
#define VI2 $vr22
#define VI3 $vr8
#define VI4 $vr19
#define VT0 $vr23

    PROLOGUE
    li.d  i0, 0
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.d TEMP, 1
    vxor.v VM0, VM0, VM0
    slli.d TEMP, TEMP, ZBASE_SHIFT
    slli.d INCX, INCX, ZBASE_SHIFT
    vxor.v VI3, VI3, VI3 // 0
    li.d I, -1
    vreplgr2vr.d VI4, I
    vffint.d.l VI4, VI4 // -1
    bne INCX, TEMP, .L20
    addi.d i0, i0, 1
    srai.d I, N, 2
    bge $r0, I, .L21
    slli.d i0, i0, 1 //2
    vreplgr2vr.d VINC4, i0
    addi.d i0, i0, -3
    vinsgr2vr.d VI1, i0, 0 //initialize the index value for vectorization
    addi.d i0, i0, 1
    vinsgr2vr.d VI1, i0, 1
    addi.d i0, i0, 1
    vinsgr2vr.d VI0, i0, 0 //1
    addi.d i0, i0, 1
    vinsgr2vr.d VI0, i0, 1 //2
    .align 3

.L10:
    vld VX0, X, 0 * SIZE
    vadd.d VI1, VI1, VINC4
    vld VX1, X, 2 * SIZE
    addi.d I, I, -1
    vpickev.d x1, VX1, VX0
    vpickod.d x2, VX1, VX0
    vfmul.d x3, VI4, x1
    vfmul.d x4, VI4, x2
    vfcmp.clt.d VT0, x1, VI3
    vfcmp.clt.d VINC8, x2, VI3
    vbitsel.v x1, x1, x3, VT0
    vbitsel.v x2, x2, x4, VINC8
    vfadd.d x1, x1, x2
    vfmax.d x3, VM0, x1
    vfcmp.ceq.d VT0, x3, VM0
    vbitsel.v VM0, x3, VM0, VT0
    vbitsel.v VI0, VI1, VI0, VT0
    vld VX0, X, 4 * SIZE
    vadd.d VI1, VI1, VINC4
    vld VX1, X, 6 * SIZE
    vpickev.d x1, VX1, VX0
    vpickod.d x2, VX1, VX0
    vfmul.d x3, VI4, x1
    vfmul.d x4, VI4, x2
    vfcmp.clt.d VT0, x1, VI3
    vfcmp.clt.d VINC8, x2, VI3
    vbitsel.v x1, x1, x3, VT0
    vbitsel.v x2, x2, x4, VINC8
    addi.d X, X, 8 * SIZE
    vfadd.d x1, x1, x2
    vfmax.d x3, VM0, x1
    vfcmp.ceq.d VT0, x3, VM0
    vbitsel.v VM0, x3, VM0, VT0
    vbitsel.v VI0, VI1, VI0, VT0
    blt $r0, I, .L10
    .align 3

.L15:
    vreplvei.d VI1, VI0, 0
    vreplvei.d VI2, VI0, 1
    vreplvei.d x1, VM0, 0
    vreplvei.d x2, VM0, 1
    //处理尾数相等时取最小序号
    fcmp.ceq.d $fcc0, $f10, $f9
    bceqz $fcc0, .L26
    vfcmp.clt.d VT0, VI1, VI2
    vbitsel.v VI0, VI2, VI1, VT0
    b .L27
    .align 3

.L20: // INCX!=1
    addi.d i0, i0, 1
    srai.d I, N, 2
    bge $r0, I, .L21
    slli.d i0, i0, 1 //2
    vreplgr2vr.d VINC4, i0
    addi.d i0, i0, -3
    vinsgr2vr.d VI1, i0, 0 //initialize the index value for vectorization
    addi.d i0, i0, 1
    vinsgr2vr.d VI1, i0, 1
    addi.d i0, i0, 1
    vinsgr2vr.d VI0, i0, 0 //1
    addi.d i0, i0, 1
    vinsgr2vr.d VI0, i0, 1 //2
    .align 3

.L24:
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
    vadd.d VI1, VI1, VINC4
    vfmul.d x3, VI4, x1
    vfmul.d x4, VI4, x2
    vfcmp.clt.d VT0, x1, VI3
    vfcmp.clt.d VINC8, x2, VI3
    vbitsel.v x1, x1, x3, VT0
    vbitsel.v x2, x2, x4, VINC8
    vfadd.d x1, x1, x2
    vfmax.d x3, VM0, x1
    ld.d t1, X, 0 * SIZE
    vfcmp.ceq.d VT0, x3, VM0
    ld.d t2, X, 1 * SIZE
    vbitsel.v VM0, x3, VM0, VT0
    vbitsel.v VI0, VI1, VI0, VT0
    add.d X, X, INCX
    ld.d t3, X, 0 * SIZE
    ld.d t4, X, 1 * SIZE
    add.d X, X, INCX
    vinsgr2vr.d x1, t1, 0
    vinsgr2vr.d x2, t2, 0
    vinsgr2vr.d x1, t3, 1
    vinsgr2vr.d x2, t4, 1
    vadd.d VI1, VI1, VINC4
    addi.d I, I, -1
    vfmul.d x3, VI4, x1
    vfmul.d x4, VI4, x2
    vfcmp.clt.d VT0, x1, VI3
    vfcmp.clt.d VINC8, x2, VI3
    vbitsel.v x1, x1, x3, VT0
    vbitsel.v x2, x2, x4, VINC8
    vfadd.d x1, x1, x2
    vfmax.d x3, VM0, x1
    vfcmp.ceq.d VT0, x3, VM0
    vbitsel.v VM0, x3, VM0, VT0
    vbitsel.v VI0, VI1, VI0, VT0
    blt $r0, I, .L24
    .align 3

.L25:
    vreplvei.d VI1, VI0, 0
    vreplvei.d VI2, VI0, 1
    vreplvei.d x1, VM0, 0
    vreplvei.d x2, VM0, 1
    //处理尾数相等时取最小序号
    fcmp.ceq.d $fcc0, $f10, $f9
    bceqz $fcc0, .L26
    vfcmp.clt.d VT0, VI1, VI2
    vbitsel.v VI0, VI2, VI1, VT0
    b .L27
    .align 3

.L26:
    vfmaxa.d VM0, x1, x2
    vfcmp.ceq.d VT0, x1, VM0
    vbitsel.v VI0, VI2, VI1, VT0
    .align 3

.L27:
    movfr2gr.d i0, $f20
    .align 3

.L21: // N<4
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
