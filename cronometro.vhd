

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cronometro is
port(
	clk: in std_logic;
	botao1: in std_logic;  -- Inicia/Finaliza contagem
	botao2: in std_logic;  -- Muda a unidade de tempo do display
	pulso1PF: out std_logic;
	an: out std_logic_vector(3 downto 0); --Multiplexação do display
	display: out std_logic_vector (7 downto 0) --Segmentos do display
);
end cronometro;

architecture cron of cronometro is

-- Declaração do component mul_display
component mul_display
port(
  disp0: in std_logic_vector (3 downto 0);
  disp1: in std_logic_vector (3 downto 0);
  disp2: in std_logic_vector (3 downto 0);
  disp3: in std_logic_vector (3 downto 0);
  indi: in std_logic_vector (1 downto 0);
  display_saida: out std_logic_vector (7 downto 0)
  );
end component;


-- Definição de sinais que serão utilizados
signal clk100: std_logic; 			-- clock de 100Hz
signal debCont1: std_logic_vector (1 downto 0); -- contador de clocks debounce1
signal debCont2: std_logic_vector (1 downto 0); -- contador de clocks debounce2
signal pulso1: std_logic;			-- debounce do botao1
signal pulso2: std_logic;			-- debounce do botao2
signal cronFlag: std_logic;		-- flag que inicia cronometragem

-- Sinais utilizados para facilitar contagem	  -- limite de estouro
signal centesimos: std_logic_vector (3 downto 0); -- até 9
signal decimos: std_logic_vector (3 downto 0);    -- até 9
signal segundosR: std_logic_vector (3 downto 0);  -- até 9
signal segundosL: std_logic_vector (3 downto 0);  -- até 5
signal minutosR: std_logic_vector (3 downto 0);   -- até 9
signal minutosL: std_logic_vector (3 downto 0);   -- até 5
signal horasR: std_logic_vector (3 downto 0);     -- varia de 0-9 e 0-4
signal horasL: std_logic_vector (3 downto 0);     -- vai até 2

-- Sinais para os segmentos do display
signal display0: std_logic_vector (3 downto 0); -- buffer: display da esquerda
signal display1: std_logic_vector (3 downto 0); -- meio esquerdo
signal display2: std_logic_vector (3 downto 0); -- meio direito
signal display3: std_logic_vector (3 downto 0); -- buffer: display da direita

-- Sinais para determinar unidade do Display
signal indice: std_logic_vector (1 downto 0); -- contador do display
signal unidade: std_logic_vector (1 downto 0); -- 3 modos:
							                           -- 00: SegundosL SegundosR Décimos Centésimos
							                           -- 01: MinutosL MinutosR SegundosL SegundosR
							                           -- 10: HorasL HorasR MinutosL MinutosR

