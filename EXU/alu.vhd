library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity alu is
  port (
    in1, in2: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    op: IN std_logic_vector(2 downto 0);
    rd: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    alu_en: IN std_logic;
    sign_ext: IN std_logic;
    wr_en: OUT std_logic;
    rd_out: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    result: OUT std_logic_vector(REG_WIDTH - 1 downto 0)
  ) ;
end alu;

architecture arch of alu is

    signal shamt: integer;

begin
    shamt <= conv_integer(unsigned(in2(4 downto 0)));
    rd_out <= rd;
    wr_en <= alu_en;
    process(in1, in2, op, alu_en, sign_ext)
    begin
        if alu_en = '0' then
            result <= (others => '0');
        else
            case( op ) is
                when "000" => -- add sub
                    if sign_ext = '0' then
                        result <= in1 + in2;
                    else
                        result <= in1 - in2;
                    end if ;
                when "001" => -- sll
                    result(shamt - 1 downto 0) <= (others => '0');
                    result(REG_WIDTH - 1 downto shamt) <= in1(REG_WIDTH - 1 - shamt downto 0);
                when "010" => -- slt
                    if in1 < in2 then
                        result <= conv_std_logic_vector(1, REG_WIDTH);
                    else
                        result <= conv_std_logic_vector(0, REG_WIDTH);
                    end if ;
                when "011" => -- sltu
                    if unsigned(in1) < unsigned(in2) then
                        result <= conv_std_logic_vector(1, REG_WIDTH);
                    else
                        result <= conv_std_logic_vector(0, REG_WIDTH);
                    end if ;
                when "100" => -- xor
                    result <= in1 xor in2;
                when "101" => -- srl sra
                    result(REG_WIDTH - 1 - shamt downto 0) <= in1(REG_WIDTH - 1 downto shamt);
                    if sign_ext = '0' then -- srl
                        result(REG_WIDTH - 1 downto REG_WIDTH - shamt) <= (others => '0');
                    else
                        result(REG_WIDTH - 1 downto REG_WIDTH - shamt) <= (others => in1(REG_WIDTH - 1));
                    end if ;
                when "110" => -- or
                    result <= in1 or in2;
                when "111" => -- and
                    result <= in1 and in2;
                when others =>
                    result <= (others => '0');
            end case ;
        end if ;
        
    end process ;
end arch ; -- arch