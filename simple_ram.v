module ram (
	input [31:0] data, //data bus
	input [31:0] addr, //memory adress	
	//wr is 1 - Write mode
	//wr is 0 - Read mode
	input wr,	
	input clk,	
	output state,
	output [31:0] q
);
	reg [31:0] data_reg;	
	reg wr_reg;

	reg [31:0] ram [31:0]; //storage of data
	reg [31:0] addr_reg;   //adress of data
	reg state_reg;
	
	initial
	begin
		state_reg = 1;
		data_reg = 0;
		addr_reg = 0;
		wr_reg = 0;
	end
	
	always @(posedge clk)
	begin		
		if ((data != data_reg) || (addr != addr_reg) || (wr != wr_reg))
		begin
			state_reg = 0;
			data_reg = data;
			addr_reg = addr;
			wr_reg = wr;
		end
	
		if (wr)
			ram[addr] = data;
		else
			addr_reg = addr;
			
		state_reg = 1;
	end
	
	assign q = ram[addr_reg];
	assign state = state_reg;
endmodule
	