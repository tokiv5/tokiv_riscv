library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

package riscv_pkg is
    constant REG_WIDTH: integer := 32;
    constant MEM_DEPTH: integer := 1024;
    constant RF_ADDR_WIDTH: integer := 5;

    constant NOP: std_logic_vector(REG_WIDTH - 1 downto 0) := conv_std_logic_vector(19, REG_WIDTH); -- addi r0 r0 0
    subtype opcode_t is std_logic_vector(6 downto 0);
    type mem_t is array (MEM_DEPTH - 1 downto 0) of std_logic_vector(REG_WIDTH - 1 downto 0);
    constant JAL: opcode_t := "1101111";
    constant JALR: opcode_t := "1100111";
    constant BXX: opcode_t := "1100011";
end package ;