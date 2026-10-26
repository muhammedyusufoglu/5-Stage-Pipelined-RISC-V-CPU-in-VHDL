----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.05.2026 23:19:47
-- Design Name: 
-- Module Name: inst_mem - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library STD;
use STD.textio.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values



entity inst_mem is
    generic(
        RAM_DEPTH : integer := 2048;
        FILE_NAME : string  := "C:\Users\myusu\Desktop\pipelined_riscv\pipelined_riscv.srcs\sources_1\imports\new\instr_program.mem"
    );
    port(
       current_inst : in std_logic_vector(31 downto 0);
        next_inst    : out std_logic_vector(31 downto 0)        
    );
end inst_mem;

architecture Behavioral of inst_mem is
type mem_type is array (0 to RAM_DEPTH -1) of std_logic_vector(31 downto 0);

impure function init_mem_from_file(file_path : string) return mem_type is 
    file f_ptr      :text open read_mode is file_path;
    variable        v_line: line;
    variable        v_hex : std_logic_vector(31 downto 0);
    variable        temp_mem: mem_type := (others => (others => '0'));
    
    begin
    for i in 0 to RAM_DEPTH-1 loop
    if not endfile(f_ptr) then
    readline(f_ptr, v_line);
    hread(v_line, v_hex);
    temp_mem(i) := v_hex;
    else
        exit;
    end if;
   end loop;
   return temp_mem;
  end function;

signal inst_memory : mem_type := init_mem_from_file(FILE_NAME);
begin
next_inst <= inst_memory(to_integer(unsigned(current_inst(12 downto 2))));
end Behavioral;
