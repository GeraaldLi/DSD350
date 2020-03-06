Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;

Entity TBDiv7 is
Generic ( N : natural := 18 );
End Entity TBDiv7;

Architecture behavioural of TBDiv7 is
	Constant Period : time := 10 ns;
	Constant StableTime : time := 4 ns;
	Signal clock : std_logic := '0';
	Signal start, done : std_logic := '0';
-- Now declare the internal signals for the architecture
	Signal x : std_logic_vector( N-1 downto 0 );
	Signal IsDivisible, TBIsDivisible1, TBIsDivisible2 : std_logic;
	Type	IntList is array ( 1 to 10 ) of integer;
	Constant TestValue : IntList := ( 0, 20, 569, 100, 70, 12345, 38572, 958472372, 2344, 43535 );
-- Added Supporting signals for Stimulus   
	signal TestValueIndex : integer := 1; 	--Index for TestValue Array
	signal currentTestValue : integer := 0; -- Modified TestValues, K, K+1 ....
	signal incrementCounts : integer := 0; 	--  Up to 7 to limit K+.. ops 
Begin
	clock <= not clock after Period/2;
DUT:	Entity work.Div7 generic map( N => N )
		port map ( x => x, IsDivisible => IsDivisible );


-- Enter your code for generating stimuli.
Stimulus:
	Process		-- Not sure if it goes forever, need more work
	Begin
		-- Update value, drafted, may contains logic errs
		-- Need double check
		if (TestValueIndex <= 10) and (incrementCounts < 7)  then
			currentTestValue <= TestValue(TestValueIndex) + incrementCounts - 1; -- -1 to accounter initial looping
			incrementCounts <= incrementCounts + 1;
		elsif (TestValueIndex <= 10) and (incrementCounts = 7) then
			currentTestValue <= TestValue(TestValueIndex) + incrementCounts - 1;
			incrementCounts <= 0;
			if TestValueIndex < 10 then
				TestValueIndex <= TestValueIndex + 1;
			end if;
		end if;

		x <= (others => 'U');
		start <= '0';
		if rising_edge(clock) then
			x <= std_logic_vector (to_unsigned(currentTestValue,18)); --Type Conversion
			start <= '1';
		end if;
		wait until Done = '1';
		
	End Process Stimulus;

TBDiv7:
	process ( x ) is
		variable y : natural;
	Begin
		y := to_integer( unsigned(x) );
		if (y mod 7) = 0 then
			TBIsDivisible1 <= '1';
		else
			TBIsDivisible1 <= '0';
		end if;

		y := to_integer( unsigned(x) );
		while (y >= 7) loop
			y := y - 7;
		end loop;
		if y = 0 then
			TBIsDivisible2 <= '1';
		else
			TBIsDivisible2 <= '0';
		end if;
	End Process TBDiv7;

-- Enter your code for detecting response errors.
Detector:
	Process
	Begin
		if rising_edge(clock) and (start = '1') then
			Done <= '0';
		end if;
		wait until falling_edge(clock);
		IsDivisible <= TBIsDivisible1;
		wait for StableTime;
		assert IsDivisible /= TBIsDivisible1 report "TBIsDivisible1 Not Stable";
		TBIsDivisible1 <= TBIsDivisible2;
		wait for StableTime;
		assert TBIsDivisible1 /= TBIsDivisible2 report "TBIsDivisible2 Not Stable";
		Done <= '1';
	End Process Detector;
End Architecture behavioural;

