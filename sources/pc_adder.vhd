----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2026 14:36:21
-- Design Name: 
-- Module Name: pc_adder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pc_adder is
  Port (
        current_pc              : in std_logic_vector(31 downto 0);
        -----------------------------------------------------------
        next_pc                 : out std_logic_vector(31 downto 0)
   );
end pc_adder;

architecture Behavioral of pc_adder is
begin
    
    next_pc <= std_logic_vector(unsigned(current_pc) + 4);

end Behavioral;
