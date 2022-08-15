library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity id is
  port (
    pc, instr: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2, rs1, rd: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    funct7: OUT std_logic_vector(6 downto 0);
    funct3: OUT std_logic_vector(2 downto 0);
    imm: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    command_type: OUT ctype
  ) ;
end id;

architecture behave of id is

    signal op: opcode_t;
    --signal imm: std_logic_vector(31 downto 0);

begin
    op <= pc(6 downto 0);

    funct7 <= pc(31 downto 25);
    rs2 <= pc(24 downto 20);
    rs1 <= pc(19 downto 15);
    funct3 <= pc(13 downto 11);
    rd <= pc(11 downto 7);

    imm <= (conv_std_logic_vector(20, 0) & pc(31 downto 20)) when (op = LXX) or (op = ARII) or (op = FEN) or (op = CSR) or (op = JALR) -- i type
        else (conv_std_logic_vector(20, 0) & pc(31 downto 25) & pc(11 downto 7)) when op = SXX -- s type
        else (conv_std_logic_vector(19, 0) & pc(31) & pc(7) & pc(30 downto 25) & pc(11 downto 8) & '0') when op = BXX -- b type
        else (pc(31 downto 12) & conv_std_logic_vector(12, 0)) when (op = LUI) or (op = AUI) -- u type
        else (conv_std_logic_vector(11, 0) & pc(31) & pc(19 downto 12) & pc(20) & pc(30 downto 21) & '0') when op = JAL -- j type
        else (others => '0'); 

    command_type <= I when (op = LXX) or (op = ARII) or (op = FEN) or (op = CSR) or (op = JALR) -- i type
    else S when op = SXX -- s type
    else B when op = BXX -- b type
    else U when (op = LUI) or (op = AUI) -- u type
    else J when op = JAL -- j type
    else R;

end behave ; -- behave