# ΑΡΧΕΙΑ ΠΟΥ ΠΡΟΣΤΕΘΗΚΑΝ

1.  **top.vhd** (Στον main φάκελο RISCV-32I-master) -> είναι το testbench για να τεστάρουμε τον επεξεργαστή, εκτός από το CLK(ανά 10ns ένας κύκλος ρολογιού) και το RESET έχω πρόσθεση και ένα σήμα cycle_counter που μας λέει σε ποιον κύκλο ρολογιού βρισκόμαστε.
2. **testMUL.vhd** (Στον main φάκελο RISCV-32I-master) -> είναι το testbench για να ελέγξουμε αν λειτουργεί σωστά ο πολλαπλασιαστής(MUL).
3. **testDIV.vhd** (Στον main φάκελο RISCV-32I-master) -> είναι το testbench για να ελέγξουμε αν λειτουργεί σωστά ο διαιρέτης(DIV).
4. **MUL.vhd** (Στον φάκελο TOOLBOX Components) ->είναι ο πολλαπλασιαστής.
5. **SIZE_COMPARATOR.vhd** (Στον φάκελο TOOLBOX Components) ->Είναι ένα component για να ελέγχουμε πιο binary number είναι μεγαλύτερο(αν το Α>=Β επιστρέφει 1,διαφορετικά επιστρέφει 0).
6. **DIV.vhd** (Στον φάκελο TOOLBOX Components) ->είναι ο διαιρέτης.
7. **TWOS_COMPLEMENT.vhd** (Στον φάκελο TOOLBOX Components) -> κανει το συμπλήρωμα του 2 σε έναν αριθμό.

# ΑΡΧΕΙΑ ΠΟΥ ΑΛΛΑΧΘΗΚΑΝ
Για να προσθέσω την εντολή του πολλαπλασιασμού αύξησα το control word από 20 σε 21 bits, ώστε το ALU OP να χωράει και την εντολή του πολλαπλασιασμού. Έτσι τοALU OP έγινε 3 bits (000: ADD, 001: SUB , 010 : LOGIC OPERATION , 011 : SHIFTOPERATION , 100 : MUL), για να γίνει αυτό έκανα τις εξής αλλαγές **:**

1. **TOOLBOX.vhd** (Στον main φάκελο RISCV-32I-master) -> 
    * πρόσθεσα το component του πολλαπλασιαστή(MUL.vhd) {σειρά 438..447}
    * **DIV** πρόσθεσα το component του διαιρέτη(DIV.vhd) {σειρά 449..458}
    * άλλαξα το input MUX_2X1_SEL σε MUX_4X1_SEL με μέγεθος (1DOWNTO 0) στο component ID_DECODER {σειρά 184}
    * άλλαξα το μέγεθος των CTRL_WORD απο (17 DOWNTO 0) σε (18 DOWNTO 0) {σειρά 303} και To_EXE_ALU απο (8 DOWNTO 0) σε (9 DOWNTO 0) {σειρά 306} στο component CONTROL_WORD_REGROUP
    * **DIV** πρόσθεσα το component του ελεγκτής μεγέθους(SIZE_COMPARATOR.vhd) {σειρά 139..148}
    * **DIV** πρόσθεσα το component του (TWOS_COMPLEMENT.vhd) {σειρά 460..470}  
2. **INSTRUCTION_DECODE.vhd** (Στον φάκελο PIPELINE Components) ->
    * άλλαξα το μέγεθος του FUNCT7 απο 1 bit σε 2 bits {σειρά 63}
    * άλλαξα τα bits που πέρνει το FUNCT7 απο το IF_WORD απο IF_WORD(30) σε IF_WORD(31 DOWNTO 30) {σειρα 83}
    * άλλαξα το input MUX_2X1_SEL,που πέρνει το component άλλαξα το input MUX_2X1_SEL,που πέρνει το component ID_DECODER, σε MUX_4X1_SEL {σειρα 88}
    * άλλαξα το JALR απο JALR <= (DEC_BUF(11) XOR DEC_BUF(10)) AND DEC_BUF(1) σε JALR <= (DEC_BUF(12) XOR DEC_BUF(11)) AND DEC_BUF(1) {σειρα 124}########################################
