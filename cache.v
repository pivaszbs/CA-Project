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

	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;

	reg [31:0] data_array [size - 1:0];
	reg valid_array [size - 1:0];	
	reg [29:0] tag_array [size - 1:0];
	reg [1:0] index_array [size - 1:0];	
	
	reg [size - index_size - 1:0] tag;
	reg [index_size - 1:0] index;
	reg [31:0] out_reg;
	
	reg state_reg;
	
	reg is_missrate_reg;
	
	wire [31:0] ram_out;	
	wire ram_response;
	
	ram ram(
		.data(data),
		.addr(addr),			
		.wr(wr),
		.clk(clk),			
		.response(ram_response),
		.out(ram_out));
			
	initial
	begin
		state_reg = 1;
		data_reg = 0;
		addr_reg = 0;
		wr_reg = 0;
	end
	
	always @(posedge clk)
	begin
		if ((data != data_reg) || (addr != addr_reg) || (wr != wr_reg))
		begin
			state_reg = 0;
			data_reg = data;
			addr_reg = addr;
			wr_reg = wr;
		end
			else
			begin
			tag = addr >> 2;
			index = addr;
			
			if (wr)
			begin		
				data_array[index] = data;
				tag_array[index] = tag;							
				if (ram_response)				
					state_reg = 1;
			end
			else
			begin
				if (valid_array[index] && tag == tag_array[index])
				begin
					out_reg = data_array[index];
					state_reg = 1;
					is_missrate_reg = 0;
				end
				else
				begin		
					is_missrate_reg = 1;
					if (ram_response)
					begin
						valid_array[index] = 1;
						data_array[index] = ram_out;
						tag_array[index] = tag;
						out_reg = ram_out;
						state_reg = 1;
					end
				end
			end
		end
	end
		
	assign q = out_reg;
	assign is_missrate = is_missrate_reg;
	
endmodule

