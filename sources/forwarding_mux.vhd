----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 13:28:09
-- Design Name: 
-- Module Name: forwarding_mux - Behavioral
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

entity forwarding_mux is
Port (
       rs1, rs2, write_data, ALU_Result: in std_logic_vector(31 downto 0);
       for_a, for_b:                     in std_logic_vector(1 downto 0);
       mux_a, mux_b:                     out std_logic_vector(31 downto 0)
       );
end forwarding_mux;

architecture Behavioral of forwarding_mux is

begin

process(rs1, rs2, write_data, ALU_Result, for_a, for_b) begin
-- 00 = write data, 01 = ALU_Result, 11= rs
--Mux A

Case for_a is
    when "01" => mux_a <= write_data;
    when "10" => mux_a <= ALU_Result;
    when "00" => mux_a <= rs1;
    when others => mux_a <= rs1;
    end case;

Case for_b is
    when "01" => mux_b <= write_data;
    when "10" => mux_b <= ALU_Result;
    when "00" => mux_b <= rs2;
    when others => mux_b <= rs2;
    end case;
    
end process;
end Behavioral;
