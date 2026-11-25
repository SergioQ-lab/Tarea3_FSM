// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: FSM_speed.sv
//
// Descripción: Este código SystemVerilog implementa una máquina de
// estados de Mealy para detectar flancos de bajada en dos pulsadores y
// generar un pulso de control de un ciclo de reloj, con las siguientes
// entradas y salidas:
// 1. CLK, Reloj activo por flanco de subida.
// 2. RSTn, Reset asíncrono activo a nivel bajo.
// 3. KEY_UP, Pulsador activo a nivel bajo para incrementar.
// 4. KEY_DN, Pulsador activo a nivel bajo para decrementar.
// 5. ENABLE, Pulso de habilitación de 1 ciclo al pulsar un botón.
// 6. UP_DOWN, Sentido de cuenta (1 incrementar, 0 decrementar).
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

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
