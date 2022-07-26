library IEEE;
use IEEE.std_logic_1164.all;
use work.riscv_pkg.all;

entity ifu is
  port (
    clk, rst_n: IN std_logic;
    pc, ir: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
    jalr_rs1_val: IN std_logic_vector(REG_WIDTH - 1 downto 0);
    jalr_rd_en: OUT std_logic; -- enable signal for rf
    is_rf_write: IN std_logic; -- whether there is a raw for jalr
    rf_write_addr: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0)
  ) ;
end ifu;

architecture behave of ifu is

    component ITCM is
        port (
          pc: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          q: OUT std_logic_vector(REG_WIDTH - 1 downto 0)
        ) ;
    end component;

    component mini_decoder is
        port (
          instr: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          is_jal, is_jalr, is_bxx: OUT std_logic;
          bjp_imm: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
          jalr_rs1: OUT std_logic_vector(4 downto 0)
        ) ;
    end component;

    component bpu is
        port (
          is_jal, is_jalr, is_bxx: IN std_logic;
          bjp_imm, pc: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          pc_next: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
          jalr_rs1: IN std_logic_vector(4 downto 0);
          jalr_rs1_val: IN std_logic_vector(REG_WIDTH - 1 downto 0);
          jalr_rd_en: OUT std_logic; -- enable signal for rf
          is_rf_write: IN std_logic; -- whether there is a raw for jalr
          rf_write_addr: IN std_logic_vector(RF_ADDR_WIDTH - 1 downto 0);
          bpu_wait: OUT std_logic -- wait rf return value, nop 1 cycle
        ) ;
    end component;

    component if_id is
        port (
          clk, rst_n, bpu_wait: IN std_logic;
          pc, instr: OUT std_logic_vector(REG_WIDTH - 1 downto 0);
          pc_ifu, ir_next: IN std_logic_vector(REG_WIDTH - 1 downto 0)
        ) ;
    end component;

    signal pc_ifu, pc_next, instr: std_logic_vector(REG_WIDTH - 1 downto 0);
    signal is_jal, is_jalr, is_bxx: std_logic;
    signal bjp_imm: std_logic_vector(REG_WIDTH - 1 downto 0);
    signal jalr_rs1: std_logic_vector(4 downto 0);
    signal bpu_wait: std_logic; -- wait rf return value, nop 1 cycle
begin
    pc_ifu_reg : process( rst_n, clk )
    begin
        if rst_n = '0' then
            pc_ifu <= (others => '0');
        elsif rising_edge(clk) then
            if bpu_wait = '0' then
                pc_ifu <= pc_next;
            end if ;
        end if ;
    end process ; -- pc_ifu_reg

    IT0: ITCM
    port map(
        pc => pc_ifu,
        q => instr
    );

    M_DC0: mini_decoder
    port map(
        instr => instr,
        is_jal => is_jal,
        is_jalr => is_jalr,
        is_bxx =>  is_bxx,
        bjp_imm => bjp_imm,
        jalr_rs1 => jalr_rs1
    );

    B0: bpu
    port map(
        is_jal => is_jal,
        is_jalr => is_jalr,
        is_bxx =>  is_bxx,
        bjp_imm => bjp_imm,
        pc => pc_ifu,
        pc_next => pc_next,
        jalr_rs1 => jalr_rs1,
        jalr_rs1_val => jalr_rs1_val,
        jalr_rd_en => jalr_rd_en,
        is_rf_write => is_rf_write,
        rf_write_addr => rf_write_addr,
        bpu_wait => bpu_wait
    );

    IFID: if_id
    port map(
        clk => clk,
        rst_n => rst_n,
        bpu_wait => bpu_wait,
        pc => pc,
        instr => ir,
        pc_ifu => pc_ifu,
        ir_next => instr
    );
end behave ; -- behave