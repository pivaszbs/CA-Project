module simple_ram_tb(output abidna);
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	reg state;
	reg enable;
	wire [31:0] q;

	simple_ram simple_ram(
	.data(data),
	.addr(addr),	
	.wr(wr),
	.clk(clk),
	.enable(enable),
	.q(q));	
	
	initial
	begin
		clk = 1'b1;
		enable = 1;
	
		data = 8'h01;
		addr = 32'b01;
		wr = 1'b1;
		#200;
		
		data = 8'h02;
		addr = 32'd02;
		#200;
		
		
		data = 8'h00;
		addr = 32'b00;	
		#200;			
		
		
		addr = 32'd00;
		wr = 1'b0;
		#200;
		
		addr = 32'd01;
		#200;
		
		addr = 32'd02;
		#200;
		
	end
	
	always #50 clk = ~clk;
	
endmodule 