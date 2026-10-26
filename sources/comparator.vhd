----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2026 15:23:35
-- Design Name: 
-- Module Name: comparator - Behavioral
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

entity comparator is
  Port (
        rs1, rs2        : in std_logic_vector(31 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        taken           : out std_logic
        );
end comparator;

architecture Behavioral of comparator is
-- rs1 and rs2 ports must be linked up with muxA and muxB signals.
begin

process(rs1,rs2,funct3) begin

Case funct3 is
    when "000" =>
        if rs1 = rs2 then
            taken <= '1';
        else
            taken <= '0';
        end if;
    when "001" =>
        if rs1 /= rs2 then
            taken <= '1';
        else
            taken <= '0';
        end if;
    when "100" =>
        if signed(rs1) < signed(rs2) then
            taken <= '1';
        else
            taken <= '0';
        end if;
    when "101" =>
        if signed(rs1) >= signed(rs2) then
            taken <= '1';
        else
            taken <= '0';
        end if;
    when "110" =>
        if unsigned(rs1) < unsigned(rs2) then
            taken <= '1';
        else
            taken <= '0';
        end if;
     when "111" =>
        if unsigned(rs1) >= unsigned(rs2) then
            taken <= '1';
        else
            taken <= '0';
        end if;
    when others =>
        taken <= '0';
end case;

--if funct3 = "000" and rs1 = rs2 then
--    taken <= '1';
--if funct3 = "001" and rs1 /= rs2 then
--    taken <= '1';
--if funct3 = "100" and signed(rs1) < signed(rs2) then
--    taken <= '1';
--if funct3 = "101" and signed(rs1) >= signed(rs2) then
--    taken <= '1';
--if funct3 = "110" and unsigned(rs1) < unsigned(rs2) then
--    taken <= '1';
--if funct3 = "111" and unsigned(rs1) >= unsigned(rs2) then
--    taken <= '1';
--end if;
--end if;
--end if;
--end if;
--end if;
--end if;
    

end process;     
end Behavioral;
