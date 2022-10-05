.data
addr_name:  .string "alex"
addr_typed: .string "aaleex"
str1:       .string "a0 is "

.text
main:
    la    t0, addr_name #Load "name" 1st address
    la    t1, addr_typed #Load "typed" 1st address
    lb    t2, 0(t0)      #1st character of name
    lb    t3, 0(t1)      #1st character of typed
    bne   t2, t3, Fail   #1st character must the same
    addi  t0, t0, 1      #i++
    addi  t1, t1, 1      #j++
Loop: #1st while loop
    lb    t2, 0(t0)      #Load name[i]
    lb    t3, 0(t1)      #Load typed[j] 
    beq   t2, x0, checkLastCharacter #If name[i]= NULL
If:
    bne   t2, t3, Else   #If name[i]!=typed[j]
    addi  t0, t0, 1      #i++
    addi  t1, t1, 1      #j++
    j     Loop
Else:
    lb    t2, -1(t0)     # Load name[i-1]
    bne   t2, t3,Fail    # If typed[j] != name[i-1] then Fail
    addi  t1, t1, 1      # j++
    j     Loop          
checkLastCharacter: #2nd while loop
    lb    t2, -1(t0)     # Load last character of name
if2:
    beq   t3, x0, Pass   # If typed[j] = NULL, then passed
    bne   t2, t3,Fail    # If typed[j] != name[last] then Fail
    addi  t1, t1, 1      # j++
    lb    t3, 0(t1)      # 
    j     if2

Pass:
    li    a0, 1         # Return a0 =1
    j     End
Fail:
    li    a0, 0         # Return a0 =0
    j     End
End:
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