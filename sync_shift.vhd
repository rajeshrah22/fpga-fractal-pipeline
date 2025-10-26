library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity sync_shift is
begin
	generic (
		stage_count: natural;
	);
	port (
		signal vga_clock: in std_logic;
		signal reset: in std_logic;
		signal h_sync_in: in std_logic;
		signal v_sync_in: in std_logic;
		signal h_sync_out: out std_logic;
		signal v_sync_out: out std_logic;
	);
end entity sync_shift;

architecture shift_register of sync_shift is
	signal h_sync_register: std_logic_vector(stage_count - 1 downto 0);
	signal v_sync_register: std_logic_vector(stage_count - 1 downto 0);
	signal h_sync_index: natural := 0;
	signal v_sync_index: natural := 0;
begin
	shift_registers: process(vga_clock, reset, h_sync_in, v_sync_in) is
		if reset = '0' then
		elseif rising_edge(clock) then
			if h_sync_in = '1' then
				-- TODO something
			elseif v_sync_in = '1' then
				-- TODO something
			else
				-- TODO something
			end if;
		end if;
	end process shift_registers;
end entity co_map;
