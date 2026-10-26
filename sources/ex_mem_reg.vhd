----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2026 10:49:47
-- Design Name: 
-- Module Name: ex_mem_reg - Behavioral
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

entity ex_mem_reg is
  Port (
         mem_write_ex, mem_read_ex, reg_write_ex            : in std_logic;
         clk, reset                                         : in std_logic;
         mem_to_reg                                         : in std_logic_vector(1 downto 0);
         rd                                                 : in std_logic_vector(4 downto 0);
         ALU_Result, rs2_for, imm, inst0                    : in std_logic_vector(31 downto 0);
         funct3                                             : in std_logic_vector(2 downto 0);
         ----------------------------------------------------------------------------------------
         mem_write_mem, mem_read_mem, reg_write_mem         : out std_logic;
         mem_to_reg_mem                                     : out std_logic_vector(1 downto 0);
         rd_mem                                             : out std_logic_vector(4 downto 0);
         ALU_Result_mem, rs2_for_mem, imm_mem,inst0_mem     : out std_logic_vector(31 downto 0);
         funct3_mem                                         : out std_logic_vector(2 downto 0)
   );
end ex_mem_reg;
-- rs2_for = muxB_2
architecture Behavioral of ex_mem_reg is
signal alu_register        : std_logic_vector(31 downto 0) := (others => '0');
signal rs2_for_register    : std_logic_vector(31 downto 0) := (others => '0');
signal rd_register         : std_logic_vector(4 downto 0)  := (others => '0');
signal mem_to_reg_register : std_logic_Vector(1 downto 0) := (others => '0');
signal imm_register        : std_logic_Vector(31 downto 0) := (others => '0');
signal mem_write_reg       : std_logic := '0';
signal mem_read_reg        : std_logic := '0';
signal reg_write_reg       : std_logic := '0';
signal inst0_register      : std_logic_Vector(31 downto 0) := (others => '0');
signal funct3_register     : std_logic_vector(2 downto 0)  := (others => '0');

begin

WRITE:  process(clk) begin
            if rising_edge(clk) then
                if reset = '1' then
                   alu_register        <= (others => '0');       
                   rs2_for_register    <= (others => '0'); 
                   rd_register         <= (others => '0'); 
                   mem_to_reg_register <= (others => '0'); 
                   mem_write_reg       <= '0'; 
                   mem_read_reg        <= '0'; 
                   reg_write_reg       <= '0'; 
                   inst0_register      <= (others => '0'); 
                   imm_register        <= (others => '0'); 
                   funct3_register     <= (others => '0');
                 else 
                   alu_register        <= ALU_Result;
                   rs2_for_register    <= rs2_for;
                   rd_register         <= rd;
                   mem_to_reg_register <= mem_to_reg;
                   mem_write_reg       <= mem_write_ex;
                   mem_read_reg        <= mem_read_ex;
                   reg_write_reg       <= reg_write_ex;
                   inst0_register      <= inst0;
                   imm_register        <= imm;       
                   funct3_register     <= funct3;
                 end if;
            end if;
end process;

ALU_Result_mem <= alu_register;
rs2_for_mem    <= rs2_for_register;
rd_mem         <= rd_register;
mem_to_reg_mem <= mem_to_reg_register;
mem_write_mem  <= mem_write_reg;
mem_read_mem   <= mem_read_reg;
reg_write_mem  <= reg_write_reg;
imm_mem        <= imm_register;
inst0_mem      <= inst0_register;
funct3_mem     <= funct3_register;

end Behavioral;
