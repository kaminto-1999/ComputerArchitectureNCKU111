.data
addr_name:    .string "alex"
addr_typed0:  .string "aaleex"
addr_typed1:  .string "aalleexx"
addr_typed2:  .string "aalewx"
str1:         .string "a0 is "
str2:         .string "\n"   

.text
main:
    la    t0, addr_name #Load "name" 1st address
    la    t1, addr_typed0 #Load "typed" 1st address
    jal   ra, isLongPressed
    la    t1, addr_typed1 #Load "typed" 1st address
    jal   ra, isLongPressed
    la    t1, addr_typed2 #Load "typed" 1st address
    jal   ra, isLongPressed
    j     End

isLongPressed:
    addi  sp, sp, -8     #Use 2 byte for saving register
    sw    ra, 0(sp)      #1st byte is ra
    sw    t0, 4(sp)      #2nd byte is t0 
    lb    t2, 0(t0)      #1st character of name
    lb    t3, 0(t1)      #1st character of typed
    bne   t2, t3, Fail   #1st character must the same
    addi  t0, t0, 1      #i++
    addi  t1, t1, 1      #j++
    jal   Loop           #Call Loop
    jal   printResult    #Call printResult
    lw    ra, 0(sp)      #Recall ra
    lw    t0, 4(sp)      #Recall t0
    addi  sp,sp, 8
    ret
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
    addi  a0, x0, 1      # Return a0 =1
    ret
Fail:
    addi  a0, x0, 0      # Return a0 =0
    ret
End:
    li a7, 10
    ecall
printResult:
        mv t4, a0
        la a0, str1      #Print str1
        li a7, 4
        ecall
        mv a0, t4        #Print a0
        li a7, 1
        ecall
        la a0, str2      #Print str2
        li a7, 4
        ecall
        ret