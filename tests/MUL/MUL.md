# MUL
* Έχει 2 inputs(A,B) 32 bits που είναι ο πολλαπλασιαστής και ο πολλαπλασιαστέος και δυο output 32 bits,(RESULT: που περιέχει τα 32 LSB του αποτελέσματος) και (MSBRESULT : που περιέχει τα 32 MSB του αποτελέσματος).
* Χρησιμοποιώ μόνο έτοιμα components που είναι ήδη υλοποιημένα στον επεξεργαστή(**MUX2X1** , **BARREL_SHIFTER** , **EXE_ADDER_SUBBER**)
* Η διαδικασία του πολλαπλασιασμού ακολουθεί τον παρακάτω αλγόριθμο:
    <pre><code>  ### Το Α και το B είναι οι αριθμοί που πολλαπλασιάζονται
    ### το ARIGHT είναι βοηθητικό για το MSBRESULT
    ### το ALEFT είναι βοηθητικό για το RESULT
    ### το BH είναι βοηθητικό για το B
    ARIGHT = 0
    ALEFT = A
    BH = B
    MR = 0
    R = 0
    For i in range(0,31):
        IF B(0)==1:
            R = R + ALEFT
            EXT = R(32)
            MR = MR + ARIGHT + EXT
            ARIGHT = A>>31-i
            ALEFT = ALEFT<<1
            B = B>>1</code></pre>
<br>

* Π.Χ. Για την εντολή MUL $t5,$t4,$t3 (t5 = t4*t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 000 11110 0110011 ή 81de0f33

* Π.Χ. Για την εντολή MULH $t5,$t4,$t3 (t5 = t4*t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 001 11110 0110011 ή 81de1f33

* Π.Χ. Για την εντολή MULHU $t5,$t4,$t3 (t5 = t4*t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 010 11110 0110011 ή 81de2f33

* Π.Χ. Για την εντολή MULHSU $t5,$t4,$t3 (t5 = t4*t3) :\
**Funct7** &nbsp; &nbsp; **rs2** &nbsp; &nbsp; &nbsp;**rs1** **funct3** **rd** &nbsp; &nbsp;**opcode** \
1000000 11101 11100 011 11110 0110011 ή 81de3f33