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
	signal iq: std_logic_vector(width downto 0);
begin
	C(0)<=Cin;
	iq(0)<=Cin;
     	bitcell: for i in 0 to width-1
     	generate
     	begin
          	CpropCalculation:entity Work.Cprop port map ( G(i), P(i), iq(i), iq(i+1));
		C(i+1)<=iq(i+1);
     	end generate bitcell;
end architecture Ripple;

architecture BookSkip of Cnet is
	signal iq: std_logic_vector(width downto 0);
	signal t: std_logic_vector(3 downto 0);
	signal k: std_logic_vector(3 downto 0);
begin
	iq(0)<=Cin;
	--andloop:for h in 0 to 3 generate
		--ii:entity Work.and4 port map ( P(h*4),P(h*4+1),P(h*4+2),P(h*4+3),td(h));
	--end generate andloop;
	forloop:for j in 0 to 3
	generate
     		--bitcell: for i in j*4 to j*4+2 generate
		CpropCalculation5:entity Work.Cprop port map ( k(j), t(j), iq(j*4), iq(j*4+4));
          	CpropCalculation1:entity Work.Cprop port map ( G(j*4), P(j*4), iq(j*4), iq(j*4+1));
		CpropCalculation2:entity Work.Cprop port map ( G(j*4+1), P(j*4+1), iq(j*4+1), iq(j*4+1+1));
		CpropCalculation3:entity Work.Cprop port map ( G(j*4+2), P(j*4+2), iq(j*4+2), iq(j*4+2+1));
     		--end generate bitcell;
		CpropCalculation4:entity Work.Cprop port map ( G(j*4+3), P(j*4+3), iq(j*4+3), k(j));
		andCalculation:entity Work.and4 port map ( P(j*4),P(j*4+1),P(j*4+2),P(j*4+3),t(j));
		
		C<=iq;

	end generate forloop;
	--bitcell0: for i in 0 to 3 generate
          		--CpropCalculation:entity Work.Cprop port map ( G(i), P(i), iq(i), iq(i+1));
     		--end generate bitcell0;
		--p1:entity Work.Cprop port map ( G(3), P(3), iq(3), k);
		--p2:entity Work.and4 port map ( P(0),P(1),P(2),P(3),t);
		--p3:entity Work.Cprop port map ( k, t, iq(0), iq(4));

	--bitcell1: for i in 0 to 4 generate
		--C(i)<=iq(i);
		--end generate bitcell1;				
end architecture BookSkip;

architecture GoodSkip of Cnet is
	signal iq: std_logic_vector(width downto 0);
	signal t: std_logic_vector(3 downto 0);
	signal k: std_logic_vector(3 downto 0);
	signal orGate: std_logic_vector(11 downto 0);
begin
	iq(0)<=Cin;
	forloop:for j in 0 to 3
	generate
     		--bitcell: for i in j*4 to j*4+2 generate
		andCalculation:entity Work.and4 port map ( P(j*4),P(j*4+1),P(j*4+2),P(j*4+3),t(j));
          	CpropCalculation1:entity Work.Cprop port map ( G(j*4), P(j*4), iq(j*4), orGate(j*3));
		CpropCalculation2:entity Work.Cprop port map ( G(j*4+1), P(j*4+1), iq(j*4+1), orGate(j*3+1));
		CpropCalculation3:entity Work.Cprop port map ( G(j*4+2), P(j*4+2), iq(j*4+2), orGate(j*3+2));
     		--end generate bitcell;
		CpropCalculation4:entity Work.Cprop port map ( G(j*4+3), P(j*4+3), iq(j*4+3), k(j));
		CpropCalculation5:entity Work.Cprop port map ( k(j), t(j), iq(j*4), iq(j*4+4));
		orGate1: entity Work.or2 port map ( iq(j*4+4), orGate(3*j),  iq(j*4+1));
		orGate2: entity Work.or2 port map ( iq(j*4+4), orGate(3*j+1),  iq(j*4+2));
		orGate3: entity Work.or2 port map ( iq(j*4+4), orGate(3*j+2),  iq(j*4+3));
	end generate forloop;
	C<=iq;
end architecture GoodSkip;

architecture BrentKung of Cnet is
-- pi = xi xor yi
-- gi = xi and yi
-- ci+1 = (ci and pi) or gi
    signal GP_P, GP_G : std_logic_vector(width-1 downto 0);
    signal iq : std_logic_vector(width downto 0);
begin  
     Start: entity work.prefixAdder(Recursion) generic map (width) port map(P,G,GP_P,GP_G);
     C(0) <= Cin;
     Cout: for i in width-1 downto 0 generate
     begin
         Ca: entity work.and2 port map(GP_P(i),Cin,iq(i));
         Cb: entity work.or2 port map(iq(i),GP_G(i),C(i+1));
     end generate Cout;
end architecture BrentKung;

