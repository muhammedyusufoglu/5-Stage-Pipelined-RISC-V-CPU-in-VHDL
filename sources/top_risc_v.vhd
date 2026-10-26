----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2026 14:13:15
-- Design Name: 
-- Module Name: top_risc_v - Behavioral
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

entity top_risc_v is
  Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        ------------------------------------------------
        ALU_Result  : out std_logic_vector(31 downto 0);
        PC_out      : out std_logic_vector(31 downto 0)
   );
end top_risc_v;

architecture Behavioral of top_risc_v is

    signal current_inst_signal     : std_logic_vector(31 downto 0);  -- Output of Instruction Memory
    signal current_inst_signal_2   : std_logic_vector(31 downto 0);  -- Output of Instruction Memory in ID, will be decoded.
    signal current_pc_signal       : std_logic_vector(31 downto 0);  -- Output of Program Counter
    signal current_pc_signal_2     : std_logic_vector(31 downto 0);  -- Output of Program Counter in ID
    signal current_pc_signal_3     : std_logic_vector(31 downto 0);  -- Output of Program Counter in EX
    signal pc_mux_signal           : std_logic_vector(31 downto 0);  -- Output of PC_Mux
    signal new_target_signal       : std_logic_vector(31 downto 0);  -- Output of Target Adder
    signal stall_signal            : std_logic;                      -- Stall
    signal Adder_Src_signal        : std_logic;                      -- Control Unit to Control Signals
    signal Adder_Src_signal_and    : std_logic;                      -- Control Signals to ID/EX
    signal Adder_Src_signal_2      : std_logic;                      -- Control Signals to ID/EX
    signal inst0_signal            : std_logic_vector(31 downto 0);  -- PC+4
    signal inst0_signal_2          : std_logic_vector(31 downto 0);  -- PC+4 in ID
    signal inst0_signal_3          : std_logic_vector(31 downto 0);  -- PC+4 in EX
    signal inst0_signal_4          : std_logic_vector(31 downto 0);  -- PC+4 in MEM
    signal inst0_signal_5          : std_logic_vector(31 downto 0);  -- PC+4 in WB
    signal pc_adder_signal         : std_logic_vector(31 downto 0);
--------------------  CONTROL SIGNALS  -----------------------------------------------------------------
    signal ALU_Op                  : std_logic_vector(1 downto 0);  -- ALU_Op
    signal ALU_Op_and             : std_logic_vector(1 downto 0);  -- ALU_Op with stall
    signal ALU_Op_2                : std_logic_vector(1 downto 0);  -- ALU_Op in EX
    signal mem_to_reg              : std_logic_vector(1 downto 0);  -- mem_to_reg
    signal mem_to_reg_2            : std_logic_vector(1 downto 0);  -- mem_to_reg in EX
    signal mem_to_reg_3            : std_logic_vector(1 downto 0);  -- mem_to_reg in MEM
    signal mem_to_reg_4            : std_logic_vector(1 downto 0);  -- mem_to_reg in WB
    signal mem_to_reg_and          : std_logic_vector(1 downto 0);  -- mem_to_reg in WB
    signal jump_signal             : std_logic;                      -- Jump
    signal jump_signal_and         : std_logic;                      -- Jump
    signal jump_signal_2           : std_logic;                      -- Jump
    signal Branch_signal           : std_logic;                      -- Branch
    signal Branch_signal_and       : std_logic;                      -- Branch
    signal Branch_signal_2         : std_logic;                      -- Branch
    signal ALU_Src_signal          : std_logic;                      -- ALU_Src
    signal ALU_Src_signal_2        : std_logic;                      -- ALU_Src in EX
    signal ALU_Src_signal_and        : std_logic;                      -- ALU_Src with stall
    signal ALU_Src2_signal         : std_logic;                      -- ALU_Src2
    signal ALU_Src2_signal_2       : std_logic;                      -- ALU_Src2 in EX
    signal ALU_Src2_signal_and       : std_logic;                      -- ALU_Src2 with stall
    signal Mem_Read_signal         : std_logic;                      -- Mem_Read
    signal Mem_Read_signal_2       : std_logic;                      -- Mem_Read in EX
    signal Mem_Read_signal_3       : std_logic;                      -- Mem_Read in MEM
    signal Mem_Read_signal_and      : std_logic;                      -- Mem_Read with stall
    signal Mem_Write_signal        : std_logic;                      -- Mem_Write
    signal Mem_Write_signal_2      : std_logic;                      -- Mem_Write in EX
    signal Mem_Write_signal_3      : std_logic;                      -- Mem_Write in MEM
    signal Mem_Write_signal_and     : std_logic;                      -- Mem_Write with stall
    signal Reg_Write_signal        : std_logic;                      -- Reg_Write
    signal Reg_Write_signal_2      : std_logic;                      -- Reg_Write in EX
    signal Reg_Write_signal_3      : std_logic;                      -- Reg_Write in MEM
    signal Reg_Write_signal_4      : std_logic;                      -- Reg_Write in WB
    signal Reg_Write_signal_and      : std_logic;                      -- Reg_Write in with stall
    --------------------  CONTROL SIGNALS  ----------------------------------------------------------------- 
    --------------------------------------------------------------------------------------------------------
    signal Branch_taken_signal     : std_logic;                      -- Output of Comparator
    signal rs1_signal              : std_logic_vector(31 downto 0);  -- Output of Register File
    signal rs2_signal              : std_logic_vector(31 downto 0);  -- Output of Register File
    signal rs1_signal_2            : std_logic_vector(31 downto 0);  -- Output of Register File in EX
    signal rs2_signal_2            : std_logic_vector(31 downto 0);  -- Output of Register File in EX
