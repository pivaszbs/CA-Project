module rate_tb(output out);
	
	reg [31:0] data;
	reg [31:0] addr;
	reg wr;
	reg clk;
	reg state;
	wire is_missrate;
	reg[31:0] missrate_counter;
	reg[31:0] hitrate_counter;
	
	wire [31:0] q;
	
	cache cache(
	.data(data),
	.addr(addr),
	.wr(wr),	
	.clk(clk),
	.is_missrate(is_missrate),
	.q(q));
		
	initial
	begin
		clk = 1;		
		state = 0;
		missrate_counter = 0;
		hitrate_counter = 0;
			
		data = 32'b1;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b11;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b100;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b101;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b110;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b111;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1000;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1001;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b1010;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1011;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1100;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b1101;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1110;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b1111;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b10000;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10001;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10010;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b10011;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10100;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10101;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b10110;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b10111;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b11000;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

		data = 32'b11001;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b11010;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b1;
		#500;

		data = 32'b11011;
		addr = 32'b10000000000010000000000100100;
		wr = 1'b0;
		#500;

	end
	
	always #50 clk = ~clk;
	always #500
	begin
		if (is_missrate)
			missrate_counter = missrate_counter + 1;
		else
			hitrate_counter = hitrate_counter + 1;
	end
	
endmodule