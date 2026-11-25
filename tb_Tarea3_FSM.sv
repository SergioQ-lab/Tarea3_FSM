// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: tb_Tarea3_FSM.sv
//
// Descripción: Testbench estructurado mediante tasks y temporización por
// flancos para verificar el diseño completo del Apartado 3 (Tarea3_FSM):
// 1. CLOCK_50, Reloj de 50 MHz (periodo 20 ns).
// 2. SW[0], Señal de habilitación del movimiento de luces.
// 3. KEY[2:0], Pulsadores activos a nivel bajo (reset, subir, bajar).
// 4. LEDG[7:0], Secuencia de luces verdes.
// 5. LEDR[7:0], Estado de counter_variable (7:4) y velocidad (3:0).
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

`timescale 1ns/1ps

module tb_Tarea3_FSM;

    localparam int T = 20;
    localparam int FIN_CUENTA_SIM = 4;

    logic       CLOCK_50;
    logic [0:0] SW;
    logic [2:0] KEY;
    logic [7:0] LEDG;
    logic [7:0] LEDR;

    // Instancia del diseño completo con fin_cuenta reducido para simulación
    Tarea3_FSM #(
        .fin_cuenta(FIN_CUENTA_SIM),
        .fin_cuenta_vel(16)
    ) DUT (
        .CLOCK_50 (CLOCK_50),
        .SW       (SW),
        .KEY      (KEY),
        .LEDG     (LEDG),
        .LEDR     (LEDR)
    );

    // Reloj de 50 MHz (periodo de 20 ns)
    initial CLOCK_50 = 1'b0;
    always #(T / 2) CLOCK_50 = ~CLOCK_50;

    // Esperar N flancos de subida de reloj
    task automatic wait_cycles(input int n);
        repeat (n) @(posedge CLOCK_50);
    endtask

    // Aplicar reset activo a nivel bajo (KEY[0])
    task automatic apply_reset(input int cycles);
        @(negedge CLOCK_50);
        KEY = 3'b110;
        SW  = 1'b0;
        wait_cycles(cycles);
        @(negedge CLOCK_50);
        KEY[0] = 1'b1;
        wait_cycles(2);
    endtask

    // Cambiar la señal de habilitación SW[0]
    task automatic set_enable(input logic en);
        @(negedge CLOCK_50);
        SW[0] = en;
    endtask

    // Simular una pulsación realista de botón activo a nivel bajo
    // btn_idx: 1 = KEY[1] (sube END_COUNT), 2 = KEY[2] (baja END_COUNT)
    task automatic press_button(input int btn_idx, input int hold_cycles);
        @(negedge CLOCK_50);
        KEY[btn_idx] = 1'b0;
        wait_cycles(hold_cycles);
        @(negedge CLOCK_50);
        KEY[btn_idx] = 1'b1;
        wait_cycles(3);
    endtask

    // Simular pulsación simultánea de KEY[1] y KEY[2]
    task automatic press_both(input int hold_cycles);
        @(negedge CLOCK_50);
        KEY[1] = 1'b0;
        KEY[2] = 1'b0;
        wait_cycles(hold_cycles);
        @(negedge CLOCK_50);
        KEY[1] = 1'b1;
        KEY[2] = 1'b1;
        wait_cycles(3);
    endtask

    initial begin
        $display("INICIO DE SIMULACION tb_Tarea3_FSM (fin_cuenta = %0d)", FIN_CUENTA_SIM);
        $monitor("t=%0t ns | KEY=%b SW=%b | LEDR_var=%0d LEDR_vel=%0d | LEDG=%b",
                 $time, KEY, SW, LEDR[7:4], LEDR[3:0], LEDG);

        // 1. Reset inicial
        apply_reset(4);

        // 2. Habilitar luces a velocidad máxima (END_COUNT = 0 -> módulo 1)
        set_enable(1'b1);
        wait_cycles(FIN_CUENTA_SIM * 5);

        // 3. Reducir velocidad incrementando END_COUNT a 2 (módulo 3 en counter_variable)
        press_button(1, 5);
        press_button(1, 5);
        wait_cycles(FIN_CUENTA_SIM * 3 * 5);

        // 4. Pausar el juego de luces (SW[0] = 0) y comprobar que el control de velocidad sigue funcionando
        set_enable(1'b0);
        wait_cycles(FIN_CUENTA_SIM * 4);
        press_button(1, 4); // END_COUNT pasa a 3 mientras las luces están pausadas
        wait_cycles(FIN_CUENTA_SIM * 2);

        // 5. Reanudar luces y bajar END_COUNT con KEY[2] para acelerar de nuevo
        set_enable(1'b1);
        wait_cycles(FIN_CUENTA_SIM * 4 * 2);
        press_button(2, 5); // END_COUNT = 2
        press_button(2, 5); // END_COUNT = 1
        wait_cycles(FIN_CUENTA_SIM * 2 * 5);

        // 6. Pulsación simultánea de ambos botones (END_COUNT no debe cambiar)
        press_both(5);
        wait_cycles(FIN_CUENTA_SIM * 2 * 2);

        // 7. Reset en mitad de funcionamiento
        apply_reset(3);

        $display("FIN DE SIMULACION tb_Tarea3_FSM");
        $stop;
    end

endmodule
