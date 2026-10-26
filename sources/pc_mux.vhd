----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2026 10:32:13
-- Design Name: 
-- Module Name: pc_mux - Behavioral
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

entity pc_mux is
  Port (
         pc, new_target             : in  std_logic_vector(31 downto 0);
         jump, branch, branch_taken : in  std_logic;
         next_pc                    : out std_logic_vector(31 downto 0);
         flush                      : out std_logic
         
   );
end pc_mux;

architecture Behavioral of pc_mux is
    signal sel: std_logic; 
begin
    sel <= jump or (branch and branch_taken);
process(all) begin    
   
    Case sel is
        when '0' => next_pc <= pc;
        when '1' => next_pc <= new_target;
        when others => next_pc <= pc;
    end case;
    
end process;

    flush <= sel;
    
end Behavioral;
