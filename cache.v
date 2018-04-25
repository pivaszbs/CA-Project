module cache 
(	
	// data to be written
	input [31:0] data,
	
	// memory address
	input [31:0] addr,
	
	//1 - write mode
	//0 - read mode
	input wr,
	
	// clock cycle state
	input clk,	
	
	// response state of module
	// 1 - if module have finished writing/reading
	// 0 - module is currently writing or reading
	output response,
	
	// is given read request a missrate
	output is_missrate,
	
	// data read from memory
	output [31:0] out
);	
	// constant cache size
	parameter size = 1024;
	// how many bits we have for index
	parameter index_size = 10;	
	
	// array of data
	reg [31:0] data_array [size - 1:0];
	
	
	// arrays of address, splited on validity bit, tag and index	
	reg valid_array [size - 1:0];		
	reg [31-index_size:0] tag_array [size - 1:0];
	reg [index_size-1:0] index_array [size - 1:0];	
	
	// registers for tag and index
	reg [31 - index_size:0] tag;
	reg [index_size - 1:0] index;	
	
	// input registers (to detect input changes in always block)
	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;
	
	// output regiters (to compute their values in always block and then assign them to outputs)
	reg response_reg;
	reg is_missrate_reg;
	reg [31:0] out_reg;
	
	// registers for inputs of ram module
	reg [31:0] ram_data;
	reg [31:0] ram_addr;
	reg ram_wr;	
	// wires for outputs of ram module
	wire ram_response;
	wire [31:0] ram_out;
	
	// conection to RAM module
	ram ram(
		.data(ram_data),
		.addr(ram_addr),			
		.wr(ram_wr),
		.clk(clk),			
		.response(ram_response),
		.out(ram_out));			
		
	// initializing of input registers
	initial
	begin		
		data_reg = 0;
		addr_reg = 0;
		wr_reg = 0;				
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
			tag = addr >> index_size;
			index = addr;
			
			// if write mode
			if (wr)
			begin
				// updating arrays in the cache
				data_array[index] = data;
				tag_array[index] = tag;			
				valid_array[index] = 1;
				
				// updating ram inputs
				ram_data = data;
				ram_addr = addr;
				ram_wr = wr;
			end
			else
			begin
				// if there are exists data with given address in the cache
				if ((valid_array[index]) && (tag == tag_array[index]))
				begin								
					// since we found it in cache, it is not a missrate
					is_missrate_reg = 0;					
					// loading data from cache to output
					out_reg = data_array[index];		
					// since all operations are finished, sets response state to 1
					response_reg = 1;
				end
				else
				begin		
					// since we did not found it in cache, it is a missrate
					is_missrate_reg = 1;					
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
			if ((ram_response) && (!response_reg))
			begin
				// since all operations are finished, sets response state to 1
				response_reg = 1;
				// if it is reading mode, then updates cache data and output
				if (wr == 0)
				begin
					valid_array [index] = 1;
					data_array [index] = ram_out;
					tag_array[index] = tag;
					out_reg = ram_out;
				end
			end
		end
	end

	// assigning outputs
	assign out = out_reg;
	assign is_missrate = is_missrate_reg;
	assign response = response_reg;
	
endmodule