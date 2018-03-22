module cache_example (
	input [31:0] data,
	input [4:0] addr,
	input wr,
	input clk,
	output [31:0] q
);

	reg [31:0] data_array [3:0];
	reg valid_array [3:0];
	reg [2:0] tag_array [3:0];
	reg [1:0] index_array [3:0];
	
	reg [2:0] tag;
	reg [1:0] index;
	wire enable;
	
	simple_ram simple_ram(
			.data(data),
			.addr(addr),
			.wr(wr),
			.clk(clk),
			.enable(enable),
			.q(q));
	
	always @(posedge clk)
	begin
		tag = addr >> 2;
		index = addr;
		assign enable = 1;
		
		if (wr)		
		begin									
			valid_array[index] <= 0;
			assign enable = 1;
		end
		else
		begin
			if (valid_array[index] && addr == current_addr)
			begin
				assign q = data_array[index];
			end
			else
			begin					
				assign enable = 1;
				data_array[index] = q;
				tag_array[index] = tag;
				valid_array[index] = 1;						
			end
		end
	end
	
endmodule

