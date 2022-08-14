library IEEE;
use IEEE.std_logic_1164.all;
use work.riscv_pkg.all;

entity idu is
  port (
    clk, rst_n: IN std_logic;
    pc, instr: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    rs2, rs1: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    alu_op3: OUT std_logic_vector(2 downto 0);
    rf_q1, rf_q2: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    sign_ext: OUT std_logic;
    rd_out: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    alu_in1, alu_in2: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
  ) ;
end idu;

architecture arch of idu is
    component id is
        port (
          pc, instr: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          rs2, rs1, rd: OUT std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
          funct7: OUT std_logic_vector(6 downto 0);
          funct3: OUT std_logic_vector(2 downto 0);
          imm: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
          command_type: OUT ctype;
        ) ;
      end component;

    component id_ex is
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
        );
    end component;

    signal rd: std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
    signal funct7: std_logic_vector(6 downto 0);
    signal funct3: std_logic_vector(2 downto 0);
    signal imm: std_logic_vector(REG_WIDTH - 1 downto 0);
    signal command_type: ctype;
begin
    ID0: id
    port map(
        pc => pc,
        instr => instr,
        rs2 => rs2,
        rs1 => rs1,
        rd => rd,
        funct7 => funct7,
        funct3 => funct3,
        imm => imm,
        command_type => command_type
    );

    REGS: id_ex
    port map(
        clk => clk,
        rst_n => rst_n,
        rd_in => rd,
        imm => imm,
        rf_q1 => rf_q1,
        rf_q2 => rf_q2,
        funct3 => funct3,
        funct7 => funct7,
        alu_op3 => alu_op3,
        sign_ext => sign_ext,
        rd_out => rd_out,
        alu_in1 => alu_in1, 
        alu_in2 => alu_in2,
        command_type => command_type
    );

end arch ; -- arch