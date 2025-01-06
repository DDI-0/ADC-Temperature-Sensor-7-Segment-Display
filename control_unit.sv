module control_unit (
    input  logic            clk_adc,       
    input  logic            rst_n,         
    input  logic            eoc,           
    input  logic [7:0]      tail,          
    output logic            soc,           
    output logic            fifo_write_en, 
    output logic [7:0]      head           
);

    typedef enum logic [1:0] {
        Start       = 2'b00,
        Wait	     = 2'b01,
        Transfer    = 2'b10
    } state_e;

    state_e current_state, next_state;

    // Internal Signals
    logic fifo_full;
    logic [7:0] head_reg;

    // Initialization -- fix this
    initial begin
        current_state = Start;
        head_reg      = 8'd0;
        soc           = '0;
        fifo_write_en = '0;
		  fifo_full     = '0;
    end

    // State Transition Logic
    always_ff @(posedge clk_adc or negedge rst_n) 
        if (!rst_n)    current_state <= Start;
        else           current_state <= next_state;

    // Next State Logic - Combinational Logic
    always_comb begin
        next_state = current_state;

        case (current_state)
            Start: begin
                if (!fifo_full) begin
                    next_state = Wait; // Move to WAIT_EOC if FIFO has space
                end
            end

            Wait: begin
					 if (!rst_n) begin
						  next_state = Start;
                end else if (eoc) begin
                    next_state = Transfer; // Move to TRANSFER when ADC conversion is done
                end
            end

            Transfer: begin
                next_state = Start; // After transfer, return to START
            end

            default: begin
                next_state = Start; // Default to START state
            end
        endcase
    end
	 
// Output and Register Update Logic
    always_ff @(posedge clk_adc or negedge rst_n)
        if (!rst_n) begin
            head_reg      <= 8'd0;
            soc           <= '0;
            fifo_write_en <= '0;
        end 
		  else begin
            case (current_state)
                Start: begin
                    soc           <= '1;  // Trigger ADC conversion
                    fifo_write_en <= '0;
                end

                Wait: begin
                    soc           <= '0;  // Wait for ADC conversion to complete
                    fifo_write_en <= '0;
                end

                Transfer: begin
                    soc           <= '0;  // No new ADC trigger
                    fifo_write_en <= '1;  // Write data to FIFO
                    head_reg      <= head_reg + '1; // Increment head pointer
                end

                default: begin
                    soc           <= '0;
                    fifo_write_en <= '0;
                end
            endcase
        end
		  
    always_comb begin
        fifo_full = (head_reg == tail);
	 end  
	 
    assign head = head_reg;

endmodule