# DIV
* Έχει 2 inputs(A,B) 32 bits που είναι ο διαιρέτης και ο διαιρετέος και ένα output 32 bits που είναι το αποτέλεσμα της διαίρεσης των 2 inputs.
* Χρησιμοποιώ κάποια έτοιμα components(**MUX2X1** , **BARREL_SHIFTER** , **EXE_ADDER_SUBBER**,**SIZE_COMPARATOR**)
* Η διαδικασία τις διαίρεσης ακολουθεί τον παρακάτω αλγόριθμο:
    <pre><code>  ### Το A είναι ο διαιρετέος 
    ### Το Β είναι ο διαιρέτης. 
    ### Το Q είναι το τελικό αποτέλεσμα.
    ### το R είναι βοηθητικό.
    Q = 0
    R = 0
    for i in range(31,0,-1):
        R = R<<1 #left shift R by 1 bit
        R(0) = A(i)
        if R>=B:
            R = R - B
            Q(i) = 1</code></pre>
    * **ΙΝΙΤΙΑΛΙΖΕ:** Ξεκινάμε αρχικοποιόντας το **Q και το R με 0**. 
    * **MAIN:** Υλοποιούμε το **for**. 
    * **SHIFTLEFT:** Μετατοπίζουμε το **R κατα 1 bit αριστερά** και θέτουμε το **R(0)=Α(I)** για κάθε επανάληψη.
    * **CHECKSIZE:** Σε αυτό το σημείο καλούμε το component SIZE_COMPARATOR για να ελέγξουμε αν το A>=B, αν αυτό ισχύει επιτρέφουμε το 1 διαφορετικά επιστρέφουμε το 0, έτσι θα μπορέσουμε να τα χρησιμοποιήσουμε ,ώστε να υλοποιήσουμε το if R>=B με την βοήθεια ενός πολυπλέκτη παρακάτω.
    * **CHECKIFR:** Υλοποιούμε το **if R>=B**, ουσιαστηκά αν το if ισχύει τότε παρακάτω αφαιρούμε το B απο το R , διαφορετικά αφαιρούμε το 0 απο το R. To ίδιο ακριβώς κάνουμε και για το Q(i) = 1, δηλαδή αν ισχύει θέτουμε το 1 ,διαφορετικά θέτουμε το 0.
     * **SUB:** Κάνουμε την αφαίρεση **R = R - B** και την πράξη **Q(i) = 1**.