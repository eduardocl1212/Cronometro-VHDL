--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:59:04 04/27/2015
-- Design Name:   
-- Module Name:   C:/Users/Lucas/cronometro/asdf.vhd
-- Project Name:  cronometro
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cronometro
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY asdf IS
END asdf;
 
ARCHITECTURE behavior OF asdf IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cronometro
    PORT(
         clk : IN  std_logic;
         clockPF100 : OUT  std_logic;
         an : OUT  std_logic_vector(3 downto 0);
         display : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal botao1 : std_logic := '0';
   signal botao2 : std_logic := '0';

 	--Outputs
   signal clockPF100 : std_logic;
   signal pulso1PF : std_logic;
   signal an : std_logic_vector(3 downto 0);
   signal display : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clockPF100_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cronometro PORT MAP (
          clk => clk,
          botao1 => botao1,
          botao2 => botao2,
          clockPF100 => clockPF100,
          pulso1PF => pulso1PF,
          an => an,
          display => display
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   clockPF100_process :process
   begin
		clockPF100 <= '0';
		wait for clockPF100_period/2;
		clockPF100 <= '1';
		wait for clockPF100_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
