# MUL
* Έχει 2 inputs(A,B) 32 bits που είναι ο πολλαπλασιαστής και ο πολλαπλασιαστέος και ένα output 32 bits που είναι το αποτέλεσμα του πολλαπλασιασμού των 2 inputs.
* Χρησιμοποιώ μόνο έτοιμα components που είναι ήδη υλοποιημένα στον επεξεργαστή(**MUX2X1** , **BARREL_SHIFTER** , **EXE_ADDER_SUBBER**)
* Η διαδικασία του πολλαπλασιασμού χωρίζεται σε 4 βασικά στάδια που ακολουθεί σε κάθε μια από τις επαναλήψης:
    * **CHECKONE:** Αρχικά χρησιμοποιώ έναν πολυπλέκτη MUX2X1 που ελέγχει αν το κάθε ένα από τα bits του Α είναι 1 ή 0. Αν είναι μηδέν τότε επιστρέφει σαν MUXOUT έναν μηδενικό αριθμό 32 bit,ώστε να μην γίνει καμία πράξη στην συνέχεια. Διαφορετικά επιστρέφει σαν MUXOUT τον B.
    * **INITIALIZE:** Σε αυτό το στάδιο θα μπει μόνο στην πρώτη επανάληψη και το χρησιμοποιώ για αρχικοποίηση .
    * **SFT:** Κάθε φορά που μπαίνει σε αυτό το στάδιο αυξάνει το SHAMT κατά 1,το οποίο χρησιμοποιείται για να «πούμε» πόσες θέσεις αριστερά να μετακίνηση το B, ουσιαστικά για κάθε μία θέση που μετακινείται το Bαριστερά πολλαπλασιάζεται με το 2(δηλαδή αν το μετακινήσουμε 3 θέσεις αριστερά θα πολλαπλασιαστή με το 2*2*2=8). o 
    * **OUTPUTADD:** Στο τέλος κάθε επανάληψης προσθέτει το αποτέλεσμα που έχει δημιουργηθεί βάση του mux και του shifter στο συνολικό αποτέλεσμα.

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