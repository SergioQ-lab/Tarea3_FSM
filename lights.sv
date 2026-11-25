// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: lights.sv
//
// Descripción: Este código SystemVerilog integra el divisor de
// frecuencia (contador_param) y la FSM de luces (FSM_lights) para el
// Apartado 1, con las siguientes entradas y salidas:
// 1. CLOCK_50, Reloj principal de 50 MHz activo por flanco de subida.
// 2. SW, Interruptor SW[0] de habilitación del movimiento de luces.
// 3. KEY, Pulsador KEY[0] de reset.
// 4. LEDG, Salida de 8 bits conectada a los LEDs verdes.
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
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
		.RSTn(KEY[0]),
		.ENABLE(TC),
		.LEDG(LEDG)
	
	
	);

endmodule