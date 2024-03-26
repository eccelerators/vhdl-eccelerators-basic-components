library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity RamDualPort is
	port(
		Clk : in std_logic;
		WriteEnableA : in std_logic_vector(15 downto 0);
		AddressA : in std_logic_vector(6 downto 0);
		WriteDataA : in std_logic_vector;
		ReadDataA : out std_logic_vector;
		WriteEnableB : in std_logic_vector(WriteEnableA'range);
		AddressB : in std_logic_vector(6 downto 0);
		WriteDataB : in std_logic_vector;
		ReadDataB : out std_logic_vector
	);
end entity;

architecture RTL of RamDualPort is

	type ram_type is array (0 to (2 ** AddressA'length * 4) - 1) of std_logic_vector(WriteData'range);
	signal Ram : ram_type := (others => x"BABABABA");
	signal ReadAddressA : std_logic_vector(AddressA'range);
    signal ReadAddressB : std_logic_vector(AddressB'range);
    
begin

	RamProc : process(Clk) is
	begin
		if rising_edge(Clk) then
		    for i in 0 to WriteEnableA'left loop	
				if WriteEnableA(i) = '1' then
					Ram(to_integer(unsigned(AddressA)))((i+1)*8-1 downto i*8) <= WriteDataA((i+1)*8-1 downto i*8);
				end if;
				if WriteEnableB(i) = '1' then
					Ram(to_integer(unsigned(AddressB)))((i+1)*8-1 downto i*8) <= WriteDataB((i+1)*8-1 downto i*8);
				end if;
			end loop;
			
			ReadAddressA <= AddressA;		
			ReadAddressB <= AddressB;
		end if;
	end process;

	ReadDataA <= Ram(to_integer(unsigned(ReadAddressA)));
	ReadDataB <= Ram(to_integer(unsigned(ReadAddressB)));
	
	ErrorProc : process(Clk) is
	begin
		if rising_edge(Clk) then
		    for i in 0 to WriteEnableA'left loop	
			    if WriteEnableA(i) and WriteEnableB(i) then
					report "Write/write conflict: written data indeterminate"
					severity error;
				elsif WriteEnableA(i) or WriteEnableB(i) then
				  report "Read and write to same address: read data indeterminate"
					severity error;
				end if;
			end loop;		
		end if;
	end process;

end architecture;
