------------------------
-- REQUIRES VHDL 2008 --
------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplier_4X4 is
    port (
        Ain, Bin    : in std_logic_vector(3 downto 0);
        Pout        : out std_logic_vector(7 downto 0)
    );
end Multiplier_4X4;

architecture Behavioral of Multiplier_4X4 is
    type arrayOfVecs is array (0 to 3) of std_logic_vector(3 downto 0);
    component rippleCarry_AddSub_4 is
        port(
            sub     :   in  std_logic;  -- when 0 is adder, when 1 is subtractor 
            a4, b4  :   in  std_logic_vector(3 downto 0);  
            s_vec      :   out std_logic_vector(3 downto 0);
            MS_cout    :   out std_logic
        );
    end component rippleCarry_AddSub_4;    
    signal partialProductOp : arrayOfVecs; -- a4 inputs
    signal additionLine     : arrayOfVecs; -- b4 inputs
begin
    -- initialize some input signals
    initPP : for i in 0 to Ain'length-1 generate
        partialProductOp(i) <= (3 downto 0 => Bin(i)) and Ain; -- (3 downto 1) gets assigned to b4(2 downto 0) (b4(1) gets assigned '0')
    end generate initPP;
    additionLine(0) <= b"0" & partialProductOp(0)(3 downto 1);  
    
    -- Connect the 4 bit Adders together 
    Chain : for iter in 0 to Ain'length-2 generate
        Adder4bit : rippleCarry_AddSub_4
            port map(
                sub => '0',
                a4 => partialProductOp(iter+1),
                b4 => additionLine(iter),   -- b4 is an input so it is being DRIVEN by additionLine
                s_vec(0) => Pout(iter+1),    -- accounts for outputs from 1 up to Pout(3)
                s_vec(3 downto 1) => additionLine(iter+1)(2 downto 0), -- s is an output so it is ASSIGNING to additionLine            
                MS_cout => additionLine(iter+1)(additionLine(iter+1)'length-1) --MSout is an output so it is ASSIGNING to first bit of additionLine
            );
    end generate Chain;
    
    -- P(0), P(4), P(5), P(6) & P(7) still need to be mapped
    Pout(0) <= partialProductOp(0)(0);  -- I really appreciaten the consistency of the indexing syntax in VHDL
    Pout(7 downto 4) <= additionLine(3);
end Behavioral;