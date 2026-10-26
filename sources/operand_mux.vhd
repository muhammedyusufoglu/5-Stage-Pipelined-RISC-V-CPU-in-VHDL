----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 14:06:35
-- Design Name: 
-- Module Name: operand_mux - Behavioral
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

entity operand_mux is
    Port (
           imm, PC, mux_a, mux_b:   in std_logic_vector(31 downto 0);
           ALU_Src1, ALU_Src2   :   in std_logic;
           operand_1, operand_2 :   out std_logic_vector(31 downto 0)
     );
end operand_mux;

architecture Behavioral of operand_mux is

begin

process(all) begin

Case ALU_Src1 is
    when '0' => operand_1 <= mux_a;
    when '1' => operand_1 <= PC;
    when others => operand_1 <= mux_a;
end case;

Case ALU_Src2 is
    when '0' => operand_2 <= mux_b;
    when '1' => operand_2 <= imm;
    when others => operand_2 <= mux_b;
end case;

end process;
end Behavioral;
