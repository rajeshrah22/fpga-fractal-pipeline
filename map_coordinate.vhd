library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex_pkg.all;
use ads.ads_fixed.all;

library vga;
use vga.vga_data.all;

entity coordinate_map is
	generic (
		vga_res: vga_timing := vga_res_default;
		re_width: real := 4.0;
		im_height: real := 3.0
	);
	port (
		clock: in std_logic;
		reset: in std_logic;
		vga_coordinate: in coordinate;
		complex_coordinate: out ads_complex
	);
end entity coordinate_map;

-- Q: Do we need to use a process for this? Or can we make this purely combinatoric?
-- I'm going to make this purely combinational rn
-- also it is a simple coordniate map that maps the center of the plane to the center of the screen.
architecture co_map of coordinate_map is
	constant x_width: natural := vga_res.horizontal.active;
	constant y_height: natural := vga_res.vertical.active;
	constant x_center: natural := x_width / 2;
	constant y_center: natural := y_height / 2;
	constant re_scale: ads_sfixed := to_ads_sfixed(re_width / real(x_width));
	constant im_scale: ads_sfixed := to_ads_sfixed(-im_height / real(y_height));

	constant im_max: ads_sfixed := to_ads_sfixed(im_height / 2.0);
	constant re_min: ads_sfixed := to_ads_sfixed(-re_width / 2.0);
begin
	process(clock, reset)
	begin
		if reset = '0' then
			complex_coordinate.re <= to_ads_sfixed(0);
			complex_coordinate.im <= to_ads_sfixed(0);
		elsif rising_edge(clock) then
			complex_coordinate.re <= to_ads_sfixed(vga_coordinate.x) * re_scale + re_min;
			complex_coordinate.im <= to_ads_sfixed(vga_coordinate.y) * im_scale + im_max;
		end if;
	end process;
end architecture co_map;
