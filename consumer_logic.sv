module consumer_logic(
	input  logic       clk_consumer,
	input  logic       rst_n,
	input  logic[11:0] fifo_data,
	input  logic       fifo_empty,
	output logic       fifo_read_en
);

	logic read_en = '0;
	
 always_ff @(posedge clk_consumer or negedge rst_n) begin /// is this the correct sequential order 
		if(!rst_n)           read_en <= '0;
		else if(!fifo_empty) read_en <= '1;
		else                read_en <= '1;
		
 end 
		assign fifo_read_en = read_en;
endmodule
	
		
 