.text
.globl main

main:
    lw $t0, maxlen  # load the max length of string
    la $s0, str  # load the string buffer address
    move $a0, $s0  # pass buffer address to syscall
    move $a1, $t0  # pass length to syscall
    li $v0, 8  # read a string
    syscall

    jal printnewline
    j search

search:  # a "read char and search for it" loop
    # read char
    li $v0, 12
    syscall
    move $t0, $v0  # save the char to $t0
    lb $t1, exitchar
    beq $t0, $t1, exit  # char is '?', so exit

    jal printnewline

    move $a0, $t0  # pass the char to cmploop
    move $a1, $s0  # pass first char's address of the string to cmploop
    li $a2, 1  # pass initial location
    jal cmploop

    move $a0, $v0  # get the return value of cmploop
    bgez $a0, succeed  # did found the char
    j fail  # didn't found the char

cmploop:  # compare the chars at $a0 and $a1 (address), then increase $a1 and $a2 (location) and loop
    move $t0, $a0  # get the char
    move $t1, $a1  # get the current char address
    move $t2, $a2  # get the current location

    lb $t3, ($a1)  # load the current char to compare

    li $a0, -1  # set location to -1
    beqz $t3, cmploop_return  # it's the end of the string

    move $a0, $t2  # set location to current location
    beq $t0, $t3, cmploop_return  # the two chars are the same, which means the char is found successfully

    # neither it's the end of string, nor the char is found
    # so prepare for the next char to compare
    move $a0, $t0  # pass the char
    add $a1, $t1, 1  # increase the current char address
    add $a2, $t2, 1  # increase the current location
    j cmploop  # loop it!

cmploop_return:
    move $v0, $a0  # set return value - the location
    jr $ra  # return

succeed:
    move $t0, $a0  # get location

    # print succeed prompt
    li $v0, 4
    la $a0, succeedmsg
    syscall

    # print location
    li $v0, 1
    move $a0, $t0
    syscall

    jal printnewline
    jal printnewline
    j search

fail:
    # print fail prompt
    li $v0, 4
    la $a0, failmsg
    syscall

    jal printnewline
    jal printnewline
    j search

printnewline:
    li $a0, 10  # char '\n'
    li $v0, 11
    syscall
    jr $ra  # return

exit:
    li $v0, 10
    syscall

.data

exitchar: .byte 63  # char is '?', so exit
maxlen: .word 1024
str: .space 1024
failmsg: .asciiz "Failed!"
succeedmsg: .asciiz "Succeeded! Location: "