3. **ID_DECODER.vhd** (Στον φάκελο TOOLBOX Components) ->
    * άλλαξα το input MUX_2X1_SEL σε MUX_4X1_SEL με μέγεθος (1 DOWNTO 0) {σειρα 61}
    * πρόσθεσα το SIGNAL R_MUL με τιμή ("111"&"1"&"0"&"111"&"00"&"100"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 92}
    * πρόσθεσα το SIGNAL R_MULH με τιμή ("111"&"1"&"0"&"111"&"00"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 93}
    * πρόσθεσα το SIGNAL R_MULHU με τιμή ("111"&"1"&"0"&"111"&"10"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 94}
    * πρόσθεσα το SIGNAL R_MULHSU με τιμή ("111"&"1"&"0"&"111"&"11"&"101"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 95}
    * **DIV** πρόσθεσα το SIGNAL R_DIV με τιμή ("111"&"1"&"0"&"111"&"00"&"110"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 96}
    * **DIV** πρόσθεσα το SIGNAL R_DIVU με τιμή ("111"&"1"&"0"&"111"&"10"&"110"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 97}
    * **DIV** πρόσθεσα το SIGNAL R_REM με τιμή ("111"&"1"&"0"&"111"&"00"&"111"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 98}
    * **DIV** πρόσθεσα το SIGNAL R_REMU με τιμή ("111"&"1"&"0"&"111"&"10"&"111"&"0"&"0"&"0"&"0"&"0"&"0"&"0"&"0") {σειρα 99}
    * πρόσθεσα 1 επιπλέον bit σε όλα τα control words στην θέση 10 αφού πλέον το ALU OP του CTR_WD είναι 3 bits και όχι 2
    * άλλαξα όλα τα components MUX2X1 σε MUX4X1, ώστε να μπορέσω να προσθέσω τα R_MUL ,R_MULH,R_MULHU,R_MULHSU,R_DIV,R_DIVU,R_REM  και R_REMU {σειρές 143..231}
    * άλλαξα το input sel που πέρνουν όλα τα MUX4X1 components απο MUX_2X1_SEL σε MUX_4X1_SEL
    * πρόσθεσα το R_MUL στο MUX4X1 {σειρα 146}
    * **DIV** πρόσθεσα το R_DIV στο MUX4X1 {σειρα 147}
    * πρόσθεσα και για τις υπολοιπες εντολες
    * πρόσθεσα τα σηματα για ολα τα buf
4. **CONTROL_WORD_REGROUP.vhd** (Στον φάκελο TOOLBOX Components) ->
    * άλλαξα το μέγεθος των CTRL_WORD{σειρα 7} απο (17 DOWNTO 0) σε (18 DOWNTO 0) TO_EXE_ALU{σειρα 10} απο (8 DOWNTO 0) σε (9 DOWNTO 0)
    * άλλαξα τα bits που πέρνει το TO_EXE_ALU απο [[CTRL_WORD(12 DOWNTO 11) & CTRL_WORD(10 DOWNTO 9) & CTRL_WORD(8) & CTRL_WORD(7) & CTRL_WORD(6) & CTRL_WORD(5) & CTRL_WORD(1)]] σε [[CTRL_WORD(13 DOWNTO 12) & CTRL_WORD(11 DOWNTO 9) & CTRL_WORD(8) & CTRL_WORD(7) & CTRL_WORD(6) & CTRL_WORD(5) & CTRL_WORD(1)]] καιTO_OTHERS απο [[CTRL_WORD(16) & CTRL_WORD(15 DOWNTO 13) & CTRL_WORD(17)]] σε CTRL_WORD(17) & CTRL_WORD(16 DOWNTO 14) & CTRL_WORD(18)
