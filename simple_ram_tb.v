module simple_ram_tb();
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	
	wire [31:0] q;
	
	simple_ram simple_ram(
	.data(data),
	.addr(addr),	
	.wr(wr),
	.clk(clk),
	.q(q));	
	
	initial
	begin
		data = 8'h01;
		addr = 32'b0;
		wr = 1'b1;
		#50;
		data = 8'h01;
		addr = 32'b01;
		wr = 1'b0;
		if (q != data)
			$display("Error");
		#50;
		
		data = 8'h02;
		addr = 32'd02;
		#100;
		
		addr = 32'd01;
		wr = 1'b0;
		#100;
		
		addr = 32'd02;
		#100;
		
	end
	
	always #50 clk = ~clk;
	
endmodule 