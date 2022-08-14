library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.numeric_std.all;

package riscv_pkg is
    constant REG_WIDTH: integer := 32;
    constant MEM_DEPTH: integer := 1024;
    constant RF_ADDR_WIDTH: integer := 5;
    constant RF_AMOUNT: integer := 2**RF_ADDR_WIDTH;

    constant NOP: std_logic_vector(REG_WIDTH - 1 downto 0) := conv_std_logic_vector(19, REG_WIDTH); -- addi r0 r0 0
    subtype opcode_t is std_logic_vector(6 downto 0);
    type mem_t is array (MEM_DEPTH - 1 downto 0) of std_logic_vector(REG_WIDTH - 1 downto 0);
    type ctype is (I, S, B, U, J, R);
    -- opcodes
    constant LUI : opcode_t := "0110111";
    constant AUI : opcode_t := "0010111"; -- auipc
    constant JAL : opcode_t := "1101111";
    constant JALR: opcode_t := "1100111";
    constant BXX : opcode_t := "1100011";
    constant LXX : opcode_t := "0000011";
    constant SXX : opcode_t := "0100011";
    constant ARII: opcode_t := "0010011"; -- arith with immediate
    constant ARI : opcode_t := "0110011"; -- arith with registers
    constant FEN : opcode_t := "0001111"; -- fence, fencei
    constant CSR : opcode_t := "1110011"; -- exception, csr
end package ;