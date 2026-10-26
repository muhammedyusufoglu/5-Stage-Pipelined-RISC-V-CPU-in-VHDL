----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2026 01:15:39
-- Design Name: 
-- Module Name: program_counter - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity program_counter is
port(
    clk, reset, stall  : in std_logic;
    next_inst   : in std_logic_vector(31 downto 0);
    current_inst: out std_logic_vector(31 downto 0)
);
end program_counter;

architecture Behavioral of program_counter is

begin
    process(clk)
    begin
     if rising_edge(clk) then
        if reset = '1' then
            current_inst <= (others => '0');
        elsif stall = '0' then
            current_inst <= next_inst;
        end if;
        end if;
     end process;
            
end Behavioral;
