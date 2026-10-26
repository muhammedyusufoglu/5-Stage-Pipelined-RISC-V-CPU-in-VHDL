----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.05.2026 13:22:12
-- Design Name: 
-- Module Name: imm_gen - Behavioral
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

entity imm_gen is
    Port ( 
        Instruction        : in  std_logic_vector(31 downto 0);
        Immediate          : out std_logic_vector(31 downto 0)
    );
end imm_gen;

architecture Behavioral of imm_gen is

signal lui_type: std_logic_vector(19 downto 0); -- includes LUI and AUIPC
signal l_type:   std_logic_vector(11 downto 0); -- includes L-type, I-Type and JALR instructions.
signal j_type:   std_logic_vector(19 downto 0);
signal b_type:   std_logic_vector(11 downto 0);
signal s_type:   std_logic_vector(11 downto 0);
signal opcode:   std_logic_vector(6 downto 0);

begin
lui_type <= Instruction(31 downto 12);
l_type   <= Instruction(31 downto 20);
j_type <= Instruction(31) & Instruction(19 downto 12) & Instruction(20) & Instruction(30 downto 21);
b_type   <= Instruction(31) & Instruction(7) & Instruction(30 downto 25) & Instruction(11 downto 8);
s_type   <= Instruction(31 downto 25) & Instruction(11 downto 7);
opcode   <= Instruction(6 downto 0);

process(lui_type, l_type, j_type, b_type, s_type, opcode, Instruction) begin
    if Opcode = "0110111" or Opcode = "0010111" then
        Immediate <= lui_type & (11 downto 0 => '0');
    elsif Opcode = "0000011" or Opcode = "1100111" or Opcode = "0010011" then
        Immediate <= (19 downto 0 => l_type(11)) & l_type;
    elsif Opcode = "1101111" then
        Immediate <= (10 downto 0 => j_type(19)) & j_type & '0';
    elsif Opcode = "1100011" then
        Immediate <= (18 downto 0 => b_type(11)) & b_type & '0';
    elsif Opcode = "0100011" then
        Immediate <= (19 downto 0 => s_type(11)) & s_type;
    else
        Immediate <= (others => '0');
    end if;

end process;
end Behavioral;
