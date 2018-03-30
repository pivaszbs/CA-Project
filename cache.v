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
				#125
				data_array[index] = out;
				tag_array[index] = tag;				
				valid_array[index] = 1;
				out_data = out;
			end
		end
	end	
	
	assign enable = enable_reg;
	assign q = out_data;
	
endmodule

