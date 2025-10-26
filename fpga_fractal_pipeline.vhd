library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity fpga_fractal_pipeline is
	port (
		clock: in std_logic;
		reset: in std_logic;
		fractal_select: in std_logic;
	);
end entity fpga_fractal_pipeline;

architecture toplevel of fpga_fractal_pipeline is
	signal coordinate_out: coordinate;
	signal point_valid: boolean;
	signal h_sync: std_logic;
	signal v_sync: std_logic;
begin
	vga_fsm: entity work.vga_fsm(fsm)
		port map(
			vga_clock => clock;
			reset => reset;
			point => coordinate_out;
			point_valid => point_valid;
			h_sync => h_sync;
			v_sync => h_sync;
		);
end architecture toplevel;
