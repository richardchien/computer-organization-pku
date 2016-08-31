.text
.globl main

main:
    # read char
    li $v0, 12
    syscall
    move $s0, $v0
    beq $s0, 63, exit  # char is '?', so exit

    jal printnewline

    # test whether in A-Z
    li $t6, 65  # lower limit 'A'
    li $t7, 90  # higher limit 'Z'
    sge $t6, $s0, $t6  # $t6 = whether $s0 >= 'A'
    sle $t7, $s0, $t7  # $t7 = whether $s0 <= 'Z'
    add $t7, $t6, $t7
    beq $t7, 2, printA2Z  # $t7 equals to 2 means the char is in A-Z

    # test whether in a-z
    li $t6, 97  # lower limit 'a'
    li $t7, 122  # higher limit 'z'
    sge $t6, $s0, $t6  # $t6 = whether $s0 >= 'a'
    sle $t7, $s0, $t7  # $t7 = whether $s0 <= 'z'
    add $t7, $t6, $t7
    beq $t7, 2, printa2z  # $t7 equals to 2 means the char is in a-z

    # test whether in 0-9
    li $t6, 48  # lower limit '0'
    li $t7, 57  # higher limit '9'
    sge $t6, $s0, $t6  # $t6 = whether $s0 >= '0'
    sle $t7, $s0, $t7  # $t7 = whether $s0 <= '9'
    add $t7, $t6, $t7
    beq $t7, 2, print0to9  # $t7 equals to 2 means the char is in 0-9

    j printunknown

printunknown:
    la $a0, strunknown
    li $v0, 4
    syscall
    jal printnewline
    j main

printA2Z:
    subi $t6, $s0, 65  # calculate offset
    move $a0, $t6  # pass offset to printletter
    j printletter

printa2z:
    subi $t6, $s0, 97  # calculate offset
    move $a0, $t6  # pass offset to printletter
    j printletter

printletter:
    move $t6, $a0  # get letter offset

    # print letter itself
    li $v0, 11
    move $a0, $s0
    syscall

    sll $t6, $t6, 2  # shift offset left 2 bits, aka multiply 4
    la $t7, arraya2z
    add $t6, $t6, $t7
    lw $a0, ($t6)
    li $v0, 4
    syscall

    jal printnewline
    j main

print0to9:
    subi $t6, $s0, 48  # calculate offset
    sll $t6, $t6, 2  # shift offset left 2 bits, aka multiply 4
    la $t7, array0to9
    add $t6, $t6, $t7
    lw $a0, ($t6)
    li $v0, 4
    syscall

    jal printnewline
    j main

printnewline:
    li $v0, 11
    li $a0, 10  # char '\n'
    syscall
    jr $ra

exit:
    li $v0, 10
    syscall

.data

strunknown: .asciiz "*\n"

stra: .asciiz "lpha\n"
strb: .asciiz "ravo\n"
strc: .asciiz "hina\n"
strd: .asciiz "elta\n"
stre: .asciiz "cho\n"
strf: .asciiz "oxtrot\n"
strg: .asciiz "olf\n"
strh: .asciiz "otel\n"
stri: .asciiz "ndia\n"
strj: .asciiz "uliet\n"
strk: .asciiz "ilo\n"
strl: .asciiz "ima\n"
strm: .asciiz "ary\n"
strn: .asciiz "ovember\n"
stro: .asciiz "scar\n"
strp: .asciiz "aper\n"
strq: .asciiz "uebec\n"
strr: .asciiz "esearch\n"
strs: .asciiz "ierra\n"
strt: .asciiz "ango\n"
stru: .asciiz "niform\n"
strv: .asciiz "ictor\n"
strw: .asciiz "hisky\n"
strx: .asciiz "-ray\n"
stry: .asciiz "ankee\n"
strz: .asciiz "ulu\n"
arraya2z: .word stra, strb, strc, strd, stre, strf, strg,
                strh, stri, strj, strk, strl, strm, strn,
                stro, strp, strq, strr, strs, strt,
                stru, strv, strw, strx, stry, strz

str0: .asciiz "Zero\n"
str1: .asciiz "First\n"
str2: .asciiz "Second\n"
str3: .asciiz "Third\n"
str4: .asciiz "Fourth\n"
str5: .asciiz "Fifth\n"
str6: .asciiz "Sixth\n"
str7: .asciiz "Seventh\n"
str8: .asciiz "Eighth\n"
str9: .asciiz "Ninth\n"

array0to9: .word str0, str1, str2, str3, str4, str5, str6, str7, str8, str9
