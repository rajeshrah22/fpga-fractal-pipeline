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
	signal a2_out: ads_sfixed;
	signal b2_out: ads_sfixed;
	signal ab_out: ads_sfixed;

	signal z2plusc: ads_complex;
	signal abs2z: ads_sfixed;
	signal z2plusc_out: ads_complex;
	signal abs2z_out: ads_sfixed;
begin
	-- multiplication
	a2 <= stage_input.z.re * stage_input.z.re;
	b2 <= stage_input.z.im * stage_input.z.im;
	ab <= stage_input.z.re * stage_input.z.im;

	mult_reg: process(clock, reset) is
	begin
		if reset = '0' then
			a2_out <= (others => '0');
			b2_out <= (others => '0');
			ab_out <= (others => '0');
		elseif rising_edge(clock) then
			a2_out <= a2;
			b2_out <= b2;
			ab_out <= ab;
		end if;
	end process mult_reg;

	-- addition
	z2plusc.re <= a2 - b2 + stage_input.c.re;
	z2plusc.im <= ab + ab + stage_input.c.im;
	abs2z <= a2 + b2;

	add_reg: process(clock, reset) is
	begin
		if reset = '0' then
			z2plusc_out <= (others => '0');
			abs2z_out <= (others => '0');
		elseif rising_edge(clock) then
			z2plusc_out <= z2plusc;
			abs2z_out <= abs2z;
		end if;
	end process add_reg;

	-- comparison and output
	if stage_input.stage_overflow then
		stage_output.stage_data <= stage_input.stage_data;
	else
		stage_output.stage_data <= stage_input.stage_number;
	end if;

	if abs2z_out > threshold then
		stage_output.stage_overflow <= stage_input.stage_overflow;
	else
		stage_output.stage_overflow <= false;
	end if;

	stage_output.c <= stage_input.c;
	stage_output.z <= z2plusc_out;
end architecture rtl;

