library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity testbench is
end testbench;

architecture ifu_tb of testbench is
    signal clk: std_logic := '1';
    signal rst_n, jalr_rd_en, is_rf_write: std_logic; 
    signal pc, ir, jalr_rs1_val: std_logic_vector(REG_WIDTH - 1 downto 0);
    signal rf_write_addr: std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    component ifu is
        port (
          clk, rst_n: IN std_logic;
          pc, ir: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
          jalr_rs1_val: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          jalr_rd_en: OUT std_logic; -- enable signal for rf
          is_rf_write: IN std_logic; -- whether there is a raw for jalr
          rf_write_addr: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0)
        ) ;
      end component;
begin
    clk <= not clk after 5 ns;
    rst_n <= '0' ,'1' after 5 ns;
    jalr_rs1_val <= (others => '0');
    is_rf_write <= '0', '1' after 200 ns;
    rf_write_addr <= conv_std_logic_vector(3, RF_ADDR_WIDTH), (others => '0') after 200 ns;
    DUT: ifu 
    port map(
        clk, rst_n, pc, ir, jalr_rs1_val,  jalr_rd_en, is_rf_write, rf_write_addr
    );
end ifu_tb ; -- ifu_tb