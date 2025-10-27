library ieee;
use ieee.std_logic_1164.all;

library vga;
use vga.vga_data.all;

entity vga_fsm is
	generic (
		vga_res:	vga_timing := vga_res_default
	);
	port (
		vga_clock:		in	std_logic;
		reset:			in	std_logic;

		point:			out	coordinate;
		point_valid:	out	boolean;

		h_sync:			out	std_logic;
		v_sync:			out std_logic
	);
end entity vga_fsm;

architecture fsm of vga_fsm is
	-- any internal signals you may need
	signal curr_coordinate: coordinate := make_coordinate(0, 0);
begin
	-- implement methodology to drive outputs here
	-- use vga_data functions and types to make your life easier
	update_pixel: process(clock, reset) is
	begin
		-- double check
		if reset = '0' then
			h_sync <= '0';
			v_sync <= '0';
			point <= make_coordinate(0, 0);
			point_valid <= true;
			curr_coordinate <= make_coordinate(0, 0);
		elsif rising_edge(clock) then
			h_sync <= do_horizontal_sync(curr_coordinate);
			v_sync <= do_vertical_sync(curr_coordinate);
			point <= curr_coordinate;
			point_valid <= point_visible(curr_coordinate);
			curr_coordinate <= update_coordinate(curr_coordinate);
		end if;
	end process update_pixel;


end architecture fsm;
