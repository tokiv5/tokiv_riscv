library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;
entity bpu is
  port (
    is_jal, is_jalr, is_bxx: IN std_logic;
    bjp_imm, pc: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    pc_next: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    jalr_rs1: IN std_logic_vector(4 downto 0);
    jalr_rs1_val: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    jalr_rd_en: OUT std_logic; -- enable signal for rf
    is_rf_write: IN std_logic; -- whether there is a raw for jalr, is last command I or R type
    rf_write_addr: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0); -- last command which in IDU
    bpu_wait: OUT std_logic -- wait rf return value, nop 1 cycle
  ) ;
end bpu;

architecture behave of bpu is

    signal add_op1, add_op2: std_logic_vector(REG_WIDTH - 1 downto 0);

begin
    add_op1 <= pc when is_jalr = '0' else jalr_rs1_val;

    add_op2 <= bjp_imm when (is_jal = '1' or is_jalr = '1' or (is_bxx = '1' and bjp_imm(REG_WIDTH - 1) = '1')) -- predict jumping for jal and jalr, bxx when jump back
        else conv_std_logic_vector(4, REG_WIDTH);

    bpu_wait <= '1' when ((is_rf_write = '1') and (rf_write_addr = jalr_rs1) and (is_jalr = '1')) else '0';

    jalr_rd_en <= is_jal;

    pc_next <= add_op1 + add_op2;
    
end behave ; -- behave