-----------------------------------------------------------------------------
-- First couple of question in Assignment 2
-- These questions demonstrate the use of 
--     a) formal GENERICS
--     b) ENTITYs with multiple ARCHITECTURES and
--     c) GENERATING simple and recursive structures.
-----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity ParityCheck is
     generic( width : integer := 8 );
     port( input : in std_logic_vector( width-1 downto 0 );
           output: out std_logic );
end entity ParityCheck;




architecture Tree1 of ParityCheck is
begin
end architecture tree1;




architecture Chain1 of ParityCheck is
begin
end architecture chain1;




architecture Chain2 of ParityCheck is
begin
end architecture chain2;



-----------------------------------------------------------------------------
-- This version of the architecture performs a recursive instantiation of
-- the ENTITY/ARCHITECTURE. The GENERIC parameter width controls the recursion
-- The recursion stops when the parameter is either 2 or 3. We do not allow
-- the width to become 1 as this may cause problems in specifying the range
-- for the indices of the input array.
-- The division by 2 truncates so you must be very careful when dividing the
-- circuit into two sub-circuits and indexing their input arrays.
-----------------------------------------------------------------------------
architecture Tree2 of ParityCheck is
begin
end architecture Tree2;

