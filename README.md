The DUT folder of this project contains the following 6 .vhd files:

1. FA.vhd
2. AdderSub.vhd
3. Logic.vhd
4. Shifter.vhd
5. top.vhd
6. aux_package.vhd

Functional Description of each of them:

1. FA.vhd: Implementation of a full adder
- Supports the sum of two bits
- Input: three bits, xi yi and ci (carry in)
- Output: two bits, s = x+y and cout (carry out)

2. AdderSub.vhd: Adder/Subtractor Module 
- Supports Sum, Subtraction, Inversion, Increment and Decrement
- Input: two n-bit vectors, X and Y, and "selector" ALUFN (3 bit vector)
- Output: one n bit vectors and carry out bit according to ALUFN:
        ALUFN = 000 - Adder (Y+X)
        ALUFN = 001 - Subtractor (Y-X)
        ALUFN = 010 - Neg(X) (-X)
        ALUFN = 011 - Incrementer (Y+1)
        ALUFN = 100 - Decrementer (Y-1)
        If ALUFN undefined (101,110,111) - Output is zero

3. Logic Module
- Supports bitwise boolean operations not, or, and, xor, nor, nand, xnor
- Input: two n-bit vectors, X and Y, and "selector" ALUFN (3 bit vector)
- Output: one n bit vectors according to ALUFN:
        ALUFN = 000 - not(y)
        ALUFN = 001 - x or y
        ALUFN = 010 - x and y
        ALUFN = 011 - y xor x
        ALUFN = 100 - x nor y
        ALUFN = 101 - x nand y
        ALUFN = 111 - y xnor x
        If ALUFN undefined (110) - Output is zero
    
4. Shifter Module
- Barrel shifter, supports left and right shift
- Input: two n-bit vectors, X and Y and "selector" ALUFN (3 bit vector)
- Output: one carry out bit and the n-bit shifted Y vector:
        Y is shifted by the value stored in the k lower bits of X,
        k = log2(n)
        ALUFN = 000 - shift left
        ALUFN = 001 - shift right
        If ALUFN undefined (010, 011, 100, 101, 110, 111) - Output is zero

5. Top (System Entity)
- Inserts the inputs in the chosen modules, maps the modules, selects the output based on ALUFN_i
- Input: Y_i and X_i - n bit vectors
        Module/Function selector ALUFN_i - 5 bit vector, where:
            The top two bits (ALUFN_top) selects the module
            The lower 3 bits (ALUFN_bottom) selects the function within the chosen Module
- Output: ALUFN_o - n bit vector, output from the chosen module
          Four flag bits: negative, carry, zero and overflow
          ALUFN_i = 01 - AdderSub Module
          ALUFN_i = 11 - Logic Module
          ALUFN_i = 10 - Shifter Module
          ALFUN_i undefined (00) - Output is zero

6. aux_package
- Contains component declaration for all entities
