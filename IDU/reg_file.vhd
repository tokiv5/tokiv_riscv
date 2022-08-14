library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.riscv_pkg.all;

entity reg_file is
    port (
        clk,rst_n,write_en,readA,readB:IN std_logic; -- Is "write" a reserved word in VHDL?
        WD:IN std_logic_vector(REG_WIDTH-1 downto 0);  -- WD=Write_Data
        WAddr,RA,RB:IN std_logic_vector(RF_ADDR_WIDTH-1 downto 0); -- WAddr=Write_Addr, RA=Read_A_Addr, RB=Read_B_Addr
        QA,QB:OUT std_logic_vector(REG_WIDTH-1 downto 0)
    );
end entity reg_file;

architecture data_flow of reg_file is
    type registerFile is array(0 to RF_AMOUNT-1) of std_logic_vector(REG_WIDTH-1 downto 0);
    signal registers: registerFile:= (others => (others => '0'));
    
begin
    -- Write:
    process(clk, reset)
    begin
        if (rst_n = '0') then
            for i in registers'range loop
                registers(i) <= (others=>'0');
            end loop;
        
        elsif rising_edge(clk) then -- Positive flank
            if (write_en = '1') then
                registers(conv_integer(unsigned(WAddr))) <= WD;
            end if;
        end if;
    end process;
    
    QA <= WD when (RA = WAddr) and (write = 1) else registers(conv_integer(unsigned(RA))) when readA = '1' else (others => '0');
    QB <= WD when (RB = WAddr) and (write = 1) else registers(conv_integer(unsigned(RB))) when readB = '1' else (others => '0');

end data_flow;