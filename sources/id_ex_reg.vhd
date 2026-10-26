----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.07.2026 13:46:24
-- Design Name: 
-- Module Name: id_ex_reg - Behavioral
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

entity id_ex_reg is
  Port (
         rs1, rs2, imm                         : in std_logic_vector(31 downto 0);
         rd,rs1_addr, rs2_addr                 : in std_logic_vector(4 downto 0);
         ALU_Src, ALU_Src2, reg_write          : in std_logic;
         mem_read, mem_write                   : in std_logic;
         Jump                                  : in std_logic;
         Adder_Src                             : in std_logic;
         Branch                                : in std_logic;
         mem_to_reg                            : in std_logic_vector(1 downto 0);
         ALU_Op                                : in std_logic_vector(1 downto 0);
         funct3                                : in std_logic_vector(2 downto 0);
         funct7                                : in std_logic_vector(6 downto 0);
         clk,reset                             : in std_logic;
         flush                                 : in std_logic;
         inst0                                 : in std_logic_vector(31 downto 0);
         current_pc                            : in std_logic_vector(31 downto 0);
         -----------------------------------------------------------------
         rs1_ex, rs2_ex , imm_ex               : out std_logic_vector(31 downto 0);
         rd_ex, rs1a_ex, rs2aex                : out std_logic_vector(4 downto 0);
         ALU_Src_ex, ALU_Src2_ex, reg_write_ex : out std_logic;
         mem_read_ex, mem_write_ex             : out std_logic;
         mem_to_reg_ex                         : out std_logic_vector(1 downto 0);
         ALU_Op_ex                             : out std_logic_vector(1 downto 0);
         funct3_ex                             : out std_logic_vector(2 downto 0);
         funct7_ex                             : out std_logic_vector(6 downto 0);        
         inst0_ex                              : out std_logic_vector(31 downto 0);
         current_pc_ex                         : out std_logic_vector(31 downto 0);
         Jump_ex                               : out std_logic;
         Adder_Src_ex                          : out std_logic;
         Branch_ex                             : out std_logic
 
          );
end id_ex_reg;

 architecture Behavioral of id_ex_reg is

    signal rs1_reg          : std_logic_vector(31 downto 0) := (others => '0');
    signal rs2_reg          : std_logic_vector(31 downto 0) := (others => '0');
    signal imm_reg          : std_logic_vector(31 downto 0) := (others => '0');
    signal inst0_reg        : std_logic_vector(31 downto 0) := (others => '0');
    signal current_pc_reg   : std_logic_vector(31 downto 0) := (others => '0');
    signal rd_reg           : std_logic_vector(4 downto 0) := (others => '0');
    signal rs1_addr_reg     : std_logic_vector(4 downto 0) := (others => '0');
    signal rs2_addr_reg     : std_logic_vector(4 downto 0) := (others => '0');
    signal mem_to_reg_reg   : std_logic_vector(1 downto 0) := (others => '0');
    signal ALU_Op_reg       : std_logic_vector(1 downto 0) := (others => '0');
    signal funct3_reg       : std_logic_vector(2 downto 0) := (others => '0');
    signal funct7_reg       : std_logic_vector(6 downto 0) := (others => '0');
    signal ALU_Src_reg      : std_logic := '0';
    signal ALU_Src2_reg     : std_logic := '0';
    signal reg_Write_reg    : std_logic := '0';
    signal mem_read_reg     : std_logic := '0';
    signal mem_write_reg    : std_logic := '0';
    signal Jump_reg         : std_logic := '0';
    signal Branch_reg       : std_logic := '0';
    signal Adder_Src_reg    : std_logic := '0';

begin
WRITE_PROCESS: process(clk) begin
        if rising_edge(clk) then
            if reset = '1' or flush = '1' then
                rs1_reg        <= (others => '0');
                rs2_reg        <= (others => '0');
                imm_reg        <= (others => '0');
                rd_reg         <= (others => '0');
                rs1_addr_reg   <= (others => '0');
                rs2_addr_reg   <= (others => '0');
                mem_to_reg_reg <= (others => '0');
                ALU_Op_reg     <= (others => '0');
                funct3_reg     <= (others => '0');
                funct7_reg     <= (others => '0');
                inst0_reg      <= (others => '0');
                current_pc_reg <= (others => '0');
                ALU_Src_reg    <= '0';
                ALU_Src2_reg   <= '0';
                reg_write_reg  <= '0';
                mem_read_reg   <= '0';
                mem_write_reg  <= '0';
                Jump_reg       <= '0';
                Branch_reg     <= '0';
                Adder_Src_reg  <= '0';
                               
                
            else
                rs1_reg        <= rs1;
                rs2_reg        <= rs2;
                imm_reg        <= imm;
                rd_reg         <= rd;
                rs1_addr_reg   <= rs1_addr;
                rs2_addr_reg   <= rs2_addr;
                mem_to_reg_reg <= mem_to_reg;
                ALU_Op_reg     <= ALU_Op;
                funct3_reg     <= funct3;
                funct7_reg     <= funct7;
                ALU_Src_reg    <= ALU_Src;
                ALU_Src2_reg   <= ALU_Src2;
                reg_write_reg  <= reg_write;
                mem_read_reg   <= mem_read;
                mem_write_reg  <= mem_write;
                inst0_reg      <= inst0;
                current_pc_reg <= current_pc;
                Jump_reg       <= Jump;
                Branch_reg     <= Branch;
                Adder_Src_reg  <= Adder_Src;
            end if;
        end if;
    end process;
    rs1_ex        <= rs1_reg;
    rs2_ex        <= rs2_reg;
    imm_ex        <= imm_reg;
    rd_ex         <= rd_reg;
    rs1a_ex       <= rs1_addr_reg;
    rs2aex        <= rs2_addr_reg;
    mem_to_reg_ex <= mem_to_reg_reg;
    ALU_Op_ex     <= ALU_Op_reg;
    funct3_ex     <= funct3_reg;
    funct7_ex     <= funct7_reg;
    ALU_Src_ex    <= ALU_Src_reg;
    ALU_Src2_ex   <= ALU_Src2_reg;
    reg_write_ex  <= reg_write_reg;
    mem_read_ex   <= mem_read_reg;
    mem_write_ex  <= mem_write_reg;
    inst0_ex      <= inst0_reg;
    current_pc_ex <= current_pc_reg;
    Jump_ex       <= Jump_reg;
    Branch_ex     <= Branch_reg;
    Adder_Src_ex  <= Adder_Src_reg;

end Behavioral;
