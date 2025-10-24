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

begin

	stage: process(clock, reset) is
	begin
		if reset = '0' then
		elseif rising_edge(clock) then
			if stage_input.stage_overflow then
				stage_output.stage_data <= stage_input.stage_data;
			else
				stage_output.stage_data <= stage_input.stage_number;
			end if;
			stage_output.c <= stage_input.c;
			stage_output.z <= stage_input.z * stage_input.z + stage_input.c;
			if abs2(stage_input.z) > threshold then
				stage_output.stage_overflow <= stage_input.stage_overflow;
			else
				stage_output.stage_overflow <= false;
			end if;
		end if;
	end process stage;
end architecture rtl;

