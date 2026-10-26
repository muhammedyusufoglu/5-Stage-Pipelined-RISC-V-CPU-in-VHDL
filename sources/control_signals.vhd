----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2026 15:00:50
-- Design Name: 
-- Module Name: control_signals - Behavioral
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

entity control_signals is
   Port (
         stall                  : in std_logic;
         mem_write              : in std_logic;
         mem_read               : in std_logic;
         reg_write              : in std_logic;
         ALU_Src                : in std_logic;
         ALU_Src2               : in std_logic;
         mem_to_reg             : in std_logic_vector(1 downto 0);
         ALU_Op                 : in std_logic_vector(1 downto 0);
         Jump                   : in std_logic;
         Branch                 : in std_logic;
         Adder_Src              : in std_logic;
         
         
         ---------------------------------------------------------
         mem_write_and          : out std_logic;
         mem_read_and           : out std_logic;
         reg_write_and          : out std_logic;
         ALU_Src_and            : out std_logic;
         ALU_Src2_and           : out std_logic;
         Jump_and               : out std_logic;
         Branch_and             : out std_logic;
         Adder_Src_and          : out std_logic;
         mem_to_reg_and         : out std_logic_vector(1 downto 0);
         ALU_Op_and             : out std_logic_vector(1 downto 0)
        
    );
end control_signals;

architecture Behavioral of control_signals is

begin
    
    mem_write_and  <= mem_write  when stall = '0' else '0';
    mem_read_and   <= mem_read   when stall = '0' else '0';
    reg_write_and  <= reg_write  when stall = '0' else '0';
    Jump_and       <= Jump       when stall = '0' else '0';
    Branch_and     <= Branch     when stall = '0' else '0';
    Adder_Src_and  <= Adder_Src  when stall = '0' else '0';
    ALU_Src_and    <= ALU_Src    when stall = '0' else '0';
    ALU_Src2_and   <= ALU_Src2   when stall = '0' else '0';   
    mem_to_reg_and <= mem_to_reg when stall = '0' else "00";
    ALU_Op_and     <= ALU_Op     when stall = '0' else "00";

end Behavioral;
