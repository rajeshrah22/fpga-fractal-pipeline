library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

library vga;
use vga.vga_data.all;

entity write_file_example is
	generic (
		clock_period: time := 10 ps
	);
end entity write_file_example;

architecture demo of write_file_example is
	-- TODO: make this match your own toplevel
	component fractal_generator is
		generic (
			stages: positive := 16;
			vga_res: vga_data := vga_res_default
		);
		port (
			reset:	in	std_logic;
			clock:	in	std_logic;
			f_select:	in	std_logic;
			h_sync:	out	std_logic;
			v_sync:	out	std_logic;
			color:	out	vga_color
		);
	end component fractal_generator;

	-- TODO: fix if necessary
	constant h_res: positive :=
			vga_res_default.horizontal.active
		+	vga_res_default.horizontal.front_porch
		+	vga_res_default.horizontal.sync_width
		+	vga_res_default.horizontal.back_porch;
	constant v_res: positive :=
			vga_res_default.vertical.active
		+	vga_res_default.vertical.front_porch
		+	vga_res_default.vertical.sync_width
		+	vga_res_default.vertical.back_porch;

	signal clock: std_logic := '0';
	signal reset: std_logic := '0';
	signal f_select: std_logic := '0';

	signal h_sync, v_sync: std_logic;
	signal color: vga_color;

	signal test_done: boolean := false;
begin

	clock <= not clock after clock_period / 2 when not test_done else '0';

	-- TODO: fix if necessary
	dut: fractal_generator
		generic map (
			stages =>	16,
			vga_res => vga_res_default
		)
		port map (
			reset =>	reset,
			clock =>	clock,
			f_select => '1',
			h_sync =>	h_sync,
			v_sync =>	v_sync,
			color =>	color
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
		wait for rising_edge(clock);
		wait for rising_edge(clock);
		reset <= '1';

		for i in 0 to 15 loop
			wait for rising_edge(clock);
		end loop;

		-- TODO: check; this _should_ work
		for j in 0 to v_res - 1 loop
			for i in 0 to h_res - 1 loop
				r := color.red;
				g := color.green;
				b := color.blue;

				write(out_line,
						integer'image(r) & " " &
						integer'image(g) & " " &
						integer'image(b) );
				writeline(out_file, out_line);

				wait for rising_edge(clock);
			end loop;
		end loop;

		test_done <= true;
		wait;
	end process write_file;

end architecture demo;
