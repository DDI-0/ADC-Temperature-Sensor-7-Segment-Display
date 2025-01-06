module max10_adc (
    input  logic         pll_clk,  
    input  logic [4:0]   chsel,    // 4-bit channel select (range: 0 -> 31)
    input  logic         soc,      // Start of conversion
    input  logic         tsen,     // Temperature sensor enable
    output logic [11:0]  dout,     // 4-bit digital output
    output logic         eoc,      // End of conversion signal
    output logic         clk_dft   // Clock for DFT (not clear from context)
);	
	logic [11:0] adc_dout;
	logic [4:0] adc_chsel;
	
	assign dout = adc_dout;
	assign adc_chsel = chsel;
	
	
    fiftyfivenm_adcblock_primitive_wrapper #( 
        .clkdiv(2),                               
        .tsclkdiv(1),
        .tsclksel(1),
        .prescalar(0),
        .refsel(0),
        .device_partname_fivechar_prefix("10M50"),
        .is_this_first_or_second_adc(1),
        .analog_input_pin_mask(17'h0), // ?
		  .hard_pwd(0)
    ) adc_inst (
        .clkin_from_pll_c0(pll_clk),              // Input clock
        .chsel(adc_chsel),                            // Channel select
        .soc(soc),                                // Start of conversion
        .usr_pwd(1'b0),                           // User power down // singlebit
        .tsen(tsen),                              // Temperature sensing mode
        .clkout_adccore(clk_dft),                  // Scaled clock output
        .eoc(eoc),                                // End of conversion signal
        .dout(adc_dout)                               // ADC data output
    );

endmodule