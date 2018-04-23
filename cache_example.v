module cache_example(output a);
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	
	wire is_missrate;
	wire [31:0] out;
	
	cache_2way cache_2way(
	.data(data),
	.addr(addr),
	.wr(wr),	
	.clk(clk),
	.is_missrate(is_missrate),
	.out(out));
		
	initial
	begin
		clk = 1;		
		
		data = 32'b01;		
		addr = 5'b0;
		wr = 1'b1;
		#500;
		
		data = 32'b11;
		addr = 5'b1;
		wr = 1'b1;	
		#500;
		
		addr = 5'b1;
		wr = 1'b0;
		#500;
		
		addr = 5'b0;
		#500;
	end
	
	always #50 clk = ~clk;
	
endmodule