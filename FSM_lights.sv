module FSM_lights (

   input  logic       CLK,
   input  logic       RSTn,
   input  logic       ENABLE,
   output logic [7:0] LEDG
	 
);

   localparam logic [6:0]
		S0  = 7'b0000000,
      S1  = 7'b0000001,
      S2  = 7'b0000011,
      S3  = 7'b0000111,
      S4  = 7'b0001111,
      S5  = 7'b0011111,
      S6  = 7'b0111111,
      S7  = 7'b1111111,
      S8  = 7'b1111110,
      S9  = 7'b1111100,
      S10 = 7'b1111000,
      S11 = 7'b1110000,
      S12 = 7'b1100000,
      S13 = 7'b1000000;

	logic [6:0] state, next_state;
	logic [7:0] next_ledg;

	// Calcula el siguiente estado Johnson.
	always_comb begin
	
		case (state)
			S0:  next_state = S1;
			S1:  next_state = S2;
			S2:  next_state = S3;
			S3:  next_state = S4;
			S4:  next_state = S5;
			S5:  next_state = S6;
			S6:  next_state = S7;
			S7:  next_state = S8;
			S8:  next_state = S9;
			S9:  next_state = S10;
			S10: next_state = S11;
			S11: next_state = S12;
			S12: next_state = S13;
			S13: next_state = S0;
			
			default: next_state = S0;
			
		endcase
		
	end

    // Calcula el patrón que se registrará junto con next_state.
	always_comb begin
	
		case (next_state)
		
			S0:  next_ledg = 8'b10000000;
			S1:  next_ledg = 8'b01000000;
			S2:  next_ledg = 8'b00100000;
			S3:  next_ledg = 8'b00010000;
			S4:  next_ledg = 8'b00001000;
			S5:  next_ledg = 8'b00000100;
			S6:  next_ledg = 8'b00000010;
			S7:  next_ledg = 8'b00000001;
			S8:  next_ledg = 8'b00000010;
			S9:  next_ledg = 8'b00000100;
			S10: next_ledg = 8'b00001000;
			S11: next_ledg = 8'b00010000;
			S12: next_ledg = 8'b00100000;
			S13: next_ledg = 8'b01000000;
			
			default: next_ledg = 8'b0000_0000;
			
		endcase
	end

    // El código Johnson y la salida forman el estado registrado.
	always_ff @(posedge CLK or negedge RSTn) begin
	
		if (!RSTn) begin
		
			state <= S0;
			LEDG  <= 8'b10000000;
			
		end else if (ENABLE) begin
		
			state <= next_state;
			LEDG  <= next_ledg;
			
		end
		
	end

endmodule
