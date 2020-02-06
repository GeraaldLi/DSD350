-----------------------------------------------------------------------------
-- Declare the Carry network for the adder.
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Cnet is
     generic ( width : integer := 16 );
     port (
          G, P     :     in     std_logic_vector(width-1 downto 0);
          Cin      :     in     std_logic;
          C        :     out    std_logic_vector(width downto 0) );
end entity Cnet;



-----------------------------------------------------------------------------
-- Students must Create the following Carry Network Architectures.
-----------------------------------------------------------------------------
architecture Ripple of Cnet is
begin
end architecture Ripple;




architecture BookSkip of Cnet is
begin
end architecture BookSkip;




architecture GoodSkip of Cnet is
begin
end architecture GoodSkip;




architecture BrentKung of Cnet is
begin
end architecture BrentKung;