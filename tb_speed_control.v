// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: tb_speed_control.v
//
// Descripción: Testbench en Verilog/SystemVerilog para verificar el
// funcionamiento del módulo speed_control en simulación:
// 1. CLK_50, Señal de reloj generada con periodo de 20 ns (50 MHz).
// 2. KEY, Estímulos de los pulsadores de reset, subida y bajada.
// 3. LEDR, Salida observada del contador de 4 bits.
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

`timescale 1ns/1ps

module tb_speed_control;

    localparam CLK_PERIOD = 20;

    // Entradas
    reg CLK_50;
    reg [2:0] KEY;

    // Salidas
    wire [3:0] LEDR;

    // Instancia del diseño bajo prueba (DUT)
    speed_control #(
        .fin_cuenta(16)
    ) DUT (
        .CLOCK_50 (CLK_50),
        .KEY      (KEY),
        .LEDR     (LEDR)
    );

    // Reloj de 50 MHz (periodo de 20 ns)
    initial CLK_50 = 1'b0;
    always #(CLK_PERIOD / 2) CLK_50 = ~CLK_50;

    // Task para esperar N ciclos de reloj
    task automatic wait_cycles(input integer n);
        begin
            repeat (n) @(posedge CLK_50);
        end
    endtask

    // Task para aplicar reset activo a nivel bajo (KEY[0])
    task automatic apply_reset(input integer cycles);
        begin
            KEY[0] = 1'b0;
            KEY[1] = 1'b1;
            KEY[2] = 1'b1;
            wait_cycles(cycles);
            KEY[0] = 1'b1;
            wait_cycles(2);
        end
    endtask

    // Task para simular una pulsación realista de botón activo a nivel bajo
    // btn_idx: 1 = KEY_UP (KEY[1]), 2 = KEY_DN (KEY[2])
    task automatic press_button(input integer btn_idx, input integer hold_cycles);
        begin
            @(negedge CLK_50);
            KEY[btn_idx] = 1'b0;
            wait_cycles(hold_cycles);
            @(negedge CLK_50);
            KEY[btn_idx] = 1'b1;
            wait_cycles(3);
        end
    endtask

    // Task para simular pulsación simultánea de ambos botones
    task automatic press_both(input integer hold_cycles);
        begin
            @(negedge CLK_50);
            KEY[1] = 1'b0;
            KEY[2] = 1'b0;
            wait_cycles(hold_cycles);
            @(negedge CLK_50);
            KEY[1] = 1'b1;
            KEY[2] = 1'b1;
            wait_cycles(3);
        end
    endtask

    initial begin
        $display("INICIO DE SIMULACION tb_speed_control");
        $monitor("t=%0t ns | KEY=%b | LEDR=%0d (%b)", $time, KEY, LEDR, LEDR);

        // 1. Reset inicial
        apply_reset(4);

        // 2. Pulsaciones realistas de incremento (KEY_UP = KEY[1])
        // Mantenemos pulsado varios ciclos para comprobar que solo cuenta 1 vez por pulsación
        repeat (4) begin
            press_button(1, 5);
        end

        // 3. Pulsaciones de decremento (KEY_DN = KEY[2]) incluyendo paso por 0 -> 15
        repeat (6) begin
            press_button(2, 6);
        end

        // 4. Pulsación simultánea de ambos botones (no debe variar la cuenta)
        press_both(5);

        // 5. Incrementar hasta comprobar desbordamiento 15 -> 0
        repeat (4) begin
            press_button(1, 4);
        end

        // 6. Reset en mitad de funcionamiento
        apply_reset(3);

        $display("FIN DE SIMULACION tb_speed_control (LEDR = %0d)", LEDR);
        $stop;
    end

endmodule
		