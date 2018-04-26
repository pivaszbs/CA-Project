module ram (
	//data to be written
	input [31:0] data,
	
	//memory address
	input [31:0] addr,	
	
	//1 - write mode
	//0 - read mode
	input wr,	
	
	//clock cycle state
	input clk,	
	
	//1 - if ram have finished writing/reading
	//0 - ram is currently writing or reading
	output response,
	
	//data read from memory
	output [31:0] out
);		

	parameter size = 4096;

	//data storage
	reg [31:0] ram [size-1:0];
			
	//these registers store state of ram at the previous clock cycle
	reg [31:0] data_reg;	
	reg [31:0] addr_reg;
	reg wr_reg;	
	reg [31:0] out_reg;
	
	//stores response state after computations in clock cycle and then assigns it to response output
	reg response_reg;
	
	//initialization of registers
	initial
	begin	
		response_reg = 1;
		data_reg = 0;
		addr_reg = addr%size;
		wr_reg = 0;
	end
	
	always @(negedge clk)
	begin
		//comparing current ram state with previous
		if ((data != data_reg) || (addr%size != addr_reg)|| (wr != wr_reg))
		begin
			//if something changes we set our response state to 0 and update previous state to current
			response_reg = 0;
			data_reg = data;
			addr_reg = addr%size;
			wr_reg = wr;
		end
		else
		begin
			if (wr)
				ram[addr] = data;
			else
				out_reg = ram[addr];
			
			response_reg = 1;
		end
	end	
	
	assign out = out_reg;
	assign response = response_reg;
endmodule
	