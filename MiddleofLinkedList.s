push:
        addi    sp,sp,-48
        sw      s0,44(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      a1,-40(s0)
        lw      a5,-20(s0)
        lw      a4,-40(s0)
        sw      a4,0(a5)
        lw      a5,-36(s0)
        lw      a4,0(a5)
        lw      a5,-20(s0)
        sw      a4,4(a5)
        lw      a5,-36(s0)
        lw      a4,-20(s0)
        sw      a4,0(a5)
        nop
        lw      s0,44(sp)
        addi    sp,sp,48
        jr      ra
middleNode:
        addi    sp,sp,-48
        sw      s0,44(sp)
        addi    s0,sp,48
        sw      a0,-36(s0)
        sw      zero,-20(s0)
        lw      a5,-36(s0)
        sw      a5,-24(s0)
        j       L3
L4:
        lw      a5,-24(s0)
        lw      a5,4(a5)
        sw      a5,-24(s0)
        lw      a5,-20(s0)
        addi    a5,a5,1
        sw      a5,-20(s0)
L3:
        lw      a5,-24(s0)
        lw      a5,4(a5)
        bne     a5,zero,L4
        lw      a5,-20(s0)
        andi    a5,a5,1
        bne     a5,zero,L5
        lw      a5,-20(s0)
        srli    a4,a5,31
        add     a5,a4,a5
        srai    a5,a5,1
        j       L6
L5:
        lw      a5,-20(s0)
        srli    a4,a5,31
        add     a5,a4,a5
        srai    a5,a5,1
        addi    a5,a5,1
L6:
        sw      a5,-20(s0)
        lw      a5,-36(s0)
        sw      a5,-24(s0)
        j       L7
L8:
        lw      a5,-24(s0)
        lw      a5,4(a5)
        sw      a5,-24(s0)
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
L7:
        lw      a5,-20(s0)
        bne     a5,zero,L8
        lw      a5,-24(s0)
        mv      a0,a5
        lw      s0,44(sp)
        addi    sp,sp,48
        jr      ra
main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
        sw      zero,-24(s0)
        li      a5,4
        sw      a5,-20(s0)
        j       L11
forLoop:
        addi    a5,s0,-24
        lw      a1,-20(s0)
        mv      a0,a5
        call    push
        lw      a5,-24(s0)
        mv      a0,a5
        call    middleNode
        lw      a5,-20(s0)
        addi    a5,a5,-1
        sw      a5,-20(s0)
L11:
        lw      a5,-20(s0)
        bgt     a5,zeroforLoop
return:
        li      a5,0
        mv      a0,a5
        lw      ra,28(sp)
        lw      s0,24(sp)
        addi    sp,sp,32
        jr      ra