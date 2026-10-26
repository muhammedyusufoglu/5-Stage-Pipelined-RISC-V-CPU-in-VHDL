    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 22.07.2026 12:19:49
    -- Design Name: 
    -- Module Name: control_unit - Behavioral
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
    
    entity control_unit is
      Port (
            opcode                          : in std_logic_vector(6 downto 0);
            -------------------------------------------------------------------
            mem_to_reg                      : out std_logic_vector(1 downto 0);
            mem_write, mem_read, reg_write  : out std_logic;
            ALU_Op                          : out std_logic_vector(1 downto 0);
            ALU_Src, ALU_Src2, Jump, Branch : out std_logic;
            Adder_Src                       : out std_logic
             );
    end control_unit;
    
    architecture Behavioral of control_unit is
    
    --signal mem_write_s    : std_logic := '0';
    --signal mem_read_s     : std_logic := '0';
    --signal reg_write_s    : std_logic := '0';
    --signal ALU_Src_s      : std_logic := '0';
    --signal ALU_Src2_s     : std_logic := '0';
    --signal Jump_s         : std_logic := '0';
    --signal Branch_s       : std_logic := '0';
    --signal Adder_Src_s    : std_logic := '0';
    
    -- ALU_Src = 0 ===> MuxB
    -- ALU_Src = 1 ===> imm
    -- ALU_Src2 = 0 ===> MuxA
    -- ALU_Src2 = 1 ===> PC
    
    -- Adder_Src = 0 ===> rs1
    -- Adder_Src = 1 ===> PC
    
    begin
        process(all) begin
            Case opcode is
                when "0110011" =>       -- R-Type
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '0';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "00";
                    ALU_Op    <= "10";
                when "0010011" =>       -- I-Type
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '1';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "00";
                    ALU_Op    <= "11";
                when "0000011" =>       -- L- Type
                    mem_write <= '0';
                    mem_read  <= '1';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '1';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "01";
                    ALU_Op    <= "00";
                when "0100011" =>       -- S-Type
                    mem_write <= '1';
                    mem_read  <= '0';
                    reg_write <= '0';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '1';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "00";
                    ALU_Op    <= "00";
                when "1100011" =>       -- B-Type
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '0';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '0';
                    Jump      <= '0';
                    Branch    <= '1';
                    Adder_Src <= '1';
                    mem_to_reg<= "00";
                    ALU_Op    <= "01";
                when "1101111" =>       -- JAL
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '0';
                    Jump      <= '1';
                    Branch    <= '0';
                    Adder_Src <= '1';
                    mem_to_reg<= "10";
                    ALU_Op    <= "00";
                when "1100111" =>       -- JALR
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '0';
                    Jump      <= '1';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "10";
                    ALU_Op    <= "00";
                when "0010111" =>       -- AUIPC
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '1';
                    ALU_Src2  <= '1';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '0';
                    mem_to_reg<= "00";
                    ALU_Op    <= "00";
                when "0110111" =>       -- LUI
                    mem_write <= '0';
                    mem_read  <= '0';
                    reg_write <= '1';
                    ALU_Src   <= '0';
                    ALU_Src2  <= '0';
                    Jump      <= '0';
                    Branch    <= '0';
                    Adder_Src <= '1';
                    mem_to_reg<= "11";
                    ALU_Op    <= "00";
                 when others =>
                    mem_write <= '0'; 
                    mem_read  <= '0'; 
                    reg_write <= '0'; 
                    ALU_Src   <= '0'; 
                    ALU_Src2  <= '0'; 
                    Jump      <= '0'; 
                    Branch    <= '0'; 
                    Adder_Src <= '0'; 
                    mem_to_reg<= "00";
                    ALU_Op    <= "00";             
            end Case;
        end process;
    end Behavioral;
    
    