--    signal rs2_signal_3            : std_logic_vector(31 downto 0);  -- Output rs2 of Register File in MEM  
    signal imm_signal              : std_logic_vector(31 downto 0);  -- Output of ImmGen
    signal imm_signal_2            : std_logic_vector(31 downto 0);  -- Output of ImmGen in EX
    signal imm_signal_3            : std_logic_vector(31 downto 0);  -- Output of ImmGen IN MEM
    signal imm_signal_4            : std_logic_vector(31 downto 0);  -- Output of ImmGen IN WB
    signal for_a_signal            : std_logic_vector(1 downto 0);   -- Output of Forwarding Unit
    signal for_b_signal            : std_logic_vector(1 downto 0);   -- Output of Forwarding Unit
    --------------------------------------------------------------------------------------------------------
    --------------------- MUX SİGNALS ----------------------------------------------------------------------
    signal muxA_signal              : std_logic_vector(31 downto 0);  -- Output of MUX A
    signal MuxB_signal              : std_logic_vector(31 downto 0);  -- Output of MUX B in EX
    signal MuxB_signal_2            : std_logic_vector(31 downto 0);  -- Output of MUX B in MEM
    signal operand1_signal          : std_logic_vector(31 downto 0);  -- Output of Operand_mux
    signal operand2_signal          : std_logic_vector(31 downto 0);  -- Output of Operand_mux
    --------------------- MUX SİGNALS ----------------------------------------------------------------------
    --------------------------------------------------------------------------------------------------------
    signal ALU_Result_signal        : std_logic_vector(31 downto 0);  -- Output of ALU
    signal ALU_Result_signal_2      : std_logic_vector(31 downto 0);  -- Output of ALU in MEM
    signal ALU_Result_signal_3      : std_logic_vector(31 downto 0);  -- Output of ALU in WB
    signal ALU_control_signal       : std_logic_vector(3 downto 0);  -- Output of ALU_Control
    signal read_data_signal         : std_logic_vector(31 downto 0);  -- Output of Memory
    signal read_data_signal_2       : std_logic_vector(31 downto 0);  -- Output of Memory in WB
    signal write_register_signal    : std_logic_vector(31 downto 0);  -- Output of WB_Mux   
    signal flush_signal             : std_logic; -- will be defined as Branch_Taken OR Jump
    signal mem_fwd_signal           : std_logic_vector(31 downto 0);  -- MEM'den forward edilecek doğru sonuç (ALU / imm / PC+4)
    ---------------------------------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------------------------------
    signal opcode_signal            : std_logic_vector(6 downto 0);  -- Created from Instruction
    signal opcode_signal_2          : std_logic_vector(6 downto 0);  -- Created from Instruction
    signal rd_signal                : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rd_signal_2              : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rd_signal_3              : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rd_signal_4              : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal funct3_signal            : std_logic_vector(2 downto 0);  -- Created from Instruction
    signal funct3_signal_2          : std_logic_vector(2 downto 0);  -- Created from Instruction
    signal funct3_signal_3          : std_logic_vector(2 downto 0);  -- funct3 in MEM (data memory erişim boyutu)
    signal rs1_a_signal             : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rs1_a_signal_2           : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rs2_a_signal             : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal rs2_a_signal_2           : std_logic_vector(4 downto 0);  -- Created from Instruction
    signal funct7_signal            : std_logic_vector(6 downto 0);  -- Created from Instruction
    signal funct7_signal_2          : std_logic_vector(6 downto 0);  -- Created from Instruction
    ---------------------------------------------------------------------------------------------------------
    signal clk_signal               : std_logic;
    signal reset_signal             : std_logic;
    signal ALU_code                 : std_logic_vector(3 downto 0);
   
