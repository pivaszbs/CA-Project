 module cache_2way (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output miss,
	output [31:0] q
);

	reg [31:0] data_array [3:0];  // internal storage
	reg valid_array [3:0];	
	reg [29:0] tag_array [3:0];
	
	reg [29:0] tag;  //divide adress on tag and index
	reg [1:0] set_index;
	reg [31:0] out_data;
	
	reg enable_reg;	
	wire enable;
	wire [31:0] out;
	
	
	reg [31:0] data_ram; //input for RAM
	reg [31:0] addr_ram; //addr for RAM
	reg wr_ram;  
	reg clk_ram;
	wire ram_state; // check whether RAM is end it's work
	
	reg miss_reg;
	reg write_reg; //register for choose, which block rewrite
	reg state_reg;
	//RAM module
	simple_ram simple_ram(
			.data(data_ram),
			.addr(addr_ram),
			.wr(wr_ram),
			.clk(clk_ram),
			.enable(enable),
			.state(ram_state),
			.q(out));
	
	initial
	begin
		clk_ram = 1'b1;
		write_reg = 0;
	end
	
	always #50 clk_ram = ~clk_ram;
	
	always @(posedge clk)
	begin
		// set same inputs in RAM
		data_ram <= data;
		addr_ram <= addr;
		wr_ram <= wr;
		tag <= addr << 2;
		set_index <= addr - addr % 2;
		
		enable_reg <= 0;
		
		if (wr)		
		begin
		if (valid_array[set_index*2] && valid_array[set_index*2+1]) // if no free place -> rewrite
				valid_array[set_index*2+write_reg] <= 0;
			enable_reg <= 1;
			write_reg <= write_reg+1;
			miss_reg <= 1;
		end
		else
		
		begin
			if (valid_array[set_index*2] && tag == tag_array[set_index*2])
			begin
				out_data <= data_array[set_index*2];
				miss_reg <= 0;
			end
			else if (valid_array[set_index*2+1] && tag == tag_array[set_index*2+1])
			begin
				out_data <= data_array[set_index*2+1];
				miss_reg <= 0;
			end
			else if (valid_array[set_index*2]&&!valid_array[set_index*2+1])
			begin
				if (ram_state)
				begin
				enable_reg = 1;
				data_array[set_index*2+1] <= out;
				tag_array[set_index*2+1] <= tag;				
				valid_array[set_index*2+1] <= 1;
				out_data <= out;
				miss_reg <= 1;
				end
			end
			else
			begin
			if (ram_state)
			begin
				enable_reg = 1;
				data_array[set_index*2] <= out;
				tag_array[set_index*2] <= tag;				
				valid_array[set_index*2] <= 1;
				out_data <= out;
				miss_reg <= 1;
			end
			end
		end
	end	
	
	assign miss = miss_reg;
	assign enable = enable_reg;
	assign q = out_data;
	
endmodule