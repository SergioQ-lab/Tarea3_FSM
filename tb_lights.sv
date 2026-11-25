// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: tb_lights.sv
//
// Descripción: Testbench estructurado mediante tasks y temporización por
// flancos de reloj para verificar el módulo lights (Apartado 1):
// 1. CLK, Reloj generado con periodo de 20 ns (CLOCK_50).
// 2. RST_n, Reset activo a nivel bajo conectado a KEY[0].
// 3. ENABLE, Habilitación de avance conectada a SW[0].
// 4. LEDS, Salida de 8 bits observada en LEDG[7:0].
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

`timescale 1ns/1ps

module tb_lights;

    localparam int T = 20;
    localparam int FIN_CUENTA_SIM = 10;

    logic       CLK;
    logic       RST_n;
    logic       ENABLE;
    logic [7:0] LEDS;

    // Instancia del DUT con fin_cuenta reducido para agilizar la simulación
    lights #(
        .fin_cuenta(FIN_CUENTA_SIM)
    ) DUT (
        .CLOCK_50 (CLK),
        .SW       (ENABLE),
        .KEY      (RST_n),
        .LEDG     (LEDS)
    );

    // Generación de reloj de 50 MHz (periodo 20 ns)
    initial CLK = 1'b0;
    always #(T / 2) CLK = ~CLK;

    // Task para esperar N flancos de subida de reloj
    task automatic wait_cycles(input int n);
        repeat (n) @(posedge CLK);
    endtask

    // Task para aplicar reset activo a nivel bajo (KEY[0])
    task automatic apply_reset(input int cycles);
        @(negedge CLK);
        RST_n  = 1'b0;
        ENABLE = 1'b0;
        wait_cycles(cycles);
        @(negedge CLK);
        RST_n = 1'b1;
        wait_cycles(1);
    endtask

    // Task para habilitar el movimiento durante 'steps' pasos de luz
    task automatic run_lights(input int steps);
        @(negedge CLK);
        ENABLE = 1'b1;
        wait_cycles(steps * FIN_CUENTA_SIM);
    endtask

    // Task para pausar el movimiento durante 'cycles' ciclos de reloj
    task automatic pause_lights(input int cycles);
        @(negedge CLK);
        ENABLE = 1'b0;
        wait_cycles(cycles);
    endtask

    initial begin
        $display("INICIO DE SIMULACION tb_lights (fin_cuenta = %0d)", FIN_CUENTA_SIM);
        $monitor("t=%0t ns | RST_n=%b EN=%b | LEDS=%b", $time, RST_n, ENABLE, LEDS);

        // 1. Reset inicial
        apply_reset(3);

        // 2. Recorrer un ciclo completo de 14 estados (ida y vuelta)
        run_lights(14);

        // 3. Pausar el juego de luces (SW[0] = 0) y comprobar que se mantiene el LED
        pause_lights(FIN_CUENTA_SIM * 2);

        // 4. Reanudar unos pasos más
        run_lights(4);

        // 5. Aplicar reset en mitad de la secuencia
        apply_reset(3);

        $display("FIN DE SIMULACION tb_lights");
        $stop;
    end

endmodule
