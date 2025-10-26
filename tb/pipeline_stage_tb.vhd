library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_fixed.all;
use ads.ads_complex_pkg.all;

use work.pipeline_pkg.all;

entity pipeline_stage_tb is
end entity pipeline_stage_tb;

architecture test of pipeline_stage_tb is
	signal reset, clock: std_logic := '0';
	signal test_done: boolean := false;
	signal stage_input, stage_output: pipeline_data;

	type stimulus_data_type is array(natural range<>) pipeline_data;
	constant stimulus_data: stimulus_data_type := (
			( ),
			( ),
			( ),
			( )
		);
begin

	clock <= not clock after 2 ns when not test_done else '0';

	dut: entity work.pipeline_stage(rtl)
		generic map (
			threshold =>	to_ads_sfixed(4.0),
			stage_number => 0
		)
		port map (
			reset => reset,
			clock => clock,
			stage_input => stage_input,
			stage_output => stage_output
		);

	stimulus: process is
	begin
		reset <= '0';
		wait for rising_edge(clock);
		wait for rising_edge(clock);
		reset <= '1';

		for i in stimulus_data'range loop
			stage_input <= stimulus_data(i);
			wait for rising_edge(clock);
		end loop;
		wait for rising_edge(clock);
		wait for rising_edge(clock);
		test_done <= true;
		wait;
	end process stimulus;

end architecture test;
