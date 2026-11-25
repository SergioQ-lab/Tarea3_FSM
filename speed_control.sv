// -------------------------------------------------------------------
// Universitat Politècnica de València 
// Departamento de Ingeniería Electronica 
// -------------------------------------------------------------------
// Sistemas Digitales Programables MUISE 
// Curso 2026 - 2027 
// -------------------------------------------------------------------
// Nombre del archivo: 
// -------------------------------------------------------------------
//   Versión: V1.0 | Fecha Modificación: 03/12/2026 
// 
//   Autor(es): Pablo Ruiz López y Sergio Quesada Moreno 
//   Ordenador de trabajo: DISE01 // 
// --------------------------------------------------------------------

module lights #(

	//Módulo de 16
	parameter int fin_cuenta = 16
	
	) (
	
   input  logic        CLOCK_50,
   input  logic [2:0]  KEY,
	
   output logic [3:0]  LEDR	
	 
);


	//Señales internas
    logic ENABLE;
	 logic UP_DOWN;

    // 1. Contador parametrizable
	 
    contador_param #(
	 
        .fin_cuenta(fin_cuenta)
		  
    ) inst_contador (
        .clk     (CLOCK_50),
        .reset   (~KEY[0]),
        .enable  (ENABLE),
        .UP_DOWN (UP_DOWN),
        .TC      (TC),
        .cuenta  (LEDR)
    );
	 
    // 2. Máquina de estados de Mealy

	FSM_speed FSM_speed_inst (
	
		.CLK(CLOCK_50),
		.RSTn(~KEY[0]),
		.KEY_UP(KEY[1]),
		.KEY_DN(KEY[2]),
		.ENABLE(ENABLE),
		.UP_DOWN(UP_DOWN)
	
	
	);

endmodule