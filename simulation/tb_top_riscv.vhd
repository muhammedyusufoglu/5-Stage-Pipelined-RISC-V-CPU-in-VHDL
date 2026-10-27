library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_top_risc_v is
end entity;

architecture sim of tb_top_risc_v is

    constant CLK_PERIOD : time := 10 ns;
    constant MAX_CYCLES : positive := 5000;

    signal clk        : std_logic := '0';
    signal reset      : std_logic := '1';
    signal ALU_Result : std_logic_vector(31 downto 0);
    signal PC_out     : std_logic_vector(31 downto 0);

begin

    -- DUT: Pipelined RV32I processor
    DUT : entity work.top_risc_v
        port map (
            clk        => clk,
            reset      => reset,
            ALU_Result => ALU_Result,
            PC_out     => PC_out
        );

    -- Clock generation
    clk <= not clk after CLK_PERIOD / 2;

    -- Reset sequence
    reset_process : process
    begin
        reset <= '1';
        wait for 5 * CLK_PERIOD;

        wait until falling_edge(clk);
        reset <= '0';

        wait;
    end process;

    -- Simulation and trace logging
    stimulus_process : process
        file trace_file : text open write_mode
            is "trace.csv";

        variable L     : line;
        variable cycle : natural := 0;
    begin
        -- Wait until reset is released
        wait until reset = '0';

        -- Allow pipeline signals to settle
        wait for CLK_PERIOD;

        write(L, string'("Cycle,PC_out,ALU_Result"));
        writeline(trace_file, L);

        for i in 0 to MAX_CYCLES - 1 loop

            wait until rising_edge(clk);
            wait for 1 ns;

            cycle := i + 1;

            -- Write PC and ALU result in hexadecimal
            write(L, cycle);
            write(L, string'(","));
            hwrite(L, PC_out);
            write(L, string'(","));
            hwrite(L, ALU_Result);

            writeline(trace_file, L);

            -- Basic unknown-value detection
            assert not is_x(PC_out)
                report "ERROR: PC_out contains unknown values"
                severity warning;

            assert not is_x(ALU_Result)
                report "WARNING: ALU_Result contains unknown values"
                severity warning;

        end loop;

        file_close(trace_file);

        report "Simulation finished. Trace written to trace.csv"
            severity note;

        wait;
    end process;

end architecture;
