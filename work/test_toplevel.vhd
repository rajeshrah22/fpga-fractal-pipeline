library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed.all;

library vga;
use vga.vga_data.all;

use work.color_data.all;

entity test_toplevel is
	generic (
		stage_count: natural := 16
	);
	port (
		vga_clock: in std_logic;
		-- clock: in std_logic;
		reset: in std_logic;
		f_select: in std_logic;
		h_sync: out std_logic;
		v_sync: out std_logic;
		vga_color: out rgb_color
	);
end entity test_toplevel;

architecture toplevel of test_toplevel is
	signal coordinate_out: coordinate;
	signal point_valid: boolean;
	-- signal vga_clock: std_logic;
	signal complex_coordinate: ads_complex;

	type pipeline_data_array_t is array (natural range <>) of pipeline_data;
	signal pipeline: pipeline_data_array_t(0 to stage_count - 1);
	
	signal seed_z, seed_c: ads_complex;
begin
	pipeline(0).z <= seed_z;
	pipeline(0).c <= seed_c;
	pipeline(0).stage_overflow <= false;
	pipeline(0).stage_data <= 0;

	-- pll_inst : entity work.pll
		-- port map (
			-- inclk0	 => clock,
			-- c0	 => vga_clock
		-- );

	vga_fsm: entity vga.vga_fsm(fsm)
		port map (
			vga_clock => vga_clock,
			reset => reset,
			point => coordinate_out,
			point_valid => point_valid,
			h_sync => h_sync,
			v_sync => v_sync
		);

	co_map: entity work.coordinate_map(co_map)
		port map (
			clock => vga_clock,
			reset => reset,
			vga_coordinate => coordinate_out,
			complex_coordinate => complex_coordinate
		);

	select_fractal: entity work.fractal_select(fract_slct)
		port map (
			clock => vga_clock,
			reset => reset,
			f_select => f_select,
			position => complex_coordinate,
			c => seed_c,
			z => seed_z
		);

	cmplx_pipeline: for idx in 1 to stage_count - 2 generate
		pipeline_stage_x: entity work.pipeline_stage
			generic map (
				threshold => to_ads_sfixed(4),
				stage_number => idx
			)
			port map (
				clock => vga_clock,
				-- clock => clock,
				reset => reset,
				stage_input => pipeline(idx),
				stage_output => pipeline(idx + 1)
			);
	end generate cmplx_pipeline;


	vga_color <= color_black when pipeline(stage_count - 1).stage_overflow else color_blue;
end architecture toplevel;