begin
-------------- Instruction Bit Slicing ----------------------------------------------------------------------
    opcode_signal <= current_inst_signal_2(6 downto 0);   -- ID
    rd_signal     <= current_inst_signal_2(11 downto 7);  -- ID
    funct3_signal <= current_inst_signal_2(14 downto 12); -- ID
    rs1_a_signal  <= current_inst_signal_2(19 downto 15); -- ID
    rs2_a_signal  <= current_inst_signal_2(24 downto 20); -- ID
    funct7_signal <= current_inst_signal_2(31 downto 25); -- ID    
-------------- Instruction Bit Slicing ----------------------------------------------------------------------
    
    clk_signal   <= clk;
    reset_signal <= reset;

alu_inst: entity work.alu
    port map(
       operand_1   => operand1_signal,
       operand_2   => operand2_signal,
       Alu_control => ALU_control_signal,
       ALU_Result  => ALU_Result_signal 
    );
alu_control_inst: entity work.alu_control
    port map(
       ALU_Op      => ALU_Op_2,
       funct3      => funct3_signal_2,
       funct7      => funct7_signal_2,
       ALU_code    => ALU_control_signal
    );
comparator_inst: entity work.comparator
    port map(
        rs1     => muxA_signal,
        rs2     => muxB_signal,
        funct3  => funct3_signal_2,
        taken   => Branch_taken_signal
-- will be taken care later


    );
control_Signals_inst: entity work.control_signals
    port map(
        stall           => stall_signal,          
        mem_write       => Mem_Write_signal,
        mem_read        => Mem_Read_signal,
        reg_write       => Reg_Write_signal,
        ALU_Src         => ALU_Src_signal,
        ALU_Src2        => ALU_Src2_signal,
        mem_to_reg      => mem_to_reg,
        ALU_Op          => ALU_Op,
        mem_write_and   => Mem_Write_signal_and,
        mem_read_and    => Mem_Read_signal_and,
        reg_write_and   => Reg_Write_signal_and,
        ALU_Src_and     => ALU_Src_signal_and,
        ALU_Src2_and    => ALU_Src2_signal_and,
        mem_to_reg_and  => mem_to_reg_and,
        ALU_Op_and      => ALU_Op_and,  
        Jump            => Jump_signal,
        Branch          => Branch_Signal,
        Adder_Src       => Adder_Src_signal,
        Adder_Src_and   => Adder_Src_signal_and,
        Jump_and        => Jump_signal_and, 
        Branch_and      => Branch_Signal_and
        
        
                    

    );
control_unit_inst: entity work.control_unit
    port map(
        opcode          => opcode_signal,
        
        mem_to_reg      => mem_to_reg,
        mem_write       => Mem_Write_signal,
        mem_read        => Mem_Read_signal,
        reg_write       => Reg_Write_signal,
        ALU_Op          => ALU_Op,
        ALU_Src         => ALU_Src_signal,
        ALU_Src2        => ALU_Src2_signal,
        Jump            => Jump_signal,
        Branch          => Branch_signal,
        Adder_Src       => Adder_Src_signal

    );
data_memory_inst: entity work.data_memory
    port map(
        clk             => clk_signal, 
--      reset           => reset_signal,
        mem_read        => Mem_Read_signal_3,
        mem_write       => Mem_Write_signal_3,
        funct3          => funct3_signal_3,
        address         => ALU_Result_signal_2,
        data_in         => muxB_signal_2,
        data_out        => read_data_signal

    );
