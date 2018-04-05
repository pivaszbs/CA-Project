module cache (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output state,
	output [31:0] q
);
	reg [31:0] data_reg;
	reg [31:0] addr_reg;
	reg wr_reg;

	reg [31:0] data_array [3:0];
	reg valid_array [3:0];	
	reg [29:0] tag_array [3:0];
	reg [1:0] index_array [3:0];	
	
	reg [29:0] tag;
	reg [1:0] index;
	reg [31:0] out_reg;
	
	reg state_reg;
	
	wire [31:0] ram_out;	
	wire ram_state;
	
	simple_ram simple_ram(
			.data(data),
			.addr(addr),			
			.wr(wr),
			.clk(clk),			
			.state(ram_state),
			.q(ram_out));
			
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
				valid_array[index] <= 0;
				if (ram_state)
					state_reg = 1;
			end
			else
			begin
				if (valid_array[index] && tag == tag_array[index])
				begin
					out_reg = data_array[index];
					state_reg = 1;
				end
				else
				begin		
					if (ram_state)
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
	
endmodule

