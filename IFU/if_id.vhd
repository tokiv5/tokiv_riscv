library IEEE;
use IEEE.std_logic_1164.all;
use work.riscv_pkg.all;
entity if_id is
  port (
    clk, rst_n, bpu_wait: IN std_logic;
    pc, instr: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    pc_ifu, ir_next: IN std_logic_vector(REG_WIDTH - 1 downto 0)
  ) ;
end if_id;

architecture behave of if_id is

    signal pc_reg, ir_reg: std_logic_vector(REG_WIDTH - 1 downto 0);

begin
    pc <= pc_reg;
    instr <= ir_reg;
    ifid_regs : process( clk, rst_n )
    begin
        if rst_n = '0' then
            pc_reg <= (others => '0');
            ir_reg <= NOP;
        elsif rising_edge(clk) then
            pc_reg <= pc_ifu;
            if bpu_wait = '1' then
                ir_reg <= NOP;
            else
                ir_reg <= ir_next;                
            end if ;

        end if ;
    end process ; -- ifid_regs
end behave ; -- behave