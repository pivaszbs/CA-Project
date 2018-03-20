module simple_cash (
	input [31:0] data,
	input [31:0] address,
	input is_write,
	input clock,
	output [31:0] output_data
);

	reg [31:0] memory [31:0];
	reg [31:0] data_address;	
	
	always @(posedge clock)
	begin
		if (is_write)
		begin
			memory[address] <= data;
			simple_ram ram_memory(data, address, 1, clock, output_data);
		end
		else
		begin			
			if (address[0] == 1)			
			begin
				simple_ram ram_memory(data, address, 0, clock, output_data);
				memory[address] <= output_data
				address[0] <= 1'b1;
			end
			data_address <= address;			
		end
	end
	
	assign output_data = memory[data_address];
	
endmodule

