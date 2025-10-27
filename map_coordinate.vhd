library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity coordinate_map is
	generic (
		vga_res: vga_timing := vga_res_default
	);
	port (
		vga_coordinate: in coordinate;
		complex_coordinate: out ads_complex
	);
end entity coordinate_map;

-- Q: Do we need to use a process for this? Or can we make this purely combinatoric?
-- I'm going to make this purely combinational rn
-- also it is a simple coordniate map that maps the center of the plane to the center of the screen.
architecture co_map of coordinate_map is
	constant x_offset: natural := vga_res.horizontal.active / 2;
	constant y_offset: natural := vga_res.horizontal.active / 2;
begin
	complex_coordinate.re <= vga_coordinate.x - x_offset;
	complex_coordinate.im <= vga_coordinate.y - y_offset;
end architecture co_map;
