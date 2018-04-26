module test_2
(
	input [6:0] addr,
	input [1:0] data,
	input write_mode,
	input switch,
	input clk,
	output [6:0] out_addr,
	output [1:0] out_data,
	output out_write_mode,
	output [7:0] first_bit,
	output [7:0] second_bit
);

wire [31:0] addr_wire;
wire [31:0] data_wire;
wire response_wire;
wire [31:0] out_wire;
wire is_missrate_wire;

reg [7:0] first_bit_reg;
reg [7:0] second_bit_reg;

reg [31:0] addr_reg;
reg [31:0] data_reg;
reg write_mode_reg;

//reg clk;

initial
begin
//	clk = 0;
	data_reg = 32'b0;
	addr_reg = 32'b0;
	write_mode_reg = 0;
end

cache_4way cache_4way(.data(data_reg), .addr(addr_reg), .wr(write_mode_reg), .clk(clk),
		.response(response_wire), .is_missrate(is_missrate_wire), .out(out_wire));

always@(negedge clk)
begin
	if (~switch)
	begin
		data_reg = data;
		addr_reg = addr;
		write_mode_reg = write_mode;
		case (out_wire[1])
			1'b0:
				begin
					first_bit_reg[0] = 1'b0;
					first_bit_reg[1] = 1'b0;
					first_bit_reg[2] = 1'b0;
					first_bit_reg[3] = 1'b0;
					first_bit_reg[4] = 1'b0;
					first_bit_reg[5] = 1'b0;
					first_bit_reg[6] = 1'b1;
					first_bit_reg[7] = 1'b1;
				end
			1'b1:
				begin
					first_bit_reg[0] = 1'b1;
					first_bit_reg[1] = 1'b0;
					first_bit_reg[2] = 1'b0;
					first_bit_reg[3] = 1'b1;
					first_bit_reg[4] = 1'b1;
					first_bit_reg[5] = 1'b1;
					first_bit_reg[6] = 1'b1;
					first_bit_reg[7] = 1'b1;
				end
			default:
				begin
					first_bit_reg[0] = 1'b0;
					first_bit_reg[1] = 1'b0;
					first_bit_reg[2] = 1'b0;
					first_bit_reg[3] = 1'b0;
					first_bit_reg[4] = 1'b1;
					first_bit_reg[5] = 1'b1;
					first_bit_reg[6] = 1'b1;
					first_bit_reg[7] = 1'b1;
				end
		endcase

		case (out_wire[0])
			1'b0:
				begin
					second_bit_reg[0] = 1'b0;
					second_bit_reg[1] = 1'b0;
					second_bit_reg[2] = 1'b0;
					second_bit_reg[3] = 1'b0;
					second_bit_reg[4] = 1'b0;
					second_bit_reg[5] = 1'b0;
					second_bit_reg[6] = 1'b1;
					second_bit_reg[7] = ~is_missrate_wire;
				end
			1'b1:
				begin
					second_bit_reg[0] = 1'b1;
					second_bit_reg[1] = 1'b0;
					second_bit_reg[2] = 1'b0;
					second_bit_reg[3] = 1'b1;
					second_bit_reg[4] = 1'b1;
					second_bit_reg[5] = 1'b1;
					second_bit_reg[6] = 1'b1;
					second_bit_reg[7] = ~is_missrate_wire;
				end
			default:
				begin
					second_bit_reg[0] = 1'b0;
					second_bit_reg[1] = 1'b0;
					second_bit_reg[2] = 1'b0;
					second_bit_reg[3] = 1'b0;
					second_bit_reg[4] = 1'b1;
					second_bit_reg[5] = 1'b1;
					second_bit_reg[6] = 1'b1;
					second_bit_reg[7] = 1'b1;
				end
		endcase
	end
end

//always
//begin
//	#20000;
//	clk = ~clk;
//end
	
assign out_data = data;
assign out_addr = addr;
assign out_write_mode = write_mode;
assign first_bit = first_bit_reg;
assign second_bit = second_bit_reg;
	
endmodule 