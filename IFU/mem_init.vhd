library IEEE;
use IEEE.std_logic_1164.all;
use work.riscv_pkg.all;

package mem_init is
    constant MEM: mem_t := (1 => NOP, 2 => NOP, 
    3 => "00000000000000000000000000110011",
    4 => "00000000100000000000000001101111", -- JAL 8
    5 => NOP,
    6 => "00000001000000000010000001100111", -- JALR 16(0)
    others => NOP);
end package ;
