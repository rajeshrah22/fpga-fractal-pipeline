GHDL := ghdl
BUILD ?= build
TOP_LEVEL := test_toplevel
TEST_BENCH := fractal_testbench
VHDL_SOURCES :=  ads/ads_fixed.vhd \
		ads/ads_complex.vhd \
		vga/vga_data.vhd \
		vga/vga_fsm.vhd \
		work/color_data.vhd \
		work/fractal_select.vhd \
		work/map_coordinate.vhd \
		work/pipeline_pkg.vhd \
		work/pipeline_stage.vhd \
		work/sync_shift.vhd \
		work/$(TOP_LEVEL).vhd \
		work/$(TEST_BENCH).vhd
		# DE10_LITE/pll.vhd \


OBJ := $(VHDL_SOURCES:%.vhd=%.o)

.PHONY: all clean

all: $(BUILD) $(OBJ) $(TOP_LEVEL)

clean:
	rm *.o

$(BUILD):
	mkdir -p $(BUILD)

%.o: %.vhd
	cd $(BUILD) && $(GHDL) analyze --work=$(patsubst %/,%,$(dir $<)) ../$<

$(TOP_LEVEL): $(OBJ)
	cd $(BUILD) && $(GHDL) elaborate $(TEST_BENCH)
