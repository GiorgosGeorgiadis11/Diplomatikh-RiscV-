# DIV
* Έχει 2 inputs(A,B) 32 bits που είναι ο διαιρέτης και ο διαιρετέος και δυο output 32 bits,(RESULT: που περιέχει το ακέραιο μέρος του αποτελέσματος) και (REMAINDER : που περιέχει το υπόλοιπο).
* Χρησιμοποιώ κάποια έτοιμα components(**MUX2X1** , **BARREL_SHIFTER** , **EXE_ADDER_SUBBER**,**SIZE_COMPARATOR**)
* Η διαδικασία τις διαίρεσης ακολουθεί τον παρακάτω αλγόριθμο:
    <pre><code>  ### Το A είναι ο διαιρετέος (dividend)
    ### Το Β είναι ο διαιρέτης. (divisor)
    ### Το Q είναι το τελικό αποτέλεσμα.
    ### το R είναι το υπόλοιπο.
    Q = 0
    R = 0
    for i in range(31,0,-1):
        R = R<<1 #left shift R by 1 bit
        R(0) = A(i)
        if R>=B:
            R = R - B
            Q(i) = 1</code></pre>
<br>

* Π.Χ. Για την εντολή DIV $t5,$t4,$t3 (t5 = t4/t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 100 11110 0110011 ή 81de4f33

* Π.Χ. Για την εντολή DIVU $t5,$t4,$t3 (t5 = t4/t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 101 11110 0110011 ή 81de5f33

* Π.Χ. Για την εντολή REM $t5,$t4,$t3 (t5 = t4/t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 110 11110 0110011 ή 81de6f33

* Π.Χ. Για την εντολή REMU $t5,$t4,$t3 (t5 = t4/t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 111 11110 0110011 ή 81de7f33