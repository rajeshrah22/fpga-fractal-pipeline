library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;


entity fractal_select is
	port (
		clock: in std_logic;
		reset: in std_logic;
		f_select: in std_logic;
		position: in ads_complex;
		c: out ads_complex;
		z: out ads_complex
	);
end entity ;

architecture fract_slct of fractal_select is
	constant julia_c: ads_complex := ads_cmplx(to_ads_sfixed(-1), to_ads_sfixed(0));
begin
	find_fractal: process(clock, reset) is
	begin
		if reset = '0' then
			c <= complex_zero;
			z <= complex_zero;
		elsif rising_edge(clock) then
			if f_select = '1' then
				--sets starting condition for julian: z is converted to a complex number
				z <= position;
				c <= julia_c;
			else -- elsif fractal_select = '0' then
				--sets starting conditions for mandle: c on the screen converted to a complex number
				z <= complex_zero;
				c <= position;
			end if;
		end if;
	end process find_fractal;

end architecture fract_slct;

