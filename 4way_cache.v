module cache_4way(
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output [31:0] q
);

	reg [31:0] data_array [3:0];
	reg valid_array [3:0];	
	reg [29:0] tag_array [3:0];
	
	reg [30:0] tag;
	reg set_index;
	reg [31:0] out_data;
	
	reg enable_reg;	
	wire enable;
	wire [31:0] out;
	
	reg [31:0] data_ram;
	reg [31:0] addr_ram;
	reg wr_ram;
	reg clk_ram;
	
	simple_ram simple_ram(
			.data(data_ram),
			.addr(addr_ram),
			.wr(wr_ram),
			.clk(clk_ram),
			.enable(enable),
			.q(out));
	
	initial
	begin
		clk_ram = 1'b1;
	end
	
	always #50 clk_ram = ~clk_ram;
	
	always @(posedge clk)
	begin
		
		data_ram = data;
		addr_ram = addr;
		wr_ram = wr;
		tag = addr << 1;
		set_index = addr >> 29 - addr % 4;
		enable_reg = 0;
		
		if (wr)		
		begin
			if (valid_array[set_index*2] && valid_array[set_index*2+1])
				valid_array[set_index*2] <= 0;
			enable_reg = 1;
		end
		else
		begin
			if (valid_array[set_index*4] && tag == tag_array[set_index*4])
			begin
				out_data = data_array[set_index*4];
			end
			else if (valid_array[set_index*4+1] && tag == tag_array[set_index*4+1])
			begin
				out_data = data_array[set_index*4+1];
			end
			else if (valid_array[set_index*4+2] && tag == tag_array[set_index*4+2])
			begin
				out_data = data_array[set_index*4+2];
			end
			else if (valid_array[set_index*4+3] && tag == tag_array[set_index*4+3])
			begin
				out_data = data_array[set_index*4+3];
			end
			else if (valid_array[set_index*4]&&valid_array[set_index*4+1]&&valid_array[set_index*4+2]&&!valid_array[set_index*4+3])
			begin
				enable_reg = 1;
				#25
				data_array[set_index*4+3] = out;
				tag_array[set_index*4+3] = tag;				
				valid_array[set_index*4+3] = 1;
				out_data = out;
			end
			else if (valid_array[set_index*4]&&valid_array[set_index*4+1]&&!valid_array[set_index*4+2])
			begin
				enable_reg = 1;
				#125
				data_array[set_index*4+2] = out;
				tag_array[set_index*4+2] = tag;				
				valid_array[set_index*4+2] = 1;
				out_data = out;
			end
			else if (valid_array[set_index*4]&&!valid_array[set_index*4+1])
			begin
				enable_reg = 1;
				#125
				data_array[set_index*4+1] = out;
				tag_array[set_index*4+1] = tag;				
				valid_array[set_index*4+1] = 1;
				out_data = out;
			end
			else
			begin
				enable_reg = 1;
				#125
				data_array[set_index*4] = out;
				tag_array[set_index*4] = tag;				
				valid_array[set_index*4] = 1;
				out_data = out;
			end
		end
	end	
	
	assign enable = enable_reg;
	assign q = out_data;
	
endmodule

