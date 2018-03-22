module cache (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output [31:0] q
);

	reg [31:0] data_array [3:0];
	reg valid_array [3:0];	
	reg [29:0] tag_array [3:0];
	reg [1:0] index_array [3:0];	
	
	reg [29:0] tag;
	reg [1:0] index;
	reg [31:0] out_data;
	reg enable_reg;	
	wire enable;
	wire [31:0] out;
	
	simple_ram simple_ram(
			.data(data),
			.addr(addr),
			.wr(wr),
			.clk(clk),
			.enable(enable),
			.q(out));
	
	always @(posedge clk)
	begin
		tag = addr >> 2;
		index = addr;		
		enable_reg = 0;
		
		if (wr)		
		begin									
			valid_array[index] <= 0;
			enable_reg = 1;
		end
		else
		begin
			if (valid_array[index] && tag == tag_array[index])
			begin
				out_data = data_array[index];
			end
			else
			begin					
				enable_reg = 1;
				data_array[index] = q;
				tag_array[index] = tag;
				valid_array[index] = 1;
				out_data = out;
			end
		end
	end	
	
	assign enable = enable_reg;
	assign q = out_data;
	
endmodule

