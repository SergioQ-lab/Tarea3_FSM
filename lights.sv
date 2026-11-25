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

	//Módulo de 5000000 para conseguir que la señal TC generada tenga una frecuencia de 10 Hz
	parameter int fin_cuenta = 5000000
	
	) (
	
   input  logic        CLOCK_50,
   input  logic [0:0]  SW,
   input  logic [0:0]  KEY,
   output logic [7:0]  LEDG
	
	 
);


	//Señales internas
    logic TC;

    // 1. Instanciar el contador parametrizable
	 
    contador_param #(
        .fin_cuenta(fin_cuenta)
    ) inst_contador (
        .clk     (CLOCK_50),
        .reset   (KEY[0]),
        .enable  (SW[0]),
        .UP_DOWN (1'b1),
        .TC      (TC),
        .cuenta  ()
    );
	 
    // 2. Máquina de estados Medvelev

	FSM_lights FSM_lights_inst (
	
		.CLK(CLOCK_50),
		.RSTn(~KEY[0]),
		.ENABLE(TC),
		.LEDG(LEDG)
	
	
	);

endmodule