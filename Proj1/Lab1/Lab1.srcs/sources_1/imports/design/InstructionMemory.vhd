library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity InstructionMemory is
    Port ( Address : in STD_LOGIC_VECTOR (7 downto 0);
           DataOut : out STD_LOGIC_VECTOR (31 downto 0));
end InstructionMemory;

architecture Structural of InstructionMemory is
type storage_type is array (0 to 255) of std_logic_vector(31 downto 0);

-- COMENTAR A LINHA SEGUINTE E DESCOMENTAR AS LINHAS CORRESPONDENTES AO TURNO DA SEMANA
--signal storage: storage_type := (others => x"00000000");

----------------------------------------------------------------------------------------------------
-- MEMORY
----------------------------------------------------------------------------------------------------
signal storage: storage_type := (
--          --    OPCODE &   DR   &   SA   &   SB   &        KNS        -- ASSEMBLY CODE
         0 => "000001" & "0001" & "0000" &   "111111010011000011",      --        ADDI  R1,R0,#-2877
         1 => "000011" & "0111" & "0000" &   "000000000000001000",      --        SUBI  R7,R0,#8
         2 => "000001" & "0010" & "0000" & "000000000000001111",        --        ADDI  R2,R0,#15
         3 => "000000" & "0010" & "0010" & "0111" & "00000000000000",   --        ADD   R2,R2,R7
         4 => "000010" & "0010" & "0010" & "0010" & "00000000000000",   --        SUB   R2,R2,R2
         5 => "000000" & "0000" & "0000" & "0000" & "00000000000000",   --        NOP
         6 => "001101" & "0011" & "0000" & "0010" & "00000000000000",   --        XNOR R3,R2,R0
         7 => "001100" & "0100" & "0000" & "0011" & "00000000000000",   --        XOR R4,R3,R0
         8 => "000100" & "0101" & "0000" & "0100" & "00000000000000",   --        AND R5,R4,R0  r5 fica com tudo zero
         9 => "000001" & "0110" & "0000" &    "010000101110111000",    --        ADDI  R6,R0,#3000
         10 =>"000101" & "1000" & "0110" & "000000000000001000",   --        ANDIL R8,R6,0000000
         11 =>"000110" & "1001" & "1000" & "000000000000111111",   --        ANDIH R9,R8,R0  saida e suposto ser 000000100000001000
         12 => "000111"& "0100" & "0000" & "0000" & "00000000000000",   --        NAND R4,R0,R0  (NOT R0)
         13 => "000111"& "1010" & "0100" & "1001" & "00000000000000",   --        NAND R10,R4,R9  saida e suposto ser 111111011111110111
         14 => "001000"& "1011" & "1010" & "1001" & "00000000000000",   --        OR R11,R10,R9  saida e suposto ser 111111111111111111

         15 => "001001"& "1100" & "1001" & "00"&"0010101010101010",   --        ORIL R12,R9
         16 => "001010"& "1101" & "1001" & "00"&"0010101010101010",   --        ORIH R13,R9
         17 => "001011"& "1110" & "1101" & "1111" & "00000000000000",  --        NOR R14,R13,R0
         18 =>  "000001" & "1111" & "0000" &   "111111010011000011",      --        ADDI  R15,R0,#-2877
         19 => "010011" & "1111" & "0000" & "1111" & "00000000000000",     --        SHRA  R15,R15
         20 => "010001" & "1111" & "0000" & "1111" & "00000000000000",      --        ROR  R15,R15
         21 => "010000" & "1111" & "0000" & "1111" & "00000000000000",    --        ROL  R15,R15
         22 => "001111" & "1111" & "0000" & "1111" & "00000000000000",      --        SHR  R15,R15
         23 => "001110" & "1111" & "0000" & "1111" & "00000000000000",   --        SHL  R15,R15
         24 => "010010" & "1111" & "0000" & "1111" & "00000000000000",      --        SHLA  R15,R15
         --loads
         25 =>  "000001" & "0010" & "0000" &   "111111111111111110",      --        ADDI  R2,R0,#-2
         26 => "010110" & "0000" & "0010" & "1111" & "00000000001010",      --     ST  R2+#10  >R15
         27 => "010101" & "0011" & "0010" & "000000000000001010",    --       LDI  R3,R2#10 -2
         28 =>  "000001" & "0100" & "0000" &   "000000000000001010",      --        ADDI  R4,R0,#10
         29 => "010100" & "1110" & "0010" & "0100" & "00000000000000",      --     LD  R14,R4+R2
         --branches



--         4 => "001100" & "0100" & "0001" & "0010" & "00000000000000", -- LOOP:  XOR   R4,R1,R2
--         5 => "000100" & "0100" & "0100" & "0010" & "00000000000000", --        AND   R4,R4,R2
--         6 => "010100" & "0101" & "0100" & "0000" & "00000000000000", --        LD    R5,(R4+R0)
--         7 => "010011" & "0001" & "0000" & "0001" & "00000000000000", --        SHRA  R1,R1
--         8 => "010011" & "0001" & "0000" & "0001" & "00000000000000", --        SHRA  R1,R1
--         9 => "010011" & "0001" & "0000" & "0001" & "00000000000000", --        SHRA  R1,R1
--        10 => "010011" & "0001" & "0000" & "0001" & "00000000000000", --        SHRA  R1,R1
--        11 => "000000" & "0011" & "0011" & "0101" & "00000000000000", --        ADD   R3,R3,R5
--        12 => "011000" & "0011" & "0001" & "0111" & "11111111111111", --        BI.NE R1,#-1,R7     ; --> if (R4 >= R3) goto LOOP
--        13 => "010111" & "0000" & "0000" & "0000" & "00000000000000", -- END:   B     #0            ; --> END
    others => x"00000000" -- NOP
);


begin

DataOut <= storage(to_integer(unsigned(Address)));

end Structural;
