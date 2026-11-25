// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: speed_control.sv
//
// Descripción: Este código SystemVerilog integra la FSM de control de
// velocidad (FSM_speed) y un contador módulo 16 (contador_param) para el
// Apartado 2, con las siguientes entradas y salidas:
// 1. CLOCK_50, Reloj principal de 50 MHz activo por flanco de subida.
// 2. KEY, Pulsadores activos a nivel bajo (KEY[0] reset, KEY[1] subir,
//    KEY[2] bajar).
// 3. LEDR, Salida de 4 bits con el valor de la cuenta en binario.
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

module speed_control #(

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
        .reset   (KEY[0]),
        .enable  (ENABLE),
        .UP_DOWN (UP_DOWN),
        .TC      (),
        .cuenta  (LEDR)
    );
	 
    // 2. Máquina de estados de Mealy

	FSM_speed FSM_speed_inst (
		.CLK(CLOCK_50),
		.RSTn(KEY[0]),
		.KEY_UP(KEY[1]),
		.KEY_DN(KEY[2]),
		.ENABLE(ENABLE),
		.UP_DOWN(UP_DOWN)
	);

endmodule