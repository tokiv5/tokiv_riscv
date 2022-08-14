-- choose what actually should be sent to exu

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity id_ex is
  port (
    clk, rst_n: IN std_logic;
    rd_in: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    imm, rf_q1, rf_q2: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    funct3: IN std_logic_vector(2 downto 0);
    funct7: IN std_logic_vector(6 downto 0);
    alu_op3: OUT std_logic_vector(2 downto 0);
    sign_ext: OUT std_logic;
    rd_out: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    alu_in1, alu_in2: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    command_type: IN ctype;
  ) ;
end id_ex;

architecture behave of id_ex is

  signal q1, q2: std_logic_vector(REG_WIDTH - 1 downto 0);
  signal op3: std_logic_vector(2 downto 0);
  signal rd: std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
  signal is_sign: std_logic;
begin
  alu_in1 <= q1;
  alu_in2 <= q2;
  alu_op3 <= op3;
  rd_out <= rd;
  sign_ext <= is_sign;

  q : process( clk, rst_n )
  begin
    if rst_n = '0' then
      q1 <= (others => '0');
      q2 <= (others => '0');
      op3 <= (others => '0');
      rd <= (others => '0');
      is_sign <= '0';
    elsif rising_edge(clk) then
      if command_type = R then
        q1 <= rf_q1;
        q2 <= rf_q2;
        op3 <= funct3;
        rd <= rd_in;
        is_sign <= funct7(5);
      elsif command_type = I then
        q1 <= rf_q1;
        q2 <= imm;
        op3 <= funct3;
        rd <= rd_in;
        is_sign <= imm(30);
      else
        q1 <= (others => '0');
        q2 <= (others => '0');
        op3 <= (others => '0');
        rd <= (others => '0');
        is_sign <= '0';
      end if ;
    end if ;

  end process ; -- q

end behave ; -- behave