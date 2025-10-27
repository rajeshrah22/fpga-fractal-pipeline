library ieee;
use ieee.std_logic_1164.all;

use work.pipeline_pkg.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

entity pipeline_stage is
	generic (
		threshold: ads_sfixed;
		stage_number: natural
	);
	port (
		reset: in std_logic;
		clock: in std_logic;
		stage_input: in pipeline_data;
		stage_output: out pipeline_data
	);
end entity pipeline_stage;

architecture rtl of pipeline_stage is
	signal a2: ads_sfixed;
	signal b2: ads_sfixed;
	signal ab: ads_sfixed;
	signal a2_out: ads_sfixed;
	signal b2_out: ads_sfixed;
	signal ab_out: ads_sfixed;
	signal cout1: ads_complex;

	signal z2plusc: ads_complex;
	signal abs2z: ads_sfixed;
	signal z2plusc_out: ads_complex;
	signal abs2z_out: ads_sfixed;
	signal cin2: ads_complex;
	signal cout2: ads_complex;

	signal stage_data_out1: natural;
	signal stage_data_out2: natural;
	signal stage_overflow_out2: boolean;
	signal stage_overflow_out2: boolean;
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
			cout1.re <= (others => '0');
			cout1.im <= (others => '0');
			stage_data_out1 <= 0;
			stage_overflow_out1 <= false;
		elsif rising_edge(clock) then
			a2_out <= a2;
			b2_out <= b2;
			ab_out <= ab;
			cout1 <= stage_input.c;
			stage_data_out1 <= stage_input.stage_data;
			stage_overflow_out1 <= stage_input.stage_overflow;
		end if;
	end process mult_reg;

	-- addition
	z2plusc.re <= a2_out - b2_out + cout1.re;
	z2plusc.im <= ab_out + ab_out + cout1.im;
	abs2z <= a2_out + b2_out;

	add_reg: process(clock, reset) is
	begin
		if reset = '0' then
			z2plusc_out.re <= (others => '0');
			z2plusc_out.im <= (others => '0');
			abs2z_out <= (others => '0');
			stage_data_out2 <= 0;
			stage_overflow_out2 <= false;
			cout2.re <= (others => '0');
			cout2.im <= (others => '0');
		elsif rising_edge(clock) then
			z2plusc_out <= z2plusc;
			abs2z_out <= abs2z;
			stage_data_out2 <= stage_input.stage_data;
			stage_overflow_out2 <= stage_input.stage_overflow;
			cout2 <= cout1;
		end if;
	end process add_reg;

	-- comparison and output
	-- TODO: modify stage to take in stage_data.stage_valid
	stage_output.stage_data <= stage_data_out2 when stage_overflow_out2 else stage_number;

	stage_output.stage_overflow <= stage_overflow_out2 when abs2z_out > threshold else false;

	stage_output.c <= cout2;
	stage_output.z <= z2plusc_out;
end architecture rtl;

