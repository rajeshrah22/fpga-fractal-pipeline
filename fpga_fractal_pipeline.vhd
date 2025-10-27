library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed.all;

library vga;
use vga.vga_data.all;

entity fpga_fractal_pipeline is
	generic (
		stage_count: natural := 16
	);
	port (
		clock: in std_logic;
		reset: in std_logic;
		fractal_select: in std_logic
	);
end entity fpga_fractal_pipeline;

architecture toplevel of fpga_fractal_pipeline is
	signal coordinate_out: coordinate;
	signal point_valid: boolean;
	signal h_sync: std_logic;
	signal v_sync: std_logic;
	signal h_sync_to_pipe: std_logic;
	signal v_sync_to_pipe: std_logic;
	signal c_to_fractal_select: ads_complex;

	type pipeline_data_array_t is array (natural range <>) of pipeline_data;
	signal pipeline: pipeline_data_array_t(0 to stage_count - 1);
begin
	vga_fsm: entity work.vga_fsm(fsm)
		port map (
			vga_clock => clock,
			reset => reset,
			point => coordinate_out,
			point_valid => point_valid,
			h_sync => h_sync,
			v_sync => v_sync
		);

	co_map: entity work.coordinate_map(co_map)
		port map (
			vga_coordinate => coordinate_out,
			complex_coordinate => c_to_fractal_select
		);

	-- first input should come from fractal select
	-- last output shoudl go to coloring circuit
	some_pipeline: for idx in 1 to stage_count - 1 generate
		pipeline_stage_x: entity work.pipeline_stage
			generic map (
				threshold => to_ads_sfixed(4),
				stage_number => idx
			)
			port map (
				clock => clock,
				reset => reset,
				stage_input => pipeline(idx - 1),
				stage_output => pipeline(idx)
			);
	end generate some_pipeline;

	-- keeps vga sync signals in synchrony with pipeline
	sync_shift_register: entity work.sync_shift
		generic map (
			stage_count => stage_count
		)
		port map (
			vga_clock => clock,
			reset => reset,
			h_sync_in => h_sync,
			v_sync_in => v_sync,
			h_sync_out => h_sync_to_pipe,
			v_sync_out => v_sync_to_pipe
		);

	-- place color circuit
end architecture toplevel;
