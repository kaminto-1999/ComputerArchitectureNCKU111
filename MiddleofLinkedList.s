00000118 <push>:
 addi   sp,sp,-48
 sw     s0,44(sp)
 addi   s0,sp,48
 sw     a0,-36(s0)
 sw     a1,-40(s0)
 lw     a5,-20(s0)
 lw     a4,-40(s0)
 sw     a4,0(a5)
 lw     a5,-36(s0)
 lw     a4,0(a5)
 lw     a5,-20(s0)
 sw     a4,4(a5)
 lw     a5,-36(s0)
 lw     a4,-20(s0)
 sw     a4,0(a5)
 nop
 lw     s0,44(sp)
 addi   sp,sp,48
 ret

00000164 <middleNode>:
 addi   sp,sp,-48
 sw     s0,44(sp)
 addi   s0,sp,48
 sw     a0,-36(s0)
 sw     zero,-20(s0)
 lw     a5,-36(s0)
 sw     a5,-24(s0)
 j      19c <middleNode+0x38>
 lw     a5,-24(s0)
 lw     a5,4(a5)
 sw     a5,-24(s0)
 lw     a5,-20(s0)
 addi   a5,a5,1
 sw     a5,-20(s0)
 lw     a5,-24(s0)
 lw     a5,4(a5)
 bnez   a5,184 <middleNode+0x20>
 lw     a5,-20(s0)
 andi   a5,a5,1
 bnez   a5,1c8 <middleNode+0x64>
 lw     a5,-20(s0)
 srli   a4,a5,0x1f
 add    a5,a4,a5
 srai   a5,a5,0x1
 j      1dc <middleNode+0x78>
 lw     a5,-20(s0)
 srli   a4,a5,0x1f
 add    a5,a4,a5
 srai   a5,a5,0x1
 addi   a5,a5,1
 sw     a5,-20(s0)
 lw     a5,-36(s0)
 sw     a5,-24(s0)
 j      204 <middleNode+0xa0>
 lw     a5,-24(s0)
 lw     a5,4(a5)
 sw     a5,-24(s0)
 lw     a5,-20(s0)
 addi   a5,a5,-1
 sw     a5,-20(s0)
 lw     a5,-20(s0)
 bnez   a5,1ec <middleNode+0x88>
 lw     a5,-24(s0)
 mv     a0,a5
 lw     s0,44(sp)
 addi   sp,sp,48
 ret

00000220 <main>:
 addi   sp,sp,-32
 sw     ra,28(sp)
 sw     s0,24(sp)
 addi   s0,sp,32
 sw     zero,-24(s0)
 li     a5,4
 sw     a5,-20(s0)
 j      268 <main+0x48>
 addi   a5,s0,-24
 lw     a1,-20(s0)
 mv     a0,a5
 jal    ra,118 <push>
 lw     a5,-24(s0)
 mv     a0,a5
 jal    ra,164 <middleNode>
 lw     a5,-20(s0)
 addi   a5,a5,-1
 sw     a5,-20(s0)
 lw     a5,-20(s0)
 bgtz   a5,240 <main+0x20>
 li     a5,0
 mv     a0,a5
 lw     ra,28(sp)
 lw     s0,24(sp)
 addi   sp,sp,32
 ret