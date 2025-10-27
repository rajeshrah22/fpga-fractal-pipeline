library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex.all;
use ads.ads_sfixed.all;

library vga;
use vga.vga_data.all;

entity sync_shift is
	generic (
		stage_count: natural
	);
	port (
		signal vga_clock: in std_logic;
		signal reset: in std_logic;
		signal h_sync_in: in std_logic;
		signal v_sync_in: in std_logic;
		signal h_sync_out: out std_logic;
		signal v_sync_out: out std_logic
	);
end entity sync_shift;

architecture shift_register of sync_shift is
	signal h_sync_register: std_logic_vector(stage_count - 1 downto 0);
	signal v_sync_register: std_logic_vector(stage_count - 1 downto 0);
begin
	shift_registers: process(vga_clock, reset) is
	begin
		if reset = '0' then
			h_sync_register <= (others => '0');
			v_sync_register <= (others => '0');
		elsif rising_edge(clock) then
			h_sync_register <= h_sync_register(stage_count - 2 downto 0) & h_sync_in;
			v_sync_register <= v_sync_register(stage_count - 2 downto 0) & v_sync_in;
		end if;
	end process shift_registers;

	h_sync_out <= h_sync_register(stage_count - 1);
	v_sync_out <= v_sync_register(stage_count - 1);
end architecture shift_register;