ex_mem_reg_inst: entity work.ex_mem_reg
    port map(
        mem_write_ex    => Mem_Write_signal_2,
        mem_read_ex     => Mem_Read_signal_2,
        reg_write_ex    => Reg_Write_signal_2,
        mem_to_reg      => mem_to_reg_2, 
        clk             => clk_signal,
        reset           => reset_signal,
        rd              => rd_signal_2,
        ALU_Result      => ALU_Result_signal,
        rs2_for         => muxB_signal,
        imm             => imm_signal_2,
        inst0           => inst0_signal_3,
        funct3          => funct3_signal_2,
        --------------------------------------------
        mem_write_mem   => Mem_Write_signal_3,
        mem_read_mem    => Mem_Read_signal_3,
        reg_write_mem   => Reg_Write_signal_3,
        mem_to_reg_mem  => mem_to_reg_3,
        rd_mem          => rd_signal_3,
        ALU_Result_mem  => ALU_Result_signal_2,
        rs2_for_mem     => muxB_signal_2,
        imm_mem         => imm_signal_3,    
        inst0_mem       => inst0_signal_4,
        funct3_mem      => funct3_signal_3

    );
forwarding_mux_inst: entity work.forwarding_mux
    port map(
        rs1             => rs1_signal_2,
        rs2             => rs2_signal_2,
        write_data      => write_register_signal,
        ALU_Result      => mem_fwd_signal,
        for_a           => for_a_signal,
        for_b           => for_b_signal,
        mux_a           => muxA_signal,
        mux_b           => muxB_signal

    );
forwarding_unit_inst: entity work.forwarding_unit
    port map(
        rs1_adr         => rs1_a_signal_2,
        rs2_adr         => rs2_a_signal_2,
        rd_mem          => rd_signal_3,
        rd_wb           => rd_signal_4,
        reg_write_mem   => Reg_Write_signal_3,
        reg_write_wb    => Reg_Write_signal_4,
        for_a           => for_a_signal,
        for_b           => for_b_signal

    );
hazard_detection_unit_inst: entity work.hazard_detection_unit
    port map(
        rs1             => rs1_a_signal,
        rs2             => rs2_a_signal,
        rd_ex           => rd_signal_2,
        mem_read_ex     => Mem_Read_signal_2,
        stall           => stall_signal

    );
id_ex_reg_inst: entity work.id_ex_reg
    port map(
        rs1             => rs1_signal,
        rs2             => rs2_signal,
        imm             => imm_signal,
        rd              => rd_signal,
        rs1_addr        => rs1_a_signal,             
        rs2_addr        => rs2_a_signal,             
        ALU_Src         => ALU_Src_signal_and,
        ALU_Src2        => ALU_Src2_signal_and,
        reg_Write       => Reg_Write_signal_and,
        mem_read        => Mem_Read_signal_and,
        mem_Write       => Mem_Write_signal_and,
        mem_to_reg      => mem_to_reg_and,
        ALU_Op          => ALU_Op_and,
        funct3          => funct3_signal,
        funct7          => funct7_signal,
        clk             => clk_signal,
        reset           => reset_signal,
        inst0           => inst0_signal_2,
        current_pc      => current_pc_signal_2,
        Jump            => Jump_signal_and,
        Adder_Src       => Adder_Src_signal_and,
        Branch          => Branch_signal_and,
        flush           => flush_signal,
        ---------------------------------------
        rs1_ex          => rs1_signal_2,
        rs2_ex          => rs2_signal_2,
        imm_ex          => imm_signal_2,
        rd_ex           => rd_signal_2,
        rs1a_ex         => rs1_a_signal_2,
        rs2aex          => rs2_a_signal_2,
        ALU_Src_ex      => ALU_Src_signal_2,
        ALU_Src2_ex     => ALU_Src2_signal_2,
        reg_Write_ex    => Reg_Write_signal_2,
        mem_read_ex     => Mem_Read_signal_2,
        mem_Write_ex    => Mem_Write_signal_2,
        mem_to_reg_ex   => mem_to_reg_2,
        ALU_Op_ex       => ALU_Op_2,
        funct3_ex       => funct3_signal_2,
        funct7_ex       => funct7_signal_2,
        inst0_ex        => inst0_signal_3,
        current_pc_ex   => current_pc_signal_3,
        Jump_ex         => Jump_signal_2,
        Adder_Src_ex    => Adder_Src_signal_2,
        Branch_ex       => Branch_signal_2        
    );
