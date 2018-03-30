module cache_example(output out);
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	reg state;
	
	wire [31:0] q;
	
	cache cache(
	.data(data),
	.addr(addr),
	.wr(wr),	
	.clk(clk),
	.q(q));
		
	initial
	begin
		clk = 1;		
		state = 0;		
		
		data = 32'b01;		
		addr = 5'b0;
		wr = 1'b1;
		#100;
		
		data = 32'b11;
		addr = 5'b1;
		wr = 1'b1;	
		#100;
		
		addr = 5'b1;
		wr = 1'b0;
		#200;
		
		addr = 5'b0;
		#100;		
	end
	
	always #50 clk = ~clk;	
	
endmodule