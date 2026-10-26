----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.06.2026 12:56:56
-- Design Name: 
-- Module Name: forwarding_unit - Behavioral
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

entity forwarding_unit is
    Port ( 
        rs1_adr, rs2_adr            : in std_logic_vector(4 downto 0);
        rd_mem, rd_wb               : in std_logic_vector(4 downto 0);
        reg_write_mem, reg_write_wb : in std_logic;
        for_a, for_b                : out std_logic_vector(1 downto 0)
    );
end forwarding_unit;

architecture Behavioral of forwarding_unit is
begin
    process(all) begin
        -- =====================================================================
        -- FORWARDING A (rs1_adr)
        -- =====================================================================
        -- 1. EX/MEM Hazard (En Yüksek Öncelik - MEM Aşaması)
        if (reg_write_mem = '1') and (rd_mem /= "00000") and (rd_mem = rs1_adr) then
            for_a <= "10"; -- EX/MEM aşamasındaki ALU sonucunu ilet

        -- 2. MEM/WB Hazard (Sadece EX/MEM Hazard yoksa geçerli olmalı!)
        elsif (reg_write_wb = '1') and (rd_wb /= "00000") and (rd_wb = rs1_adr) and 
              not (reg_write_mem = '1' and rd_mem /= "00000" and rd_mem = rs1_adr) then
            for_a <= "01"; -- MEM/WB aşamasındaki veriyi ilet

        else
            for_a <= "00"; -- Forwarding yok, doğrudan RegFile'dan oku
        end if; 

        -- =====================================================================
        -- FORWARDING B (rs2_adr)
        -- =====================================================================
        -- 1. EX/MEM Hazard (En Yüksek Öncelik)
        if (reg_write_mem = '1') and (rd_mem /= "00000") and (rd_mem = rs2_adr) then
            for_b <= "10";

        -- 2. MEM/WB Hazard
        elsif (reg_write_wb = '1') and (rd_wb /= "00000") and (rd_wb = rs2_adr) and 
              not (reg_write_mem = '1' and rd_mem /= "00000" and rd_mem = rs2_adr) then
            for_b <= "01";

        else
            for_b <= "00";
        end if; 

    end process;
end Behavioral;