if_id_reg_inst: entity work.if_id_reg
    port map(
        current_inst    => current_inst_signal,
        inst0           => inst0_signal,
        current_pc      => current_pc_signal,
        stall           => stall_signal,
        clk             => clk_signal,
        reset           => reset_signal,
        flush           => flush_signal,
        current_pc_out  => current_pc_signal_2,
        inst0_out       => inst0_signal_2,
        current_inst_out=> current_inst_signal_2
    );
mem_wb_reg_inst: entity work.mem_wb_reg
    port map(
        ALU_Result      => ALU_Result_signal_2,
        read_data       => read_data_signal,
        imm             => imm_signal_3,
        inst0           => inst0_signal_4,
        rd              => rd_signal_3,
        mem_to_reg      => mem_to_reg_3,
        reg_write       => Reg_Write_signal_3,
        clk             => clk_signal,
        reset           => reset_signal,
        ALU_Res         => ALU_Result_signal_3,
        read_Data_wb    => read_data_signal_2,
        imm_wb          => imm_signal_4,
        inst0_wb        => inst0_signal_5,
        rd_wb           => rd_signal_4,
        mem_to_reg_wb   => mem_to_reg_4,
        reg_write_wb    => Reg_Write_signal_4     
       
    );
imm_gen_inst: entity work.imm_gen
    port map(
        instruction     => current_inst_signal_2,
        immediate       => imm_signal
       
    );
inst_mem_inst: entity work.inst_mem
    port map(
--     reset            => reset_signal,
       current_inst     => current_pc_signal,
       next_inst        => current_inst_signal
          
    );
operand_mux_inst: entity work.operand_mux
    port map(
       imm              => imm_signal_2,
       PC               => current_pc_signal_3,
       mux_a            => muxA_signal,
       mux_b            => muxB_signal,
       ALU_Src1         => ALU_Src_signal_2,
       ALU_Src2         => ALU_Src2_signal_2,
       operand_1        => operand1_signal,
       operand_2        => operand2_signal
       
    );
pc_adder_inst: entity work.pc_adder
    port map(
        current_pc      => current_pc_signal,
        next_pc         => inst0_signal
        
    );
pc_mux_inst: entity work.pc_mux
    port map(
       pc               => inst0_signal,
       new_target       => new_target_signal,
       jump             => jump_signal_2,
       branch           => branch_signal_2,
       branch_taken     => Branch_taken_signal,
       next_pc          => pc_mux_signal,
       flush            => flush_signal       
       
    );
program_counter_inst: entity work.program_counter
    port map(
        clk             => clk_signal,
        reset           => reset_signal,
        stall           => stall_signal,
        next_inst       => pc_mux_signal,
        current_inst    => current_pc_signal 
       
    );
register_file_inst: entity work.register_file
    port map(
       clk              => clk_signal,
       reset            => reset_Signal,
       reg_write        => Reg_Write_signal_4,
       rs1              => rs1_signal,
       rs2              => rs2_signal,
       rs1_addr         => rs1_a_signal,
       rs2_addr         => rs2_a_signal,
       rd_addr          => rd_signal_4,
       write            => write_register_signal
       
    );
target_adder_inst: entity work.target_adder
    port map(
       imm              => imm_signal_2,
       pc               => current_pc_signal_3,
       rs1              => muxA_signal,
       Adder_Src        => Adder_Src_signal_2,
       new_target       => new_target_signal
       
    );
wb_mux_inst: entity work.wb_mux
    port map(
       mem_to_Reg       => mem_to_reg_4,
       ALU_Result       => ALU_Result_signal_3,
       read_Data        => read_data_signal_2,
       inst0            => inst0_signal_5,
       imm              => imm_signal_4,
       wb_out           => write_register_signal
    
    );
    
-- MEM aşamasından forward edilecek değer: wb_mux ile aynı seçim
with mem_to_reg_3 select
    mem_fwd_signal <= inst0_signal_4      when "10",    -- JAL/JALR: PC+4
                      imm_signal_3        when "11",    -- LUI: imm
                      ALU_Result_signal_2 when others;  -- R, I, AUIPC

ALU_Result <= ALU_Result_signal_3;  
PC_out     <= current_pc_signal;
  
end Behavioral;
