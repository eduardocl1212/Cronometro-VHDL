----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:56:25 04/28/2015 
-- Design Name: 
-- Module Name:    mul_display - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_display is
port(
  disp0: in std_logic_vector (3 downto 0);
  disp1: in std_logic_vector (3 downto 0);
  disp2: in std_logic_vector (3 downto 0);
  disp3: in std_logic_vector (3 downto 0);
  indi: in std_logic_vector (1 downto 0);
  display_saida: out std_logic_vector (7 downto 0)
);
end mul_display;

architecture Behavioral of mul_display is

type caractere_display is array (0 to 9) of std_logic_vector(7 downto 0);
constant lista_caractere_display: caractere_display := (
        0 => "00000011", 
		  1 => "10011111", 
		  2 => "00100101", 
		  3 => "00001101", 
		  4 => "10011001",
        5 => "01001001", 
		  6 => "01000001", 
		  7 => "00011011", 
		  8 => "00000001", 
		  9 => "00001001"
);

begin
  
  process (indi,disp0,disp1,disp2,disp3)
  begin
      -- Display
    if indi = "00" then
	 case disp0 is
      when "0000" => display_saida <= lista_caractere_display(0); --0
      when "0001" => display_saida <= lista_caractere_display(1); --1
      when "0010" => display_saida <= lista_caractere_display(2); --2
      when "0011" => display_saida <= lista_caractere_display(3); --3
      when "0100" => display_saida <= lista_caractere_display(4); --4
      when "0101" => display_saida <= lista_caractere_display(5); --5
      when "0110" => display_saida <= lista_caractere_display(6); --6
      when "0111" => display_saida <= lista_caractere_display(7); --7
      when "1000" => display_saida <= lista_caractere_display(8); --8
      when "1001" => display_saida <= lista_caractere_display(9); --9
      when others => display_saida <= "11111111";
    end case;
	 else if indi = "01" then
	 case disp1 is
      when "0000" => display_saida <= lista_caractere_display(0); --0
      when "0001" => display_saida <= lista_caractere_display(1); --1
      when "0010" => display_saida <= lista_caractere_display(2); --2
      when "0011" => display_saida <= lista_caractere_display(3); --3
      when "0100" => display_saida <= lista_caractere_display(4); --4
      when "0101" => display_saida <= lista_caractere_display(5); --5
      when "0110" => display_saida <= lista_caractere_display(6); --6
      when "0111" => display_saida <= lista_caractere_display(7); --7
      when "1000" => display_saida <= lista_caractere_display(8); --8
      when "1001" => display_saida <= lista_caractere_display(9); --9
      when others => display_saida <= "11111111";
    end case;
	 else if indi = "10" then
	 case disp2 is
      when "0000" => display_saida <= lista_caractere_display(0); --0
      when "0001" => display_saida <= lista_caractere_display(1); --1
      when "0010" => display_saida <= lista_caractere_display(2); --2
      when "0011" => display_saida <= lista_caractere_display(3); --3
      when "0100" => display_saida <= lista_caractere_display(4); --4
      when "0101" => display_saida <= lista_caractere_display(5); --5
      when "0110" => display_saida <= lista_caractere_display(6); --6
      when "0111" => display_saida <= lista_caractere_display(7); --7
      when "1000" => display_saida <= lista_caractere_display(8); --8
      when "1001" => display_saida <= lista_caractere_display(9); --9
      when others => display_saida <= "11111111";
    end case;
	 else
	 case disp3 is
      when "0000" => display_saida <= lista_caractere_display(0); --0
      when "0001" => display_saida <= lista_caractere_display(1); --1
      when "0010" => display_saida <= lista_caractere_display(2); --2
      when "0011" => display_saida <= lista_caractere_display(3); --3
      when "0100" => display_saida <= lista_caractere_display(4); --4
      when "0101" => display_saida <= lista_caractere_display(5); --5
      when "0110" => display_saida <= lista_caractere_display(6); --6
      when "0111" => display_saida <= lista_caractere_display(7); --7
      when "1000" => display_saida <= lista_caractere_display(8); --8
      when "1001" => display_saida <= lista_caractere_display(9); --9
      when others => display_saida <= "11111111";
    end case;
	 end if;
   end if;
 end if;
 end process;
	
	
--		with disp0 select
--	     display_saida <= lista_caractere_display(0) when "0000",
--        lista_caractere_display(1) when "0001",
--		  lista_caractere_display(2) when "0010",
--		  lista_caractere_display(3) when "0011",
--		  lista_caractere_display(4) when "0100",
--		  lista_caractere_display(5) when "0101",
--		  lista_caractere_display(6) when "0110",
--		  lista_caractere_display(7) when "0111",
--		  lista_caractere_display(8) when "1000",
--		  lista_caractere_display(9) when "1001",
--	     "11111111" when others;
		  
end Behavioral;

