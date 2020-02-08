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
	signal iq : std_logic_vector( 7 downto 0) ;
begin

	output <= iq(6);
	A0: entity work.xor2 port map( input(0), input(1),iq(0) );
	A1: entity work.xor2 port map( input(2), input(3),iq(1) );
	A2: entity work.xor2 port map( input(4), input(5),iq(2) );
	A3: entity work.xor2 port map( input(6), input(7),iq(3) );
	A4: entity work.xor2 port map( iq(0), iq(1),iq(4) );
	A5: entity work.xor2 port map( iq(2), iq(3),iq(5) );
	A6: entity work.xor2 port map( iq(4), iq(5),iq(6) );





end architecture tree1;




architecture Chain1 of ParityCheck is
	signal iq : std_logic_vector( 7 downto 0) ;
begin
	iq(0) <= input(0);
	output <= iq(7);
	A0: entity work.xor2 port map( iq(0), input(1),iq(1) );
	A1: entity work.xor2 port map( iq(1), input(2),iq(2) );
	A2: entity work.xor2 port map( iq(2), input(3),iq(3) );
	A3: entity work.xor2 port map( iq(3), input(4),iq(4) );
	A4: entity work.xor2 port map( iq(4), input(5),iq(5) );
	A5: entity work.xor2 port map( iq(5), input(6),iq(6) );
	A6: entity work.xor2 port map( iq(6), input(7),iq(7) );
	


end architecture chain1;



architecture Chain2 of ParityCheck is
	signal iq : std_logic_vector( 7 downto 0 );
begin
	iq(0) <= input(0);
	output <= iq(7);
gg:	for z in 0 to 6 generate
Az:	entity work.xor2 port map ( iq(z), input(z+1), iq(z+1) );
	end generate gg;


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
--architecture Tree2 of ParityCheck is
	---signal iq : std_logic_vector( 7 downto 0 );
--begin
--loop:
--loop1: 
--Az:	
       -- if z >= 3 and z<=z/2;
      --  entity work.xor2 port map( input(z),input(z+1),iq(z) );
	--end generate loop1;
--loop2:	
       -- if z >= 3
        
--Az2:	entity work.xor2 port map( input(z),input(z+1),iq(z) );
	--end generate loop1;
--end architecture Tree2;
architecture Tree2 of ParityCheck is
	signal Eup, Elo : std_logic;
begin
  Recur: if ( width > 1 ) generate
	Upper: Entity work.ParityCheck(Tree2) generic map( (width+1)/2 ) port map(input( width-1 downto width/2), Eup);
	Lower: Entity work.ParityCheck(Tree2) generic map( (width)/2 ) port map(input( width/2 - 1 downto 0), Elo);
	output <= Eup xor Elo;
	End Generate Recur;

 StopRecur: if width = 1 generate
	output <=  not input(0);
	End Generate StopRecur;
end architecture Tree2;
