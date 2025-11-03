# clock
set_location_assignment PIN_P11 -to clock;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clock;

# Reset
set_location_assignment PIN_B8 -to reset;
set_instance_assignment -name IO_STANDARD "3.3 V SCHMITT TRIGGER" -to reset;

# Fractal select
set_location_assignment PIN_F15 -to fractal_select
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to fractal_select;

# VGA
set color_pins { red { AA1 V1 Y2 Y1 }
		green { W1 T2 R2 R1 }
		blue { P1 T1 P4 N2 } }

foreach { channel pins } ${color_pins} {
	for { set i 0 } { ${i} < 4 } { incr i } {
		set location [ lindex ${pins} ${i} ]
		set_location_assignment PIN_${location} -to vga_color.${channel}\[${i}\]
		set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to vga_color.${channel}\[${i}\]
	}
}

set_location_assignment PIN_N3 -to h_sync;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to h_sync;

set_location_assignment PIN_N1 -to v_sync;
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to v_sync;
