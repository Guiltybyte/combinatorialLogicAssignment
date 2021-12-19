------------------------
-- REQUIRES VHDL 2008 --
------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity exFunc_ripCarAddSub_4 is
    port(
        sub         :   in  std_logic;  -- when 0 is adder, when 1 is subtractor 
        a4, b4      :   in  std_logic_vector(3 downto 0);  
        s_vec       :   out std_logic_vector(3 downto 0);
        Negative    :   out std_logic;  -- tie to MSB of s_vec
        Zero        :   out std_logic;  -- and all of s_vec bits
        Carry       :   out std_logic;  -- same as MS_cout 
        Overflow    :   out std_logic   -- Carry XOR prevCarry
    );
end exFunc_ripCarAddSub_4;

architecture Behavioral of exFunc_ripCarAddSub_4  is
    -- define the fullAdder.vhd as a component for use in this design
    component fullAdder is
        port(
            a, b, cin   :   in std_logic;
            s,  cout    :   out std_logic
        );
    end component fullAdder;
    -- define intermediate carry vector for tying carry's between fullAdders
    signal interCarry : std_logic_vector(4 downto 0);
    -- define acc_b4 to solve cannot update "in" object error for signal when 2's complementing
    signal acc_b4: std_logic_vector(b4'range);
    signal subLine: std_logic_vector(b4'range);

begin
    subline <= (others => sub); -- I think when others is used by itself it means every bit (hopefully)
    acc_b4 <= b4 xor subLine;
    interCarry(0) <= sub; --first carry in is zero if adder but one (to facilitate last step of two's compliment) if subber
    daisyChain : for iter in 0 to a4'length-1 generate
        fa_i : fullAdder
            port map(
                a => a4(iter),
                b => acc_b4(iter),
                cin => interCarry(iter),
                s => s_vec(iter),
                cout => interCarry(iter+1)                
            );
    end generate daisyChain;
    -- Extra Functionality Flags
    Negative <= s_vec(s_vec'length - 1);
    Zero <= nor s_vec; -- Reduction operator only defined in vhdl 2008
    Carry <= interCarry(interCarry'length - 1);
    Overflow <= interCarry(interCarry'length - 1) xor interCarry(interCarry'length - 2);
end Behavioral;
