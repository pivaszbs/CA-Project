module simple_ram (
	input [31:0] data, //data bus
	input [4:0] addr, //memory adress
	//wr is 1 - Write mode
	//wr is 0 - Read mode
	input wr, clk, enable,
	output [31:0] q
);

	reg [31:0] ram [31:0]; //storage of data
	reg [31:0] addr_reg;   //adress of data
	
	always @(posedge clk)
	begin
		if (enable)
			if (wr)
				ram[addr] <= data;
			else
				addr_reg <= addr;
	end
	
	assign q = ram[addr];
	
endmodule
	
	