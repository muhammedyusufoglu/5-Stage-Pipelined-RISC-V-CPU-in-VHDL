----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 14:29:13
-- Design Name: 
-- Module Name: hazard_detection_unit - Behavioral
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

entity hazard_detection_unit is
  Port (
         rs1, rs2, rd_ex:  in std_logic_vector(4 downto 0);
         mem_read_ex    :  in std_logic;
         stall          :  out std_logic
   );
end hazard_detection_unit;

architecture Behavioral of hazard_detection_unit is

begin

process(all) begin

--- rs1
if mem_read_ex = '1' and rd_ex /= "00000" and (rd_ex = rs1 or rd_ex = rs2) then
    stall <= '1';
else
    stall <= '0';
end if; 


end process;
end Behavioral;
