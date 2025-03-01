library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--(0_0 0_1 0_2 0_3)     (0)
--(1_0 1_1 1_2 1_3)  X  (1)
--(2_0 2_1 2_2 2_3)     (2)
--(3_0 3_1 3_2 3_3)     (3)

entity VPU is
    generic (
        BIT_WIDTH : integer := 18  -- Specify the bit width here, default is 18
    );
    Port (
        -- Input: 4-bit vector of BIT_WIDTH bit numbers (4 vertices, each BIT_WIDTH bits)
        vertexIn  : in  std_logic_vector(4 * BIT_WIDTH - 1 downto 0);  -- 4 vertices, each BIT_WIDTH bits

        -- Input: 4x4 transformation matrix (each element is BIT_WIDTH bits)
        matrixIn  : in  std_logic_vector(4 * 4 * BIT_WIDTH - 1 downto 0); -- 4 * 4 * BIT_WIDTH entries (4x4 matrix)

        -- Output: Resulting transformed vector (4 vertices, BIT_WIDTH bits each)
        vertexOut : out std_logic_vector(4 * BIT_WIDTH - 1 downto 0)  -- 4 vertices, each BIT_WIDTH bits
    );
end VPU;

architecture Behavioral of VPU is
    -- Signals for individual vertex components
    signal vertexIn_0 : signed(BIT_WIDTH - 1 downto 0);
    signal vertexIn_1 : signed(BIT_WIDTH - 1 downto 0);
    signal vertexIn_2 : signed(BIT_WIDTH - 1 downto 0);
    signal vertexIn_3 : signed(BIT_WIDTH - 1 downto 0);

    -- Signals for individual matrix elements
    signal matrixIn_0_0 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_0_1 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_0_2 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_0_3 : signed(BIT_WIDTH - 1 downto 0);

    signal matrixIn_1_0 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_1_1 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_1_2 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_1_3 : signed(BIT_WIDTH - 1 downto 0);

    signal matrixIn_2_0 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_2_1 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_2_2 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_2_3 : signed(BIT_WIDTH - 1 downto 0);

    signal matrixIn_3_0 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_3_1 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_3_2 : signed(BIT_WIDTH - 1 downto 0);
    signal matrixIn_3_3 : signed(BIT_WIDTH - 1 downto 0);

    -- Signals for the transformed vertex outputs (32-bits to avoid overflow)
    signal vertexOut_0 : signed(2 * BIT_WIDTH - 1 downto 0);
    signal vertexOut_1 : signed(2 * BIT_WIDTH - 1 downto 0);
    signal vertexOut_2 : signed(2 * BIT_WIDTH - 1 downto 0);
    signal vertexOut_3 : signed(2 * BIT_WIDTH - 1 downto 0);

begin

    -- Extracting vertex input values from the input vector
    vertexIn_0 <= signed(vertexIn((1 * BIT_WIDTH) - 1 downto 0));
    vertexIn_1 <= signed(vertexIn((2 * BIT_WIDTH) - 1 downto BIT_WIDTH));
    vertexIn_2 <= signed(vertexIn((3 * BIT_WIDTH) - 1 downto 2 * BIT_WIDTH));
    vertexIn_3 <= signed(vertexIn((4 * BIT_WIDTH) - 1 downto 3 * BIT_WIDTH));

    -- Extracting matrix input values from the input matrix vector
    matrixIn_0_0 <= signed(matrixIn((1 * BIT_WIDTH) - 1 downto 0));
    matrixIn_0_1 <= signed(matrixIn((2 * BIT_WIDTH) - 1 downto BIT_WIDTH));
    matrixIn_0_2 <= signed(matrixIn((3 * BIT_WIDTH) - 1 downto 2 * BIT_WIDTH));
    matrixIn_0_3 <= signed(matrixIn((4 * BIT_WIDTH) - 1 downto 3 * BIT_WIDTH));

    matrixIn_1_0 <= signed(matrixIn((5 * BIT_WIDTH) - 1 downto 4 * BIT_WIDTH));
    matrixIn_1_1 <= signed(matrixIn((6 * BIT_WIDTH) - 1 downto 5 * BIT_WIDTH));
    matrixIn_1_2 <= signed(matrixIn((7 * BIT_WIDTH) - 1 downto 6 * BIT_WIDTH));
    matrixIn_1_3 <= signed(matrixIn((8 * BIT_WIDTH) - 1 downto 7 * BIT_WIDTH));

    matrixIn_2_0 <= signed(matrixIn((9 * BIT_WIDTH) - 1 downto 8 * BIT_WIDTH));
    matrixIn_2_1 <= signed(matrixIn((10 * BIT_WIDTH) - 1 downto 9 * BIT_WIDTH));
    matrixIn_2_2 <= signed(matrixIn((11 * BIT_WIDTH) - 1 downto 10 * BIT_WIDTH));
    matrixIn_2_3 <= signed(matrixIn((12 * BIT_WIDTH) - 1 downto 11 * BIT_WIDTH));

    matrixIn_3_0 <= signed(matrixIn((13 * BIT_WIDTH) - 1 downto 12 * BIT_WIDTH));
    matrixIn_3_1 <= signed(matrixIn((14 * BIT_WIDTH) - 1 downto 13 * BIT_WIDTH));
    matrixIn_3_2 <= signed(matrixIn((15 * BIT_WIDTH) - 1 downto 14 * BIT_WIDTH));
    matrixIn_3_3 <= signed(matrixIn((16 * BIT_WIDTH) - 1 downto 15 * BIT_WIDTH));

    -- Matrix multiplication (vertex * matrix)
    vertexOut_0 <= (matrixIn_0_0 * vertexIn_0) + (matrixIn_0_1 * vertexIn_1) + 
                   (matrixIn_0_2 * vertexIn_2) + (matrixIn_0_3 * vertexIn_3);

    vertexOut_1 <= (matrixIn_1_0 * vertexIn_0) + (matrixIn_1_1 * vertexIn_1) + 
                   (matrixIn_1_2 * vertexIn_2) + (matrixIn_1_3 * vertexIn_3);

    vertexOut_2 <= (matrixIn_2_0 * vertexIn_0) + (matrixIn_2_1 * vertexIn_1) + 
                   (matrixIn_2_2 * vertexIn_2) + (matrixIn_2_3 * vertexIn_3);

    vertexOut_3 <= (matrixIn_3_0 * vertexIn_0) + (matrixIn_3_1 * vertexIn_1) + 
                   (matrixIn_3_2 * vertexIn_2) + (matrixIn_3_3 * vertexIn_3);

    -- Assign the final output back to the port
    vertexOut <= std_logic_vector(vertexOut_0(BIT_WIDTH - 1 downto 0) & vertexOut_1(BIT_WIDTH - 1 downto 0) &
                                  vertexOut_2(BIT_WIDTH - 1 downto 0) & vertexOut_3(BIT_WIDTH - 1 downto 0));

end Behavioral;
