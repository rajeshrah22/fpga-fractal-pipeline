library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity fpga_fractal_pipeline is
	generic (
		stage_count: natural := 16;
	);
	port (
		clock: in std_logic;
		reset: in std_logic;
		fractal_select: in std_logic;
	);
end entity fpga_fractal_pipeline;

architecture toplevel of fpga_fractal_pipeline is
	signal coordinate_out: out coordinate;
	signal point_valid: out boolean;
	signal h_sync: out std_logic;
	signal v_sync: out std_logic;
	signal h_sync_to_pipe: out std_logic;
	signal v_sync_to_pipe: out std_logic;
begin
	vga_fsm: entity work.vga_fsm(fsm)
		port map (
			vga_clock => clock;
			reset => reset;
			point => coordinate_out;
			point_valid => point_valid;
			h_sync => h_sync;
			v_sync => h_sync;
		);

	pipeline: for i in stage_count - 1 downto 0 generate
	end generate pipeline;

	sync_shift_register: entity work.sync_shift
		generic map (
			stage_count => stage_count;
		);
		port map (
			vga_clock => clock;
			reset => reset;
			h_sync_in => h_sync;
			v_sync_in => v_sync;
			h_sync_out => h_sync_to_pipe;
			v_sync_out => v_sync_to_pipe;
		);
end architecture toplevel;
