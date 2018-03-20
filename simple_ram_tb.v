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
		clk = 1'b1;
		forever #50 clk = -clk;
	end
	
	initial
	begin
		data = 8'h01;
		addr = 5'd0;
		wr = 1'b1;
		#100;
	end
	
	initial
	begin
		addr = 5'd0;
		wr = 1'b0;
		#100;
	end
	
endmodule 