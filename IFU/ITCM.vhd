-- On-chip memory for instructions

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.riscv_pkg.all;
use work.mem_init.all;

entity ITCM is
  port (
    pc: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    q: OUT std_logic_vector(REG_WIDTH - 1 downto 0)
  ) ;
end ITCM;

architecture behave of ITCM is

    signal instr_mem : mem_t:= MEM;

begin
    -- pc is in byte so slide right by 2 units
    q <= instr_mem(to_integer(unsigned(pc(REG_WIDTH - 1 downto 2))));
end behave ; -- behave