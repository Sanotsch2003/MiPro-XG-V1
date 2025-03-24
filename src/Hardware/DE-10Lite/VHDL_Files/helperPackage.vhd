LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE helperPackage IS
    TYPE seven_segment_array IS ARRAY (NATURAL RANGE <>) OF STD_LOGIC_VECTOR(6 DOWNTO 0);
    FUNCTION getSevenSegmentArraySize(individualControl : BOOLEAN; numDisplays : INTEGER) RETURN INTEGER;

END helperPackage;

PACKAGE BODY helperPackage IS
    FUNCTION getSevenSegmentArraySize(individualControl : BOOLEAN; numDisplays : INTEGER) RETURN INTEGER IS
    BEGIN
        IF individualControl THEN
            RETURN numDisplays; -- 7 segments per display if controlled individually
        ELSE
            RETURN 1; -- Single 7-segment display
        END IF;
    END FUNCTION;

END helperPackage;