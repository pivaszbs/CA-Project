module simple_cash (
	input [31:0] data,
	input [31:0] address,
	input wr,
	input clock,
	output [31:0] output_data
);

	reg [31:0] memory [31:0];
	reg [31:0] data_address;	

	simple_ram simple_ram(
	.data(data),
	.addr(addr),
	
	.wr(wr),
	.clk(clk),
	.q(q));
	
	always @(posedge clock)
	begin
		if (wr)
		begin
			memory[address] <= data;
			#100;
		end
		else
		begin			
			if (address[0] == 1'b1)			
			begin
				memory[address] <= output_data;
				#100;
			end
			data_address <= address;			
		end
	end
	
	assign output_data = memory[data_address];
	
endmodule

