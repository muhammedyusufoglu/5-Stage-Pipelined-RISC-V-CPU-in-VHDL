----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2026 16:13:37
-- Design Name: 
-- Module Name: alu - Behavioral
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

entity alu is
  Port ( 
        operand_1   : in  std_logic_vector(31 downto 0);
        operand_2   : in  std_logic_vector(31 downto 0);
        Alu_control : in  std_logic_vector(3 downto 0);
        ALU_Result  : out std_logic_vector(31 downto 0)
    );
end alu;

architecture Behavioral of alu is

begin
    process(operand_1, operand_2, Alu_control)
    begin
        case Alu_control is
            
            
            when "1000" => 
                ALU_Result <= std_logic_vector(unsigned(operand_1) + unsigned(operand_2));
            
            when "1001" => 
                ALU_Result <= std_logic_vector(unsigned(operand_1) - unsigned(operand_2));

            when "0110" => 
                ALU_Result <= operand_1 and operand_2;

            when "0100" => 
                ALU_Result <= operand_1 or operand_2;

            when "1101" => 
                ALU_Result <= operand_1 xor operand_2;

            when "1010" => 
                ALU_Result <= std_logic_vector(shift_left(unsigned(operand_1), to_integer(unsigned(operand_2(4 downto 0)))));

            when "1110" => 
                ALU_Result <= std_logic_vector(shift_right(unsigned(operand_1), to_integer(unsigned(operand_2(4 downto 0)))));

            when "1111" => 
                ALU_Result <= std_logic_vector(shift_right(signed(operand_1), to_integer(unsigned(operand_2(4 downto 0)))));

            when "1011" => 
                if signed(operand_1) < signed(operand_2) then
                    ALU_Result <= x"00000001";
                else
                    ALU_Result <= x"00000000";
                end if;

            when "1100" => 
                if unsigned(operand_1) < unsigned(operand_2) then
                    ALU_Result <= x"00000001";
                else
                    ALU_Result <= x"00000000";
                end if;

            when others => 
                ALU_Result <= (others => '0');
                
        end case;
    end process;

end Behavioral;
