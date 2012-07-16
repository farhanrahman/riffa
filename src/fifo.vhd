LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fifo IS
GENERIC (
	C_SIMPBUS_AWIDTH 	: INTEGER := 32;
	C_FIFO_DEPTH		: INTEGER := 512
);
PORT (
	clk, reset, push, pop 	: IN std_logic;
	input					: IN std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	output					: OUT std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	full, empty				: OUT std_logic
);
END ENTITY fifo;

ARCHITECTURE rtl OF fifo IS
		ALIAS slv IS std_logic_vector ;
		ALIAS usg IS unsigned;
		
		CONSTANT endPnt 			: std_logic_vector(C_FIFO_DEPTH - 1 DOWNTO 0) := (OTHERS => '1');
		CONSTANT startPnt			: std_logic_vector(C_FIFO_DEPTH - 1 DOWNTO 0) := (OTHERS => '0');

		TYPE queue_type IS ARRAY (to_integer(usg(endPnt)) DOWNTO 0) OF std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
		SIGNAL queue 				: queue_type;
		SIGNAL readPtr, writePtr 	: std_logic_vector(C_SIMPBUS_AWIDTH - 1 DOWNTO 0) := (OTHERS => '0');
		SIGNAL full1,empty1  		: std_logic;
		SIGNAL output1				: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
		SIGNAL lastop 				: std_logic;
		SIGNAL we					: std_logic;

BEGIN

full <= full1; 
empty <= empty1;
output <= output1; 

Reg: PROCESS
BEGIN
 WAIT UNTIL rising_edge(clk);
  IF (reset = '1') THEN
	writePtr 	<= startPnt; 
	readPtr 	<= startPnt;
    lastop 		<= '0'; 
  ELSE
	IF (pop = '1' and empty1 = '0') THEN
		IF readPtr = endPnt THEN
			readPtr <= startPnt;
		ELSE
			readPtr <= slv(usg(readPtr) + 1);
		END IF;
		lastop <= '0';
	END IF;
  
	IF (push = '1' and full1 = '0') THEN
		IF writePtr /= endPnt THEN
			writePtr <= slv(usg(writePtr) + 1);
		ELSE
			writePtr <= startPnt;
		END IF;
      lastop <= '1';
	END IF;
  END IF;
END PROCESS Reg; 



comb: PROCESS (push,pop,writePtr,readPtr,lastop,full1,empty1)
BEGIN
-- full and empty flags -- 
	 IF (readPtr = writePtr) THEN 
		  IF (lastop = '1') THEN
				full1 <= '1'; 
				empty1 <= '0'; 
			ELSE 
				full1 <= '0';
				empty1 <= '1'; 
		  END IF; 
	 ELSE
		full1 <= '0'; 
		empty1 <= '0'; 
	 END IF; 

-- write enable logic -- 
IF (pop = '0' and push = '0') THEN -- no operation -- 
		we <= '0'; 
ELSIF (pop = '0' and push = '1') THEN -- push only -- 
		  IF (full1 = '0') THEN -- valid write condition -- 
			we <= '1'; 
		  ELSE     -- no write condition -- 
			we <= '0'; 
		  END IF; 
ELSIF (pop = '1' and push = '0') THEN -- pop only -- 
		  we <= '0'; 
ELSE   -- push and pop at same time – 
	  IF (empty1 = '0') THEN -- valid pop -- 
			we <= '0'; 
	  ELSE 
			we <= '1';  
	  END IF; 
 END IF; 
END PROCESS comb; 

RAM : PROCESS (we, readPtr, writePtr, input, queue)
	VARIABLE dat1 	: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0);
	VARIABLE dat2	: std_logic_vector(C_SIMPBUS_AWIDTH-1 DOWNTO 0); 
BEGIN
	IF we = '1' THEN
		dat1 	:= input;
		queue(to_integer(usg(writePtr))) <= dat1;
	END IF;
	dat2 := queue(to_integer(usg(readPtr)));
	output1 <= dat2;
END PROCESS RAM;


END ARCHITECTURE rtl;
