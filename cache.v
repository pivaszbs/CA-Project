module cache 
(	
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,	
	output response,
	output is_missrate,
	output [31:0] out
);	
	
	parameter size = 1024;
	parameter index_size = 10;	

	reg [31:0] data_array [size - 1:0];
	reg valid_array [size - 1:0];	
	reg [29:0] tag_array [size - 1:0];
	reg [1:0] index_array [size - 1:0];	
	
	reg [size - index_size - 1:0] tag;
	reg [index_size - 1:0] index;	
	
	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;
	reg response_reg;
	reg is_missrate_reg;
	reg [31:0] out_reg;
	
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
		
	initial
	begin		
		data_reg = 0;
		addr_reg = 0;
		wr_reg = 0;				
	end
	
	always @(posedge clk)
	begin	
		if (data_reg != data || addr_reg != addr || wr_reg != wr)
		begin
			response_reg = 0;
		
			data_reg = data;
			addr_reg = addr;
			wr_reg = wr;					
			
			//caculating of tag and index
			tag = addr >> 2;
			index = addr;
			
			// if write mode
			if (wr)
			begin		
				// updating arrays in the cache
				data_array[index] = data;
				tag_array[index] = tag;			
				
				// updating ram inputs
				ram_data = data;
				ram_addr = addr;
				ram_wr = wr;
			end
			else
			begin
				// if there are exists data with given address in the cache
				if (valid_array[index] && tag == tag_array[index])
				begin								
					// since we found it in cache, it is not a missrate
					is_missrate_reg = 0;					
					// loading data from cache to output
					out_reg = data_array[index];
					response_reg = 1;
				end
				else
				begin		
					// since we did not found it in cache, it is a missrate
					is_missrate_reg = 1;								
					
					ram_data = data;
					ram_addr = addr;
					ram_wr = wr;									
				end
			end
		end				
		else
		begin
			if (ram_response)
			begin
				response_reg = 1;
				valid_array [index] = 1;	
				data_array [index] = ram_out;				
				tag_array[index] = tag;
				out_reg = ram_out;
			end
		end
	end		

	assign out = out_reg;
	assign is_missrate = is_missrate_reg;
	assign response = response_reg;
	
endmodule