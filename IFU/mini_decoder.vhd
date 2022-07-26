-- Judge whether next instruction is jump

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;
entity mini_decoder is
  port (
    instr: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    is_jal, is_jalr, is_bxx: OUT std_logic;
    bjp_imm: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    jalr_rs1: OUT std_logic_vector(4 downto 0)
  ) ;
end mini_decoder;

architecture behave of mini_decoder is

  signal is_jal_t, is_jalr_t, is_bxx_t: std_logic;

begin
    is_jal_t <= '1' when instr(6 downto 0) = JAL else '0';
    is_jalr_t <= '1' when instr(6 downto 0) = JALR else '0';
    is_bxx_t <= '1' when instr(6 downto 0) = BXX else '0';

    is_jal <= is_jal_t;
    is_jalr <= is_jalr_t;
    is_bxx <= is_bxx_t;

    imm : process( is_bxx_t, is_jal_t, is_jalr_t )
    begin
      if is_jal_t = '1' then
        bjp_imm(20 downto 0) <= (instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0');
        bjp_imm(31 downto 21) <= (others => instr(REG_WIDTH - 1));
      elsif is_jalr_t = '1' then
        bjp_imm(11 downto 0) <= instr(31 downto 20);
        bjp_imm(31 downto 12) <= (others => instr(REG_WIDTH - 1));
      elsif is_bxx_t = '1' then
        bjp_imm(12 downto 0) <= (instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0');
        bjp_imm(31 downto 13) <= (others => instr(REG_WIDTH - 1));
      else
        bjp_imm <= (others => '0');
      end if ;
    end process ; -- imm

    -- bjp_imm <= ((20 downto 0) => (instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0'), others => sign_bit) when is_jal_t = '1'
    -- else ((11 downto 0) => instr(31 downto 20), others => sign_bit) when is_jalr_t = '1'
    -- else ((12 downto 0) => (instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0'), others => sign_bit) when is_bxx_t = '1'
    -- else (others => '0');

    jalr_rs1 <= instr(19 downto 15);
end behave ; -- behave