module FSM_speed (

	input logic CLK,
	input logic RSTn,
	input logic KEY_UP,
	input logic KEY_DN,
	
	output logic ENABLE,
	output logic UP_DOWN
	
);

	logic [1:0] state;
	logic ENABLE_UP, ENABLE_DOWN;


    // Registro de estado
    always_ff @(posedge CLK or negedge RSTn) begin
	 
        if (!RSTn)
		  
            state <= 2'b11; //11 Porque es a nivel bajo cuando se activan
				
        else
		  
            state <= {KEY_UP, KEY_DN};
				
    end

	 // Se produce un pulso en ENABLE cuando el estado anterior del botón KEY_UP era alto
	 // y cuando el estado actual es 0 (activo a nivel bajo). De esta manera no se mantiene
	 // ENABLE en nivel alto cuando el botón sigue pulsado.
	 assign ENABLE_UP = state[1] && !KEY_UP;
	 
	 // Se produce un pulso en ENABLE cuando el estado anterior del botón KEY_UP era alto
	 // y cuando el estado actual es 0 (activo a nivel bajo)
	 assign ENABLE_DOWN = state[0] && !KEY_DN;
	 
	 // En el caso de que ambos sen pulsados al mismo tiempo hemos configurado ENABLE para 
	 // que se active solo cuando los dos bits sean distintos
	 assign ENABLE  = ENABLE_UP ^ ENABLE_DOWN;
	 
	 // Coincide que la salida UP_DOWN está a nivel alto solo cuando se produce 
	 // un flanco de bajada
	 assign UP_DOWN = ENABLE_UP;
	 
	 
endmodule
