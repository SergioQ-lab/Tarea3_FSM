// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: Tarea3_FSM.sv
//
// Descripción: Módulo top del Apartado 3 que integra el juego de luces
// mediante FSM (Apartado 1), el control de velocidad (Apartado 2) y el
// divisor de frecuencia variable (counter_variable):
// 1. CLOCK_50, Reloj principal de 50 MHz activo por flanco de subida.
// 2. SW, Interruptor SW[0] de habilitación del movimiento de luces.
// 3. KEY, Pulsadores activos a nivel bajo (KEY[0] reset, KEY[1] subir
//    END_COUNT / reducir velocidad, KEY[2] bajar END_COUNT / aumentar
//    velocidad).
// 4. LEDG, Salida de 8 bits del patrón de luces (LEDs verdes).
// 5. LEDR, Salida de 8 bits: LEDR[7:4] cuenta del divisor variable y
//    LEDR[3:0] valor de END_COUNT (control de velocidad).
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

module Tarea3_FSM #(
    // Módulo del divisor fijo: 5000000 -> TC a 10 Hz con CLOCK_50 de 50 MHz
    parameter int fin_cuenta     = 5000000,
    // Módulo del contador de velocidad (valores 0..15 para END_COUNT)
    parameter int fin_cuenta_vel = 16
) (
    input  logic       CLOCK_50,
    input  logic [0:0] SW,
    input  logic [2:0] KEY,
    output logic [7:0] LEDG,
    output logic [7:0] LEDR
);

    // Señales internas de interconexión
    logic tc_div_fijo;
    logic tc_div_var;
    logic en_speed;
    logic up_down_speed;

    // 1. Divisor de frecuencia fijo (Apartado 1)
    contador_param #(
        .fin_cuenta(fin_cuenta)
    ) inst_div_fijo (
        .clk     (CLOCK_50),
        .reset   (KEY[0]),
        .enable  (SW[0]),
        .UP_DOWN (1'b1),
        .TC      (tc_div_fijo),
        .cuenta  ()
    );

    // 2. Divisor de frecuencia de módulo variable (Apartado 3)
    counter_variable #(
        .width(4)
    ) inst_div_variable (
        .CLK       (CLOCK_50),
        .RSTn      (KEY[0]),
        .ENABLE    (tc_div_fijo),
        .END_COUNT (LEDR[3:0]),
        .COUNT     (LEDR[7:4]),
        .TC        (tc_div_var)
    );

    // 3. Máquina de estados de Moore (Medvedev) para el juego de luces
    FSM_lights inst_fsm_lights (
        .CLK    (CLOCK_50),
        .RSTn   (KEY[0]),
        .ENABLE (tc_div_var),
        .LEDG   (LEDG)
    );

    // 4. Máquina de estados de Mealy para lectura de pulsadores de velocidad
    FSM_speed inst_fsm_speed (
        .CLK     (CLOCK_50),
        .RSTn    (KEY[0]),
        .KEY_UP  (KEY[1]),
        .KEY_DN  (KEY[2]),
        .ENABLE  (en_speed),
        .UP_DOWN (up_down_speed)
    );

    // 5. Contador módulo 16 para ajustar END_COUNT (Apartado 2)
    contador_param #(
        .fin_cuenta(fin_cuenta_vel)
    ) inst_vel_counter (
        .clk     (CLOCK_50),
        .reset   (KEY[0]),
        .enable  (en_speed),
        .UP_DOWN (up_down_speed),
        .TC      (),
        .cuenta  (LEDR[3:0])
    );

endmodule
