----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.05.2026 14:47:43
-- Design Name: 
-- Module Name: register_file - Behavioral
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

entity register_file is
port(
    clk, reset, reg_write              :in std_logic;
    rs1, rs2                           :out std_logic_vector(31 downto 0);
    rd_addr, rs1_addr, rs2_addr        :in std_logic_vector(4 downto 0); 
    write                              :in std_logic_vector(31 downto 0)        
);
end register_file;

architecture Behavioral of register_file is
type registerfile is array (0 to 31) of std_logic_vector(31 downto 0);
signal reg : registerfile := (others => (others => '0')); 

begin
process(clk, reset) begin
    if reset = '1' then
        reg <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reg_write = '1' and  rd_addr /= "00000" then
                reg(to_integer(unsigned(rd_addr))) <= write;
            end if;
        end if;                
end process;

--rs1 <= reg(to_integer(unsigned(rs1_addr)));
--rs2 <= reg(to_integer(unsigned(rs2_addr))); 

rs1 <= write when (reg_write = '1' and rd_addr = rs1_addr and rd_addr /= "00000")
       else reg(to_integer(unsigned(rs1_addr)));

rs2 <= write when (reg_write = '1' and rd_addr = rs2_addr and rd_addr /= "00000")
       else reg(to_integer(unsigned(rs2_addr)));

end Behavioral;
