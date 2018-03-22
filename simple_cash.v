module simple_cash (
	input [31:0] data,
	input [4:0] addr,
	input wr,
	input clk,
	output [31:0] q
);

	reg [3:0] data_array [31:0];
	reg [3:0] valid_array [0:0];
	reg [3:0] tag_array [2:0];
	reg [3:0] index_array [1:0];
	reg [2:0] tag;
	reg [1:0] index;
	reg [4:0] current_addr;
	reg [31:0] current_data;
	
	simple_ram simple_ram(
			.data(data),
			.addr(addr),
			.wr(wr),
			.clk(clk),
			.q(q));
	
	always @(posedge clk)
	begin
		tag = addr >> 2;
		index = addr;
		current_addr = {tag, index};
		
		if (wr)		
		begin									
			valid_array[index] <= 0;
		end
		else
		begin
			if (valid_array[index] && addr == current_addr)
			begin
				current_data = data_array[index];
			end
			else
			begin
				
				
				current_data = q;
				
				data_array[index] = q;
				tag_array[index] = tag;
				valid_array[index] = 1;						
			end
		end
	end
	
	assign q = current_data;
	
endmodule

