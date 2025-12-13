-- Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
  Port ( 
    CLK100MHZ : in STD_LOGIC;
    BTNL : in STD_LOGIC;
    BTNR : in STD_LOGIC;
    BTNC : in STD_LOGIC;
    BTNU : in STD_LOGIC;
    sw0 : in STD_LOGIC;
    sw1 : in STD_LOGIC;
    sw2 : in STD_LOGIC;
    HS : out STD_LOGIC;
    VS : out STD_LOGIC;
    RED : out STD_LOGIC_VECTOR ( 3 downto 0 );
    GREEN : out STD_LOGIC_VECTOR ( 3 downto 0 );
    BLUE : out STD_LOGIC_VECTOR ( 3 downto 0 )
  );

end top_module;

architecture stub of top_module is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
begin
end;
