module cache_4way(
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output is_missrate,
	output [31:0] out
);
	parameter size = 64;
	parameter index_size = 4;
	
	reg [31:0] data_array [size-1:0];
	reg valid_array [size-1:0];	
	reg [31-index_size:0] tag_array [size-1:0];
	
	reg [31-index_size:0] tag;
	reg [index_size-1:0] set_index;
	reg [31:0] out_data;
	
	reg enable_reg;	
	wire enable;
	wire [31:0] out_ram;
	
	reg [31:0] data_ram;
	reg [31:0] addr_ram;
	reg wr_ram;
	reg clk_ram;
	
	reg miss_reg;
	reg [1:0] write_reg;
	
	ram ram(
			.data(data_ram),
			.addr(addr_ram),
			.wr(wr_ram),
			.clk(clk_ram),
			.response(enable),
			.out(out_ram));
	
	
	
	assign enable = enable_reg;
	assign out = out_data;
	assign is_missrate = miss_reg;
	
	initial
	begin
		write_reg = 0;
		clk_ram = 1'b1;
	end
	
	always #50 clk_ram = ~clk_ram;
	
	always @(posedge clk)
	begin
		
		data_ram <= data;
		addr_ram <= addr;
		wr_ram <= wr;
		tag <= addr << index_size;
		set_index <= addr - addr % 4;
		enable_reg <= 0;
		
		if (wr)		
		begin
			if (valid_array[set_index*4] && valid_array[set_index*4+1] && valid_array[set_index*4+2] && valid_array[set_index*4+3])
				valid_array[set_index*2+write_reg] <= 0;
			enable_reg <= 1;
			miss_reg = 1;
			write_reg = write_reg +1;
		end
		else
		begin
			//put in free place in cache block
			if (valid_array[set_index*4] && tag == tag_array[set_index*4])
			begin
				out_data <= data_array[set_index*4];
				miss_reg = 0;
			end
			else if (valid_array[set_index*4+1] && tag == tag_array[set_index*4+1])
			begin
				out_data <= data_array[set_index*4+1];
				miss_reg = 0;
			end
			else if (valid_array[set_index*4+2] && tag == tag_array[set_index*4+2])
			begin
				miss_reg = 0;
				out_data <= data_array[set_index*4+2];
			end
			else if (valid_array[set_index*4+3] && tag == tag_array[set_index*4+3])
			begin
				miss_reg = 0;
				out_data <= data_array[set_index*4+3];
			end
			else if (valid_array[set_index*4]&&valid_array[set_index*4+1]&&valid_array[set_index*4+2]&&!valid_array[set_index*4+3])
			//take info from RAM
			begin
				enable_reg <= 1;
				#125
				data_array[set_index*4+3] <= out_ram;
				tag_array[set_index*4+3] <= tag;				
				valid_array[set_index*4+3] <= 1;
				out_data <= out_ram;
				miss_reg = 1;	
			end
			else if (valid_array[set_index*4]&&valid_array[set_index*4+1]&&!valid_array[set_index*4+2])
			begin
				enable_reg <= 1;
				#125
				data_array[set_index*4+2] <= out_ram;
				tag_array[set_index*4+2] <= tag;				
				valid_array[set_index*4+2] <= 1;
				out_data <= out_ram;
				miss_reg = 1;
			end
			else if (valid_array[set_index*4]&&!valid_array[set_index*4+1])
			begin
				enable_reg <= 1;
				#125
				data_array[set_index*4+1] <= out_ram;
				tag_array[set_index*4+1] <= tag;				
				valid_array[set_index*4+1] <= 1;
				out_data <= out_ram;
				miss_reg = 1;
			end
			else
			begin
				enable_reg <= 1;
				#125
				data_array[set_index*4] <= out_ram;
				tag_array[set_index*4] <= tag;				
				valid_array[set_index*4] <= 1;
				out_data <= out_ram;
				miss_reg = 1;
			end
		end
	end
	
endmodule