library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;
---------------------------------------------------------
entity tb_logic is
    GENERIC (    n : integer := 8;
        k : integer := 3;   -- k=log2(n)
        m : integer := 4;   -- m=2^(k-1)
        ROWmax : integer := 19);
end tb_logic;
------------------------------------------------------------------------------
architecture rtb of tb_logic is
    SIGNAL X,Y:  STD_LOGIC_VECTOR (n-1 DOWNTO 0);
    SIGNAL ALUFN :  STD_LOGIC_VECTOR (2 DOWNTO 0);
    signal output : STD_LOGIC_VECTOR (n-1 DOWNTO 0);
begin
    L0 : Logic generic map (n) port map(x,y,ALUFN,output);

---------------- start of stimulus section ----------------------------------------		
    tb_x_y : process
    begin
    X <= (others => '0');
    Y <= (others => '1');
    for j in 0 to 7 loop
        for k in 0 to 4 loop
            wait for 50 ns; 
            Y <= Y + 20;
            X <= X + 35;
            end loop;
    end loop;      
    wait;

    end process;
      

    tb_ALUFN : process
    begin
    ALUFN <= (others => '0');
        for i in 0 to 7 loop
        wait for 200 ns;
        ALUFN <= ALUFN + 1;
        end loop;
        wait;
    end process tb_ALUFN;

end architecture rtb;
