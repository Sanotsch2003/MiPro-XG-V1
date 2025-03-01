library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package helperPackage is
    type seven_segment_array is array (natural range <>) of std_logic_vector(6 downto 0);
	 function getSevenSegmentArraySize(individualControl : boolean; numDisplays : integer) return integer;
	 
end helperPackage;

package body helperPackage is
	function getSevenSegmentArraySize(individualControl : boolean; numDisplays : integer) return integer is
    begin
        if individualControl then
				return numDisplays;  -- 7 segments per display if controlled individually
		 else
				return 1;  -- Single 7-segment display
		 end if;
    end function;

end helperPackage;

