library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity test is
  port (
    d: in std_logic_vector(7 downto 0);
    q: out std_logic_vector(15 downto 0)
  ) ;
end test;

architecture behave of test is

begin
    q <= (7 downto 0 => (d(1 downto 0) & d(2) & d(7 downto 3)), others => '0');
end behave ; -- behave