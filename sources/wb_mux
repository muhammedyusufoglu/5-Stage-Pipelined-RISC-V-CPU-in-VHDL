----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2026 14:23:15
-- Design Name: 
-- Module Name: wb_mux - Behavioral
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

entity wb_mux is
  Port (
        mem_to_reg              : in std_logic_vector(1 downto 0);
        ALU_Result              : in std_logic_vector(31 downto 0);
        read_data               : in std_logic_vector(31 downto 0);
        inst0                   : in std_logic_vector(31 downto 0);
        imm                     : in std_logic_vector(31 downto 0);
        -----------------------------------------------------------
        wb_out                  : out std_logic_vector(31 downto 0)
         );
end wb_mux;

-- mem_to_reg =====> 00, 01, 10, 11
-- 00 => ALU_Result
-- 01 => read_data
-- 10 => PC+4
-- 11 => Imm

architecture Behavioral of wb_mux is

begin
    process(all) begin
        Case mem_to_reg is
            when "00" => wb_out <= ALU_Result;
            when "01" => wb_out <= read_data;
            when "10" => wb_out <= inst0;
            when "11" => wb_out <= imm;
        end case;
    end process;
end Behavioral;
