----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.06.2026 13:34:13
-- Design Name: 
-- Module Name: if_id_reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity if_id_reg is
    Port( 
        current_inst            : in std_logic_vector(31 downto 0);
        inst0                   : in std_logic_Vector(31 downto 0); 
        current_pc              : in std_logic_vector(31 downto 0);
        stall, clk, reset, flush: in std_logic;
        current_pc_out          : out std_logic_vector(31 downto 0);
        inst0_out          : out std_logic_vector(31 downto 0);
        current_inst_out        : out std_logic_vector(31 downto 0)       
);
end if_id_reg;

architecture Behavioral of if_id_reg is

type reg is array (0 to 1) of std_logic_vector(31 downto 0);
signal inst: reg := (others => (others => '1'));
signal inst0_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
   WRITE_PROCESS: process(clk) begin
        if rising_edge(clk) then
            if reset = '1' then
                inst(0)   <= (others => '0');
                inst(1)   <= (others => '0');
                inst0_reg <= (others => '0');
            else
                if flush = '1' then
                --PRIORITY
                 inst(0) <= (others => '0');
                 inst(1) <= (others => '0');
                 inst0_reg <= (others => '0');

                elsif stall = '0' then
                
                 inst(0)<= current_inst;
                 inst(1)<= current_pc;
                 inst0_reg <= inst0;
                 end if;
                    
            end if;
        end if;                         
    end process;
          
current_inst_out <= inst(0);
current_pc_out   <= inst(1);
inst0_out        <= inst0_reg;
       
            
   
end Behavioral;
