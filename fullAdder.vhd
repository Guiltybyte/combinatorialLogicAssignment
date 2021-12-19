library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fullAdder is
    Port(
        a, b, cin   : in std_logic;
        s,  cout    : out std_logic
    );
end fullAdder;

architecture behavioural of fullAdder is
    signal aXb : std_logic; -- define intermediate signal
begin
    aXb <= a xor b;
    s <= aXb xor cin;
    cout <= (a and b) or (aXb and cin);
end behavioural;
