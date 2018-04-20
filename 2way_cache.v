 module cache_2way (
	input [31:0] data,
	input [31:0] addr,
	input wr,
	input clk,
	output is_missrate,
	output [31:0] out
);

	parameter size = 64;
	parameter index_size = 5;
	
	reg [31:0] data_array [size-1:0];  // internal storage
	reg valid_array [size-1:0];	
	reg [31-index_size:0] tag_array [size-1:0];
	
	reg [31-index_size:0] tag;  //divide adress on tag and index
	reg [index_size-1:0] set_index;
	reg [31:0] out_data;
	
	wire [31:0] out_ram;
	
	
	reg [31:0] data_ram; //input for RAM
	reg [31:0] addr_ram; //addr for RAM
	reg wr_ram;  
	reg clk_ram;
	wire ram_state; // check whether RAM is end it's work
	
	reg miss_reg;
	reg write_reg; //register for choose, which block rewrite
	reg state_reg;
	//RAM module
	ram ram(
			.data(data_ram),
			.addr(addr_ram),
			.wr(wr_ram),
			.clk(clk),
			.response(ram_state),
			.out(out_ram));
	
	initial
	begin
		write_reg = 0;
		miss_reg = 0;
	end
	
	always @(posedge clk)
	begin
		// set same inputs in RAM
		data_ram = data;
		addr_ram = addr;
		wr_ram = wr;
		//caculating of tag and index
		tag <= addr >> index_size;
		set_index = addr - addr%2;
		
		if (wr)		
		begin
		if (valid_array[set_index*2] && valid_array[set_index*2+1]) // if no free place -> rewrite
				valid_array[set_index*2+write_reg] = 0;
			write_reg = write_reg+1;
			miss_reg = 1;
		end
		else
		
		begin
			//put in free place in cache block
			if (valid_array[set_index*2] && tag == tag_array[set_index*2])
			begin
				out_data = data_array[set_index*2];
				miss_reg = 0;
			end
			else if (valid_array[set_index*2+1] && tag == tag_array[set_index*2+1])
			begin
				out_data = data_array[set_index*2+1];
				miss_reg = 0;
			end
			else if (valid_array[set_index*2]&&!valid_array[set_index*2+1])
			begin
			//take info from RAM
				if (ram_state)
				begin
				data_array[set_index*2+1] = out_ram;
				tag_array[set_index*2+1] = tag;				
				valid_array[set_index*2+1] = 1;
				out_data = out_ram;
				miss_reg = 1;
				end
			end
			else
			begin
			if (ram_state)
			begin
				data_array[set_index*2] = out_ram;
				tag_array[set_index*2] = tag;				
				valid_array[set_index*2] = 1;
				out_data = out_ram;
				miss_reg = 1;
			end
			end
		end
	end	
	
	assign is_missrate = miss_reg;
	assign out = out_data;
	
endmodule