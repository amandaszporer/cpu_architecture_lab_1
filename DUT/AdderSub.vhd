LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.aux_package.all;
--------------------------------------------------------
ENTITY AdderSub IS
  GENERIC (n : INTEGER := 8);
  PORT (    x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
            cout: OUT STD_LOGIC;
            ALUFN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            s: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
END AdderSub;
--------------------------------------------------------
ARCHITECTURE dtf OF AdderSub IS
    SIGNAL reg : std_logic_vector(n-1 DOWNTO 0);
    SIGNAL x_temp, y_temp: std_logic_vector(n-1 DOWNTO 0);
    SIGNAL cin : std_logic;
BEGIN

	-- carry in for first FA is LSB of ALUFN for Adding/Subtracting, '1' for Inverting/Incrementing and '0'for Decrementing
	cin <= ALUFN(0) WHEN (ALUFN = "000" or ALUFN = "001") ELSE
		   '1' WHEN (ALUFN = "010" or ALUFN = "011") ELSE
		   '0';

	-- x_temp is X xor (LSB of ALUFN) for Adding/Subtracting, x xor '1' for Inverting and '0' for Incrementing and '1' for Decrementing
	x_temp_gen  :for i in 0 to n-1 GENERATE
		x_temp(i) <= (x(i) xor ALUFN(0)) WHEN (ALUFN = "000" or ALUFN = "001") ELSE
                    (x(i) xor '1')         WHEN (ALUFN = "010") ELSE
                    '1'                    WHEN (ALUFN = "100") ELSE
                    '0';                  
	END GENERATE;
	
	-- y_temp is '0' for Inverting and y for all other cases
	y_temp <= 	y  WHEN (ALUFN = "000" or ALUFN = "001" or ALUFN = "011" or ALUFN = "100") ELSE
				(OTHERS => '0');

-- First FA
	first: FA port map(xi => x_temp(0),yi => y_temp(0),cin => cin,s => s(0),cout => reg(0));
-- Remaining FA
	rest : for i in 1 to n-1 generate
		ripple : FA port map(xi => x_temp(i),yi => y_temp(i),cin => reg(i-1),s => s(i),cout => reg(i));
	end generate;
	-- Get carry of the last FA
	cout <= reg(n-1);

END dtf;
