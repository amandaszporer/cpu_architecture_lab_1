library IEEE;
use ieee.std_logic_1164.all;
package aux_package is
--------------------------------------------------------
	COMPONENT top is
	GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
	PORT 
	(  
		Y_i,X_i: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
		ALUFN_i : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC 
	); -- Zflag,Cflag,Nflag,Vflag
	END COMPONENT;
---------------------------------------------------------  
	COMPONENT FA is
		PORT (xi, yi, cin: IN std_logic;
			      s, cout: OUT std_logic);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT AdderSub IS
	GENERIC (n : INTEGER := 8);
	PORT (    x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
				cout: OUT STD_LOGIC;
				ALUFN: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
				s: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Shifter is
		GENERIC (
			n : integer := 8;  -- n = 8 
			k : integer := 3;  -- log2(n) = 3
			m : integer := 4   -- 2^(k-1) = 4
		);
		PORT (
			x,y           : in  std_logic_vector(n-1 downto 0);   -- x,y input
			ALUFN       : in std_logic_vector(2 downto 0);      -- Shifter selector: "000" = shift left, "001" = shift right.
			res : out std_logic_vector(n-1 downto 0);   -- Shifter output
			cout: out std_logic                        -- Shifter carry output
		);
	END COMPONENT;
---------------------------------------------------------
	COMPONENT Logic IS
		GENERIC (n : INTEGER := 8);
		PORT (x,y: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			ALUFN: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			output: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0));
	END COMPONENT;

	
end aux_package;