5. **ΕΧΕ.vhd** (Στον φάκελο PIPELINE Components) ->
    * άλλαξα το μέγεθος του OP απο (8 DOWNTO 0) σε (9 DOWNTO 0) {σειρα 31}
    * άλλαξα τo bit που πέρνει το input SEL στο component MUX2X1_BIT απο OP(8) σε OP(9) στις {σειρες 76,83}
    * άλλαξα τo bit που πέρνει το input OP στο component EXE_LOGIC_MODULE απο OP(8 DOWNTO 7) σε OP(9 DOWNTO 8) {σειρα 165}
    * άλλαξα τo bit που πέρνει το input OPCODE στο component BARREL_SHIFTER απο OP(8 DOWNTO 7) σε OP(9 DOWNTO 8) {σειρα 174}
    * πρόσθεσα ένα Signal MUL_RES που αποθηκεύει το αποτέλεσμα του πολλαπλασιαστή(MUL) {σειρα 60}
    * **DIV** πρόσθεσα ένα Signal DIV_RES που αποθηκεύει το αποτέλεσμα του διαιρέτη(DIV){σειρα 61} και ενα σημα REM_RES που αποθηκεύει το αποτέλεσμα του κρατούμενου της διαίρεσης{σειρα 62}
    * **DIV** πρόσθεσα τα σήματα A_COMPLEMENT και B_COMPLEMENT που αποθηκεύουν το συμπλήρωμα του 2 για τα A και B αν αυτο χρειάζεται {σειρα 48,49} 
    * **DIV** πρόσθεσα τα σήματα DIV_COMPLEMENT και REM_COMPLEMENT που αποθηκεύουν το συμπλήρωμα του 2 για τα DIV και REM αν αυτο χρειάζεται {σειρα 51,52}
    * **DIV** πρόσθεσα ένα Signal SIGNE που αποθηκεύει το πρόσημο της διαίρεσης{σειρα 50}
    * πρόσθεσα ένα component MUL που πέρνει ως inputs το A και B κάνει την πράξη του πολλαπλασιασμού και αποθηκεύει το αποτέλεσμα στο signal MUL_RES {σειρα 98..103}
    * **DIV** πρόσθεσα ένα component DIV που πέρνει ως inputs το A και B κάνει την πράξη της διαίρεσης και αποθηκεύει το αποτέλεσμα στο signal DIV_RES {σειρα 105..143}
    * άλλαξα τo ALU_MUX component απο MUX4X1 σε MUX8X1 και τα bits που πέρνει το SEL απο OP(6 DOWNTO 5) σε OP(7 DOWNTO 5) και πρόσθεσα σαν D4 το MUL_RES, σαν D6 το DIV_RES και σαν D7 το REM_RES{σειρα 195..208}
    * πρόσθεσα ένα CONSTANT GND που περιέχει 32 bits με 0 {σειρά 60}
6. **PIPE_ID_TO_EXE_REGISTER.vhd** (Στον φάκελο PIPELINE Components) ->
    * άλλαξα το μέγεθος των I_CTRL_WORD{σειρα 34} O_CTRL_WORD{σειρα 47} BUF_CTRL_WRD{σειρα 66} απο (17 DOWNTO 0) σε (18 DOWNTO 0)
    * πρόσθεσα 1 επιπλέον bit σε όλα τα BUF_CTRL_WRD στην θέση 10 αφού πλέον το ALU OP είναι 3 bits και όχι 2
7. **PIPELINE.vhd** (Στον main φάκελο RISCV-32I-master) ->
    * άλλαξα το μέγεθος των I_CTRL_WORD{σειρα 61} O_CTRL_WORD{σειρα 75}
    * άλλαξα το μέγεθος του OP απο (8 DOWNTO 0) σε (9 DOWNTO 0) στο component EXE {σειρα 177}
8. **RV32I.vhd** (Στον main φάκελο RISCV-32I-master) -> 
    * άλλαξα το μέγεθος των GENERIC MAP που δίνουμε στο component INSTRUCTION_DECODE, το CTRL_WORD_TOTAL απο 20 σε 21 και το CTRL_WORD_OUT απο 18 σε 19 {σειρά 216}
    * άλλαξα το μέγεθος των I_D{σειρα 31},PIPE_B_OUT_CTRL_WORD{σειρα 85},ID_OUT_OPCODES{σειρα 124} απο (17 DOWNTO 0) σε (18 DOWNTO 0)
    * άλλαξα το μέγεθος του ALU_OPCODE απο (8 DOWNTO 0) σε (9 DOWNTO 0) {σειρα 142}


Μετά από όλες αυτές τις αλλαγές λειτουργεί κανονικά οι εντολές του MUL και οι εντολές του DIV:\
### MUL
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

<br>

### DIV
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
