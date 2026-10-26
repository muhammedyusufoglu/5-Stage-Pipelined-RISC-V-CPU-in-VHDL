library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port ( 
        clk, mem_read, mem_write : in  std_logic;
        funct3                   : in  std_logic_vector(2 downto 0);   -- erişim boyutu (LB/LH/LW/LBU/LHU, SB/SH/SW)
        address                  : in  std_logic_vector(31 downto 0);
        data_in                  : in  std_logic_vector(31 downto 0);
        data_out                 : out std_logic_vector(31 downto 0)
    );
end data_memory;

architecture Behavioral of data_memory is
    type mem is array (0 to 4095) of std_logic_vector(31 downto 0);
    signal memory: mem := (others => (others => '0'));

    signal idx  : integer range 0 to 4095;
    signal word : std_logic_vector(31 downto 0);   -- adresteki tam kelime
    signal byte : std_logic_vector(7 downto 0);    -- seçilen byte
    signal half : std_logic_vector(15 downto 0);   -- seçilen halfword
begin

    idx  <= to_integer(unsigned(address(13 downto 2)));
    word <= memory(idx);

    -- Yazma işlemi (Senkron): SB / SH / SW
    process(clk) begin
        if rising_edge(clk) then
            if mem_write = '1' then
                case funct3 is
                    when "000" =>                                         -- SB
                        case address(1 downto 0) is
                            when "00"   => memory(idx)(7  downto 0)  <= data_in(7 downto 0);
                            when "01"   => memory(idx)(15 downto 8)  <= data_in(7 downto 0);
                            when "10"   => memory(idx)(23 downto 16) <= data_in(7 downto 0);
                            when others => memory(idx)(31 downto 24) <= data_in(7 downto 0);
                        end case;
                    when "001" =>                                         -- SH
                        if address(1) = '0' then
                            memory(idx)(15 downto 0)  <= data_in(15 downto 0);
                        else
                            memory(idx)(31 downto 16) <= data_in(15 downto 0);
                        end if;
                    when others =>                                        -- SW
                        memory(idx) <= data_in;
                end case;
            end if;
        end if;
    end process;

    -- Okuma işlemi (Asenkron): kelimeden byte/halfword seç
    with address(1 downto 0) select
        byte <= word(7  downto 0)  when "00",
                word(15 downto 8)  when "01",
                word(23 downto 16) when "10",
                word(31 downto 24) when others;

    half <= word(15 downto 0) when address(1) = '0' else word(31 downto 16);

    process(all) begin
        if mem_read = '0' then
            data_out <= (others => '0');
        else
            case funct3 is
                when "000"  => data_out <= (31 downto 8  => byte(7))  & byte;  -- LB  (işaret genişletmeli)
                when "001"  => data_out <= (31 downto 16 => half(15)) & half;  -- LH  (işaret genişletmeli)
                when "100"  => data_out <= x"000000" & byte;                   -- LBU (sıfır genişletmeli)
                when "101"  => data_out <= x"0000" & half;                     -- LHU (sıfır genişletmeli)
                when others => data_out <= word;                               -- LW
            end case;
        end if;
    end process;

end Behavioral;
