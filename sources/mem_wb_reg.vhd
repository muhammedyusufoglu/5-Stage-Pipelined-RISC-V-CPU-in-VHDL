----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2026 13:08:33
-- Design Name: 
-- Module Name: mem_wb_reg - Behavioral
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

entity mem_wb_reg is
  Port (
         ALU_Result, read_data         : in std_logic_vector(31 downto 0);
         imm, inst0                    : in std_logic_vector(31 downto 0);
         rd                            : in std_logic_vector(4 downto 0);
         mem_to_reg                    : in std_logic_vector(1 downto 0);
         reg_write                     : in std_logic;
         clk, reset                    : in std_logic;
         ----------------------------------------------------------------
         ALU_Res, read_data_wb         : out std_logic_vector(31 downto 0);
         imm_wb, inst0_wb              : out std_logic_vector(31 downto 0);
         rd_wb                         : out std_logic_vector(4 downto 0);
         mem_to_reg_wb                 : out std_logic_vector(1 downto 0);
         reg_write_wb                  : out std_logic
   );
end mem_wb_reg;

architecture Behavioral of mem_wb_reg is

signal ALU_Res_reg          : std_logic_vector(31 downto 0) := (others => '0');
signal memory_data_reg      : std_logic_vector(31 downto 0) := (others => '0');
signal imm_reg              : std_logic_vector(31 downto 0) := (others => '0');
signal inst0_reg            : std_logic_vector(31 downto 0) := (others => '0');
signal rd_register          : std_logic_vector(4 downto 0)  := (others => '0');
signal mem_Reg_reg          : std_logic_vector(1 downto 0)  := (others => '0');
signal reg_write_reg        : std_logic                     := '0';

begin

WRITE: process(clk) begin
        if rising_edge(clk) then
            if reset = '1' then
                ALU_Res_reg     <= (others => '0');
                memory_data_reg <= (others => '0');
                rd_register     <= (others => '0');   
                mem_Reg_reg     <= (others => '0');
                imm_reg         <= (others => '0');
                inst0_reg       <= (others => '0');
                reg_write_reg   <= '0';
            else
                ALU_Res_reg     <= ALU_Result;
                memory_data_reg <= read_data;
                rd_register     <= rd;
                mem_Reg_reg     <= mem_to_reg;
                reg_write_reg   <= reg_Write;
                imm_reg         <= imm;
                inst0_reg       <= inst0;
            end if;            
        end if;
    
     end process;

ALU_Res <= ALU_Res_Reg;
rd_wb   <= rd_Register;             
mem_to_reg_wb  <= mem_reg_reg;      
reg_write_wb   <= reg_write_reg;     
read_data_wb   <= memory_data_reg;
imm_wb         <= imm_reg;
inst0_wb       <= inst0_reg;
     

end Behavioral;
