module cache_example(output out);
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	reg state;
	
	wire [31:0] q;
	
	cache_4way cache_4way(
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
		addr = 5'b00000;
		wr = 1'b1;
		#200
		
		data = 32'b01;
		addr = 5'b00;
		wr = 1'b0;	
		#200
		
		if (q == data)
			state = 0;
		else
			state = 1;		
	end
	
	always #50 clk = ~clk;	
	
endmodule