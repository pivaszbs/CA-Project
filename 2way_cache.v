module cache_2way (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output [31:0] q
);

	reg [31:0] data_array [3:0];
	reg valid_array [3:0];	
	reg [29:0] tag_array [3:0];
	
	reg [27:0] tag;
	reg [1:0] set_index;
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
		tag = addr << 3;
		set_index = addr >> 30;
		set_index = set_index << 1;
		enable_reg = 0;
		
		if (wr)		
		begin									
			valid_array[set_index*2] <= 0;
			enable_reg = 1;
		end
		else
		begin
			if (valid_array[set_index*2] && tag == tag_array[set_index*2])
			begin
				out_data = data_array[set_index*2];
			end
			else if (valid_array[set_index*2+1] && tag == tag_array[set_index*2+1])
			begin
				out_data = data_array[set_index*2+1];
			end
			else
			begin
				enable_reg = 1;
				#25
				data_array[set_index*2] = out;
				tag_array[set_index*2] = tag;				
				valid_array[set_index*2] = 1;
				out_data = out;
			end
		end
	end	
	
	assign enable = enable_reg;
	assign q = out_data;
	
endmodule
