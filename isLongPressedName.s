.section .text
.align 2
.globl main
.global addr_name
.global addr_type
addr_name: .string "a"
addr_type: .string "a"

main:
    addi  sp, sp, -4
    sw    ra, 0(sp)
    la    t0, addr_name #Load "name" 1st address
    la    t1, addr_type #Load "type" 1st address
    lb    t2, 0(t0)     #Load 1st character of name
    lb    t3, 0(t1)     #Load 1st character of type
    bne   t2, t3, Fail  #1st character must the same

Loop:
    addi  t0, t0, 1     #i++
    addi  t1, t1, 1     #j++
    lb    t2, 0(t0)     #Load name[i]
    lb    t3, 0(t1)     #Load type[j]
    bne   t2, t3, checkLongPressed   #If name[i]!=type[j], check long pressed
    beq   t2, x0, checkLastCharacter #If name[i]= NULL, check type[j]
    j     Loop

checkLongPressed:
    addi  t0, t0, -1    # Previous character address
    lb    t2, 0(t0)     # Load name[i-1]
    bne   t2, t3,Fail   # If typed[j] != name[i-1] then Fail
    addi  t1, t1, 1     # j++
    j     Loop          

checkLastCharacter:
    beq   t3, x0, Pass  # If type[j] = NULL, then passed
    addi  t0, t0, -1    # i--
    lb    t2, 0(t0)     # Load last character of name
    bne   t2, t3,Fail   # If typed[j] != name[i-1] then Fail
    j     checkLongPressed

Pass:
    li    a0, 1         # Return a0 =1
    j     End
Fail:
    li    a0, 0         # Return a0 =0
    j     End
End:
    sw    ra, 0(sp)
    addi  sp, sp, -4
    jr ra