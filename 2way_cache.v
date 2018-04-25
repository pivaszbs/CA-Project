 module cache_2way (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output response,
	output is_missrate,
	output [31:0] out
);

	parameter size = 1024;
	parameter index_size = 9;
	
	// input registers (to detect input changes in always block)
	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;
	
	reg response_reg;
	
	reg [31:0] data_array [size-1:0];  // internal storage
	reg valid_array [size-1:0];	
	reg [31-index_size+1:0] tag_array [size-1:0];
	
	reg [31-index_size+1:0] tag;  //divide adress on tag and index
	reg [index_size-1:0] set_index;
	reg [31:0] out_data;
	
	wire [31:0] ram_out;
	
	
	reg [31:0] ram_data; //input for RAM
	reg [31:0] ram_addr; //addr for RAM
	reg ram_wr;  
	reg clk_ram;
	wire ram_response; // check whether RAM is end it's work
	
	reg is_missrate_reg;
	reg write_reg; //register for choose, which block rewrite	
	
	//RAM module
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
		response_reg = 1;
	
		write_reg = 0;
		is_missrate_reg = 0;
	end
	
	always @(posedge clk)
	begin
		// if any input has been changed
		if (data_reg != data || addr_reg != addr || wr_reg != wr)
		begin		
			// setting response register to 0
			response_reg = 0;
			
			// updating input registers
			data_reg = data;
			addr_reg = addr;
			wr_reg = wr;
		
			//caculating of tag and index
			tag <= addr >> index_size;
			set_index = addr;
			
			if (wr)
			begin
				ram_data = data;
				ram_addr = addr;
				ram_wr = wr;	
				if (!valid_array[set_index*2])
				begin
					data_array[set_index*2] = data;
					tag_array[set_index*2] = tag;
					valid_array[set_index*2] = 1;
				end
				
				else if (!valid_array[set_index*2+1])
				begin
					data_array[set_index*2+1] = data;
					tag_array[set_index*2+1] = tag;
					valid_array[set_index*2+1] = 1;
				end
				else
				begin
					data_array[set_index*2+write_reg] = data;
					tag_array[set_index*2+write_reg] = tag;
					valid_array[set_index*2+write_reg] = 1;
					write_reg = write_reg + 1;
				end		
			end
			else		
			begin
				//put in free place in cache block
				if (valid_array[set_index*2] && tag == tag_array[set_index*2])
				begin
					is_missrate_reg = 0;
				
					out_data = data_array[set_index*2];					
					response_reg = 1;
				end
				else if (valid_array[set_index*2+1] && tag == tag_array[set_index*2+1])
				begin
					is_missrate_reg = 0;
				
					out_data = data_array[set_index*2+1];
					response_reg = 1;
				end				
				else
				begin
					is_missrate_reg = 1;
					valid_array[set_index*2+write_reg] = 0;
					// updating ram inputs on given cache inputs
					ram_data = data;
					ram_addr = addr;
					ram_wr = wr;					
				end
			end
		end
		else
		begin
			// waiting till ram will finish reading/writing
			if (ram_response && ~response_reg)
			begin
				// since all operations are finished, sets response state to 1
				response_reg = 1;
				// if it is reading mode, then updates cache data and output
				if (wr == 0)
				begin
					if (valid_array[set_index*2]&&!valid_array[set_index*2+1])
					begin
						data_array[set_index*2+1] = ram_out;
						tag_array[set_index*2+1] = tag;				
						valid_array[set_index*2+1] = 1;						
					end
					else
					begin
						data_array[set_index*2] = ram_out;
						tag_array[set_index*2] = tag;				
						valid_array[set_index*2] = 1;						
					end
					out_data = ram_out;				
				end
			end
		end
	end	
	
	assign response = response_reg;
	assign is_missrate = is_missrate_reg;
	assign out = out_data;
	
endmodule