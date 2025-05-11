library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.aux_package.all;
---------------------------------------------------------
entity tb_top is
    GENERIC (    n : integer := 8;
        k : integer := 3;   -- k=log2(n)
        m : integer := 4;   -- m=2^(k-1)
        ROWmax : integer := 19);
end tb_top;
------------------------------------------------------------------------------
architecture rtb of tb_top is
    signal Y_i, X_i, ALUout_o : std_logic_vector(n-1 downto 0);
    signal ALUFN_i : std_logic_vector(4 downto 0);
    signal Nflag_o, Cflag_o, Zflag_o, Vflag_o : std_logic;

begin
    L0: top
        generic map (
            n => n,
            k => k,  -- log2(8) = 3
            m => m   -- 2^(3-1) = 4
        )
        port map (Y_i, X_i, ALUFN_i, ALUout_o, Nflag_o, Cflag_o, Zflag_o, Vflag_o );

    -- Stimulus process
    tb_process: process
    begin
        -- Testing Arithmetic Unit

        -- Testing addition
        ALUFN_i <= "01000";  -- Addition
        -- Test case 1: Add two small positive values
        X_i <= "00000011"; -- 3
        Y_i <= "00001001"; -- 9
        wait for 50 ns;
        -- Test case 2: Addition with overflow
        X_i <= "01111111"; -- 127
        Y_i <= "01111111"; -- 127
        wait for 50 ns;
        -- Test case 3: Add a negative and a positive value
        X_i <= "11111111"; -- -1
        Y_i <= "00000001"; -- 1
        wait for 50 ns;
        -- Test case 4: Add two negative values
        X_i <= "11111111"; -- -1
        Y_i <= "11111110"; -- -2
        wait for 50 ns;

        -- Testing subtraction
        ALUFN_i <= "01001";  -- Subtraction
        -- Test case 1: Subtraction with negative result
        X_i <= "00001001"; -- 9
        Y_i <= "00000011"; -- 3
        wait for 50 ns;
        -- Test case 2: Subtract with positive result
        X_i <= "00000011"; -- 3
        Y_i <= "00001001"; -- 9
        wait for 50 ns;
        -- Test case 3: Subtract positive from negative
        X_i <= "00000001"; -- 1
        Y_i <= "11111111"; -- -1
        wait for 50 ns;
        -- Test case 4: Subtract negative from positive
        X_i <= "11111110"; -- -2
        Y_i <= "00000001"; -- 1
        wait for 50 ns;
        -- Test case 5: Subtraction with overflow
        X_i <= "01111111"; -- 127
        Y_i <= "11111111"; -- -1
        wait for 50 ns;
        -- Test case 6: Result is zero
        X_i <= "00000001"; -- 1
        Y_i <= "00000001"; -- 1
        wait for 50 ns;

        --Testing inversion
        ALUFN_i <= "01010";  -- inversion
        -- Test case 1: invert a positive value
        X_i <= "00001001"; -- 9
        wait for 50 ns;
        -- Test case 2: invert a negative value
        X_i <= "11100011"; -- -29
        wait for 50 ns;
        -- Test case 3: invert zero
        X_i <= "00000000"; -- 0
        wait for 50 ns;
        -- Test case 4: invert maximum positive value
        X_i <= "01111111"; -- 127
        wait for 50 ns;

        -- Testing Increment
        ALUFN_i <= "01011";  -- Increment
        -- Test case 1: Increment a positive value
        Y_i <= "00000001"; -- 1
        wait for 50 ns;
        -- Test case 2: Increment a maximum value
        Y_i <= "01111111"; -- 127
        wait for 50 ns;
        -- Test case 3: Increment a negative value
        Y_i <= "11111110"; -- -2
        wait for 50 ns;

        -- Testing Decrement
        ALUFN_i <= "01100";  -- Decrement
        -- Test case 1: Decrement a positive value
        Y_i <= "00101001"; --41
        wait for 50 ns;
        -- Test case 2: Decrement a negative value
        Y_i <= "11110110"; -- -10
        wait for 50 ns;
        -- Test case 3: Decrement zero
        Y_i <= "00000000"; -- 0
        wait for 50 ns;
        -- Test case 4: Decrement minimum negative value
        Y_i <= "10000000"; -- -128
        wait for 50 ns;

        -- Testing invalid op code
        ALUFN_i <= "01110";  -- Invalid operation
        -- Test case 1
        X_i <= "00000001"; -- 1
        Y_i <= "00000001"; -- 1 
        wait for 50 ns;
        -- Test case 2
        ALUFN_i <= "01111";  -- Invalid operation
        X_i <= "00000001"; -- 1
        Y_i <= "00000001"; -- 1
        wait for 50 ns;

        -- Testing Logic Unit
        X_i <= "11001110";
        Y_i <= "11100101";
        -- Test case 1: NOT operation
        ALUFN_i <= "11000";
        wait for 50 ns;
        -- Test case 2: OR operation
        ALUFN_i <= "11001";  -- OR operation
        wait for 50 ns;
        -- Test case 3: AND operation
        ALUFN_i <= "11010";  -- AND operation
        wait for 50 ns;
        -- Test case 4: XOR operation
        ALUFN_i <= "11011";  -- XOR operation
        wait for 50 ns;
        -- Test case 5: NOR operation
        ALUFN_i <= "11100";  -- NOR operation
        wait for 50 ns;
        -- Test case 6: NAND operation
        ALUFN_i <= "11101";  -- NAND operation
        wait for 50 ns;
        -- Test case 7: XNOR operation
        ALUFN_i <= "11111";  -- XNOR operation
        wait for 50 ns;
        -- Test case 8: Undefined operation
        ALUFN_i <= "11110";  -- Invalid op code
        wait for 50 ns;

        -- Testing Shift Unit

        --Testing shift left
        ALUFN_i <= "10000";  -- Shift left X smaller than 7 (max shift value)
        -- Test case 1: Shift left by 1 with 
        X_i <= "00000001";
        Y_i <= "00000010";
        wait for 50 ns;
        -- Test case 2: Shift left by 1 with X larger than 7 (max shift value)
        X_i <= "11110001"; 
        Y_i <= "00000010";
        wait for 50 ns;
        -- Test case 3: Shift left with carry out
        X_i <= "00000101";
        Y_i <= "10111011";
        wait for 50 ns;
        -- Test case 4: Shift left edge case
        X_i <= "11111111";
        Y_i <= "00000001";
        wait for 50 ns;

        --Testing shift right
        ALUFN_i <= "10001";  -- Shift right
        -- Test case 1: Shift right by 1 with X smaller than 7 (max shift value)
        X_i <= "00000001";
        Y_i <= "00000010";
        wait for 50 ns;
        -- Test case 2: Shift right by 1 with X larger than 7 (max shift value)
        X_i <= "11110001";
        Y_i <= "00000010";
        wait for 50 ns;
        -- Test case 3: Shift right with carry out
        X_i <= "00000101";
        Y_i <= "10111011";
        wait for 50 ns;
        -- Test case 4: Shift right edge case
         X_i <= "11111111";
         Y_i <= "00000001";
         wait for 50 ns;

        -- Testing undefined operations: output should be always zero
        X_i <= "00000101";
        Y_i <= "10111011";

        ALUFN_i <= "10010";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "10011";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "10100";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "10101";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "10110";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "10111";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00000";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00001";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00010";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00011";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00100";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00101";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00110";  -- Undefined operation
        wait for 50 ns;
        ALUFN_i <= "00111";  -- Undefined operation
        wait for 50 ns;

        wait;
    end process;
end rtb;
