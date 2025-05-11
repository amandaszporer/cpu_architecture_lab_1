library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_shifter is
    GENERIC (    n : integer := 8;
        k : integer := 3;   -- k=log2(n)
        m : integer := 4;   -- m=2^(k-1)
        ROWmax : integer := 19);
end tb_shifter;
------------------------------------------------------------------------------  
architecture rtb of tb_shifter is
    SIGNAL X,Y,output:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    SIGNAL ALUFN :  STD_LOGIC_VECTOR (2 DOWNTO 0);
    signal cout : std_logic;

begin
	L0 : Shifter generic map (n,k) port map(X,Y,ALUFN,output,cout);

---------------- start of stimulus section ----------------------------------------		

    tb_x_y : process
    begin
    Y <= (others => '1');
    for j in 0 to 7 loop
        X <= (others => '0');
        for k in 0 to 7 loop
            wait for 50 ns; 
            X <= X + 1;
            end loop;
    end loop;      
    wait;
    end process;

    tb_ALUFN : process
    begin
    ALUFN <= (others => '0');
        for i in 0 to 7 loop
        wait for 400 ns;
        ALUFN <= ALUFN + 1;
        end loop;
        wait;
    end process tb_ALUFN;

end architecture rtb;