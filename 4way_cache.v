module cache_4way(
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output response,
	output is_missrate,
	output [31:0] out
);
	parameter size = 64;
	parameter index_size = 4;
	
	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;
	
	reg [31:0] data_array [size-1:0];
	reg valid_array [size-1:0];	
	reg [31-index_size:0] tag_array [size-1:0];
	
	reg [31-index_size:0] tag;
	reg [index_size-1:0] set_index;
	reg [31:0] out_data;
	
	reg response_reg;		
	
	reg miss_reg;
	reg [1:0] write_reg;
	
	reg [31:0] ram_data;
	reg [31:0] ram_addr;
	reg ram_wr;	
	wire ram_response;
	wire [31:0] ram_out;		
	
	ram ram(
			.data(ram_data),
			.addr(ram_addr),
			.wr(ram_wr),
			.clk(clk),
			.response(ram_response),
			.out(ram_out));		
			
	integer i;
	initial
	begin
		data_reg = 0;
		addr_reg = 0;
		wr_reg = 0;
		out_data = 0;
		for (i = 0; i < size; i=i+1)
		begin
			data_array[i] = 0;
			tag_array[i] = 0;
			valid_array[i] = 0;
		end
		
		response_reg = 1;
		write_reg = 0;		
	end		
	
	
	always @(posedge clk)
	begin
		// if any input changed
		if (data != data_reg || addr != addr_reg || wr != wr_reg)
		begin
			// setting response register to 0
			response_reg = 0;
		
			// updating input registers
			data_reg = data;
			addr_reg = addr;
			wr_reg = wr;
		
			tag = addr << index_size;
			set_index = addr;			
			
			if (wr)
			begin
				ram_data = data;
				ram_addr = addr;
				ram_wr = wr;	
				if (!valid_array[set_index*4])
				begin
					data_array[set_index*4] = data;
					tag_array[set_index*4] = tag;
					valid_array[set_index*4] = 1;
				end
				
				else if (!valid_array[set_index*4+1])
				begin
					data_array[set_index*4+1] = data;
					tag_array[set_index*4+1] = tag;
					valid_array[set_index*4+1] = 1;
				end
				
				else if (!valid_array[set_index*4 + 2])
				begin
					data_array[set_index*4+2] = data;
					tag_array[set_index*4+2] = tag;
					valid_array[set_index*4+2] = 1;
				end
				else if (!valid_array[set_index*4+3])
				begin
					data_array[set_index*4+3] = data;
					tag_array[set_index*4+3] = tag;
					valid_array[set_index*4+3] = 1;
				end
				else
				begin
					data_array[set_index*4+write_reg] = data;
					tag_array[set_index*4+write_reg] = tag;
					valid_array[set_index*4+write_reg] = 1;
					write_reg = write_reg +1;
				end					
			end
			else
			begin
				if ((valid_array[set_index*4]) && (tag == tag_array[set_index*4]))
				begin
					miss_reg = 0;
				
					out_data = data_array[set_index*4];					
					response_reg = 1;
				end
				else if ((valid_array[set_index*4+1]) && (tag == tag_array[set_index*4+1]))
				begin
					miss_reg = 0;
				
					out_data = data_array[set_index*4+1];					
					response_reg = 1;
				end
				else if ((valid_array[set_index*4+2]) && (tag == tag_array[set_index*4+2]))
				begin					
					miss_reg = 0;
				
					out_data = data_array[set_index*4+2];					
					response_reg = 1;
				end
				else if ((valid_array[set_index*4+3]) && (tag == tag_array[set_index*4+3]))
				begin					
					miss_reg = 0;
				
					out_data = data_array[set_index*4+3];					
					response_reg = 1;
				end
				else
					miss_reg = 1;
					valid_array[set_index*2+write_reg] = 0;
					// updating ram inputs on given cache inputs
					ram_data = data;
					ram_addr = addr;
					ram_wr = wr;
			end
		end
		else
		begin
			// waiting till ram will finish reading/writing
			if (ram_response && ~response_reg)
			begin
				// since all operations are finished, sets response state to 1
				response_reg = 1;
				if (wr == 0)
				begin
					if (!valid_array[set_index*4+3])
					begin										
						data_array[set_index*4+3] = ram_out;
						out_data = ram_out;				
						tag_array[set_index*4+3] = tag;				
						valid_array[set_index*4+3] = 1;							
					end
					else if (!valid_array[set_index*4+2])
					begin								
						data_array[set_index*4+2] = ram_out;
						out_data = ram_out;								
						tag_array[set_index*4+2] = tag;				
						valid_array[set_index*4+2] = 1;					
					end
					else if (!valid_array[set_index*4+1])
					begin				
						data_array[set_index*4+1] = ram_out;
						out_data = ram_out;								
						tag_array[set_index*4+1] = tag;				
						valid_array[set_index*4+1] = 1;					
					end
					else
					begin															
						data_array[set_index*4] = ram_out;
						out_data = ram_out;				
						tag_array[set_index*4] = tag;				
						valid_array[set_index*4] = 1;			
					end
				end
			end
		end
	end
	
	assign response = response_reg;
	assign out = out_data;
	assign is_missrate = miss_reg;
	
endmodule