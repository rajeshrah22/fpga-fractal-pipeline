library ieee;
use ieee.std_logic_1164.all;

library ads;
use ads.ads_complex_pkg.all;

package pipeline_pkg is
	type pipeline_data is
	record
	    z:    ads_complex;
	    c:    ads_complex;
	    stage_data:    natural;
	    stage_overflow:    boolean;
	    stage_valid: boolean;
	end record pipeline_data;
end package pipeline_pkg;
