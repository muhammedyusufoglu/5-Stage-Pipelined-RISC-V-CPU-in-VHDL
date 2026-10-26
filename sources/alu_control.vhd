    ----------------------------------------------------------------------------------
    -- Company: 
    -- Engineer: 
    -- 
    -- Create Date: 25.05.2026 13:52:02
    -- Design Name: 
    -- Module Name: alu_control - Behavioral
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
    
    
    entity alu_control is
        Port ( 
              ALU_Op:   in  std_logic_vector(1 downto 0);
              funct3:   in  std_logic_vector(2 downto 0);
              funct7:   in  std_logic_vector(6 downto 0);
              ALU_code: out std_logic_vector(3 downto 0)
        );
    end alu_control;
    
    architecture Behavioral of alu_control is
    
    begin
        process(ALU_Op, funct3, funct7) begin
            if ALU_Op = "00" then    -- L-Type, S-Type, AUIPC, JAL, Jalr
                ALU_code <= "1000";
            
            elsif ALU_Op = "01" then -- Branch
                ALU_code <= "0001";
            
            elsif ALU_Op = "10" then    -- R-Type
                case funct3 is
                    when "000" =>
                        if funct7(5) = '1' then
                           ALU_code <= "1001"; -- Sub
                        else 
                            ALU_code <= "1000"; -- Add
                        end if;
                        
                     when "001" => ALU_code <= "1010"; -- SLL
                     when "010" => ALU_code <= "1011"; -- SLT
                     when "011" => ALU_code <= "1100"; -- SLTU
                     when "100" => ALU_code <= "1101"; -- XOR
                     when "110" => ALU_code <= "0100" ;-- OR
                     when "111" => ALU_code <= "0110" ;-- AND
                     when "101" => 
                        if funct7(5) = '1' then
                            ALU_code <= "1111";        -- SRA
                        else
                            ALU_code <= "1110";        -- SRL
                        end if;
                     when others => ALU_code <= "0000";
                 end case; 
            else                                        -- I-Type
                case funct3 is
                    when "000" => ALU_code <= "1000"; -- ADDI
                    when "010" => ALU_code <= "1011"; -- SLTI
                    when "011" => ALU_code <= "1100"; -- SLTIU
                    when "100" => ALU_code <= "1101"; -- XORI             
                    when "110" => ALU_code <= "0100"; -- ORI
                    when "111" => ALU_code <= "0110"; -- ANDI
                    when "001" => ALU_code <= "1010"; -- SLLI
                    when "101" => 
                        if funct7(5) = '1' then
                            ALU_code <= "1111";       -- SRAI
                        else
                            ALU_code <= "1110";       -- SRLI
                        end if;
                    when others => ALU_code <= "0000";
                end case;
            end if;
                         
    
        end process;
    end Behavioral;
