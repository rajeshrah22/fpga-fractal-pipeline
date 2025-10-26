library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity coordinate_map is
begin
	generic (
		vga_res: vga_timing := vga_res_default;
	);
	port (
		vga_clock: in std_logic;
		reset: in std_logic;
		vga_coordinate: in coordinate;
		complex_coordinate: out ads_complex;
	);
end entity coordinate_map;

architecture co_map of coordinate_map is
begin
end entity co_map;
