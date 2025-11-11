-- bring in the necessary libraries and packages
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library vga;
use vga.vga_data.all;

library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed.all;

use work.pipeline_pkg.all;
use work.color_data.all;

entity fractal_testbench is
    generic (
        clock_period: time := 10 ps
    );
end entity fractal_testbench;

architecture demo of fractal_testbench is
    constant h_res: positive :=
        vga_res_default.horizontal.active +
        vga_res_default.horizontal.front_porch +
        vga_res_default.horizontal.sync_width +
        vga_res_default.horizontal.back_porch;

    constant v_res: positive :=
        vga_res_default.vertical.active +
        vga_res_default.vertical.front_porch +
        vga_res_default.vertical.sync_width +
        vga_res_default.vertical.back_porch;

    signal clock: std_logic := '0';
    signal reset: std_logic := '0';
    signal fractal_select: std_logic := '0';

    signal h_sync, v_sync: std_logic;
    signal vga_color: rgb_color;

    signal test_done: boolean := false;

begin

    clock <= not clock after clock_period / 2 when not test_done else '0';

    dut: entity work.test_toplevel
        generic map (
            stage_count => 16
        )
        port map (
            vga_clock => clock,
            reset => reset,
            f_select => '0',
            h_sync => h_sync,
            v_sync => v_sync,
            vga_color => vga_color
        );

    write_file: process is
        file out_file: text open write_mode is "my_generated_file.ppm";
        variable out_line: line;
        variable r, g, b: natural range 0 to 15;
    begin
        write(out_file, "P3" & lf);
        write(out_file, integer'image(h_res) & " " &
                        integer'image(v_res) & lf);
        write(out_file, "15" & lf);

        reset <= '0';
        wait until rising_edge(clock);
        wait until rising_edge(clock);
        reset <= '1';

        for i in 0 to 34 loop
            wait until rising_edge(clock);
        end loop;

        for j in 0 to v_res - 1 loop
            for i in 0 to h_res - 1 loop
                r := vga_color.red;
                g := vga_color.green;
                b := vga_color.blue;

                write(out_line,
                        integer'image(r) & " " &
                        integer'image(g) & " " &
                        integer'image(b));
                writeline(out_file, out_line);

                wait until rising_edge(clock);
            end loop;
        end loop;

        test_done <= true;
        wait;
    end process write_file;

end architecture demo;