begin
  -- Chama o component mul_display
  dspy: mul_display port map (disp0=>display0, 
                              disp1=>display1, 
										disp2=>display2, 
										disp3=>display3, 
										indi=>indice, 
										display_saida=>display);
										
  -- Faz a seleção para a multiplexação do display
  with indice select
    an <= "1110" when "00",
          "1101" when "01",
          "1011" when "10",
          "0111" when "11";

  -------------------------------------------------------------------------
  -- Gera o clk100 a partir do clk de maquina
  process (clk)
  --variable clkCont: std_logic_vector (18 downto 0):= "0000000000000000000"; -- contador de clocks para o clock gerado
  --variable Cont: std_logic_vector (14 downto 0):= "000000000000000"; -- contador de clocks para o display
  variable Cont: integer := 0;
  variable clkCont: integer := 0;

  begin
  
    if (clk'event and clk = '1') then -- A borda do clock foi alterada e está em nível logico alto
	   ----------------MULTIPLEXAR DISPLAY A CADA 0,25 ms ----------------
		-- frequencia do FPGA: 100 000 000 Hz
		-- 0,00025 = 1 / (100000000/Num_Ciclos) => Num_Ciclos = 25000
		-- Para alterar o valor a cada deve-se esperar 25 000 ciclos
		----------------------------------------------------------------------
	   --if (Cont < "111111111") then
	   if (Cont < 25000) then
	     Cont := Cont + 1;
      else
	     Cont := 0;
		  --indice <= (indice+1) when indice < "11" else "00";
	     if indice < "11" then
		    indice <= indice+1;
		  else
		    indice <= "00";
	     end if;
      end if;
		
	   ----------------GERAR CLOCK DE UM CENTESIMO DE SEGUNDO----------------
		-- Para gerar um clock com periodo de um centesimo de segundo, então
		-- o nivel logico do clock deve mudar a cada meio centesimo de segundo
	   -- frequencia do FPGA: 100 000 000 Hz
		-- 0,005 = 1 / (100000000/Num_Ciclos) => Num_Ciclos = 500000
		-- Para meio centesimo de segundo, deve-se esperar 500 000 ciclos
		----------------------------------------------------------------------
	   if (clkCont < 500000) then
	     clkCont := clkCont + 1;
      else
	     clkCont := 0;
	     clk100 <= not clk100; -- muda o nivel lógico do clock gerado
      end if;
    end if;
  end process;

-------------------------------------------------------------------------
  -- Debounce dos botões
  process (clk100)
  begin
    if (clk100'event and clk100 = '1') then -- Borda de subida do clock gerado
      -- Debounce do botao1
      if (botao1 = '0') then -- botao pressionado
	     if (debCont1 < "11") then
	       debCont1 <= debCont1 + 1;
	       if (debCont1 = "10") then
	         pulso1 <= '1';
	       end if;
	     else
	       pulso1 <= '0';
	     end if;
      else
	     pulso1 <= '0';
	     debCont1 <= "00";
      end if;
      
      -- Debounce do botao2
      if (botao2 = '0') then -- botao pressionado
	     if (debCont2 < "11") then
	       debCont2 <= debCont2 + 1;
	       if (debCont2 = "10") then
	         pulso2 <= '1';
	       end if;
	     else
	       pulso2 <= '0';
	     end if;
      else
	     pulso2 <= '0';
	     debCont2 <= "00";
      end if;
    end if;
  end process;

-------------------------------------------------------------------------
  -- Processa o botao1 e botao2 depois do debounce
  process (pulso1, pulso2)
  begin
    pulso1PF <= pulso1;
    if (pulso1'event and pulso1 = '1') then
      cronFlag <= not cronFlag;
    end if;
    
    if (pulso2'event and pulso2 = '1') then
      if (unidade < "10") then
	     unidade <= unidade + 1;
      else
	     unidade <= "00";
      end if;
    end if;
  end process;

-------------------------------------------------------------------------	
  -- Processa as contagens
  process (clk100, cronFlag)
  begin
    if (clk100'event and clk100 = '0') then
      if (cronFlag = '1') then -- começa a cronometragem
	     if (centesimos < "1001") then
	       centesimos <= centesimos + 1;
	     else
	       centesimos <= "0000";
	       if (decimos < "1001") then
	         decimos <= decimos + 1;
	       else
	         decimos <= "0000";
	         if (segundosR < "1001") then
	           segundosR <= segundosR + 1;
	         else
	           segundosR <= "0000";
	           if (segundosL < "0101") then
                segundosL <= segundosL + 1;
	           else
                segundosL <= "0000";
                if (minutosR < "1001") then
                  minutosR <= minutosR + 1;
                else
                  minutosR <= "0000";
                  if (minutosL < "0101") then
                    minutosL <= minutosL + 1;
                  else
                    minutosL <= "0000";
                    if (horasL < "0010") then
                      if (horasR < "1001") then
      	               horasR <= horasR + 1;
                      else
                        horasR <= "0000";
                        horasL <= horasL +1;
		                end if;
		              else
  		              if (horasR < "0100") then
			               horasR <= horasR + 1;
		                else
  			               horasR <= "0000";
			               horasL <= "0000";
		                end if;
		              end if;
		            end if;
		          end if;
	           end if;
	         end if;
	       end if;
        end if;
      end if;
      
      -- Implementação dos modos dos displays:
      if (unidade = "00") then  -- S S D C
        display3 <= segundosL;
        display2 <= segundosR;
        display1 <= decimos;
        display0 <= centesimos;
      end if;
      if (unidade = "01") then  -- M M S S
        display3 <= minutosL;
        display2 <= minutosR;
        display1 <= segundosL;
        display0 <= segundosR;
      end if;
	   if (unidade = "10") then  -- H H M M
        display3 <= horasR;
        display2 <= horasL;
        display1 <= minutosL;
        display0 <= minutosR;
      end if;		
    end if;
  end process;

end cron;