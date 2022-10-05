.data
addr_name:  .byte 0x97, 0x6C, 0x65, 0x78, 0x00
addr_typed: .byte 0x97, 0x6C, 0x65, 0x65, 0x78, 0x78, 0x00
str1:       .string "a0 is "

.text
main:
    la    t0, addr_name #Load "name" 1st address
    la    t1, addr_typed #Load "typed" 1st address
    lb    t2, 0(t0)     #Load 1st character of name
    lb    t3, 0(t1)     #Load 1st character of typed
    bne   t2, t3, Fail  #1st character must the same

Loop: #1st while loop
    addi  t0, t0, 1     #i++
    addi  t1, t1, 1     #j++
    lb    t2, 0(t0)     #Load name[i]
    lb    t3, 0(t1)     #Load typed[j]
If:
    bne   t2, t3, Else   #If name[i]!=typed[j], check long pressed
    beq   t2, x0, checkLastCharacter #If name[i]= NULL, check typed[j]
    j     Loop
Else:
    addi  t0, t0, -1    # Previous character address
    lb    t2, 0(t0)     # Load name[i-1]
    bne   t2, t3,Fail   # If typed[j] != name[i-1] then Fail
    addi  t1, t1, 1     # j++
    j     Loop          
checkLastCharacter: #2nd while loop
    beq   t3, x0, Pass  # If typed[j] = NULL, then passed
    addi  t0, t0, -1    # i--
    lb    t2, 0(t0)     # Load last character of name
    bne   t2, t3,Fail   # If typed[j] != name[i-1] then Fail
    j     Else

Pass:
    li    a0, 1         # Return a0 =1
    j     End
Fail:
    li    a0, 0         # Return a0 =0
    j     End
End:
    sw    ra, 0(sp)
    addi  sp, sp, -4
    jal ra, printResult
    li a7, 10
    ecall
printResult:
        mv t0, a0
        mv t1, a1
        la a0, str1
        li a7, 4
        ecall
        mv a0, t0
        li a7, 1
        ecall
        ret