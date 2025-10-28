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
		clock: in std_logic;
		reset: in std_logic;
		fractal_select: in std_logic;
		h_sync: out std_logic;
		v_sync: out std_logic;
		vga_color: out rgb_color
	);
end entity test_toplevel;

architecture toplevel of test_toplevel is
	signal coordinate_out: coordinate;
	signal point_valid: boolean;
	signal vga_clock: std_logic;
begin
	pll_inst : entity work.pll
		port map (
			inclk0	 => clock,
			c0	 => vga_clock
		);

	vga_fsm: entity work.vga_fsm(fsm)
		port map (
			vga_clock => vga_clock,
			reset => reset,
			point => coordinate_out,
			point_valid => point_valid,
			h_sync => h_sync,
			v_sync => v_sync
		);

	vga_color <= color_blue when point_valid else color_black;
end architecture toplevel;
