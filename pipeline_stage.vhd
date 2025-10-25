library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

entity pipeline_stage is
	generic (
		threshold: ads_sfixed;
		stage_number: natural;
	);
	port (
		reset: in std_logic;
		clock: in std_logic;
		stage_input: in pipeline_data;
		stage_output: out pipeline_data;
	);
end entity pipeline_stage;

architecture rtl of pipeline_stage is
	signal a2: ads_sfixed;
	signal b2: ads_sfixed;
	signal ab: ads_sfixed;
begin
	part1: process(clock, reset) is -- can we instead do this in the falling edge of the clock in the same process?
	begin
		if reset = '0' then
			a2 <= to_ads_sfixed(0);
			b2 <= to_ads_sfixed(0);
			ab <= to_ads_sfixed(0);
		elseif rising_edge(clock) then
			a2 <= stage_input.z.re * stage_input.z.re;
			b2 <= stage_input.z.im * stage_input.z.im;
			ab <= stage_input.z.re * stage_input.z.im;
		end if;
	end process part1;

	part2: process(clock, reset) is
	begin
		if reset = '0' then
			stage_output <= (others => '0');
		elseif rising_edge(clock) then
			if stage_input.stage_overflow then
				stage_output.stage_data <= stage_input.stage_data;
			else
				stage_output.stage_data <= stage_input.stage_number;
			end if;
			stage_output.c <= stage_input.c;
			stage_output.z.re <= a2 - b2 + 2 * ab;
			if (a2 + b2) > threshold then
				stage_output.stage_overflow <= stage_input.stage_overflow;
			else
				stage_output.stage_overflow <= false;
			end if;
		end if;
	end process part2;
end architecture rtl;

