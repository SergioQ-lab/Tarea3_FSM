// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: contador_param.sv
//
// Descripción: Este código SystemVerilog implementa un contador
// parametrizable ascendente/descendente (parámetro fin_cuenta) con la
// siguiente funcionalidad de sus entradas y salidas:
// 1. clk, Reloj activo por flanco de subida.
// 2. reset, Reset síncrono activo a nivel bajo.
// 3. enable, Habilitación de la cuenta.
// 4. UP_DOWN, Sentido de cuenta (1 ascendente, 0 descendente).
// 5. TC, Terminal Count activo en alto al alcanzar el fin de cuenta.
// 6. cuenta, Valor actual de la cuenta de N bits.
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

module contador_param #(
    parameter int fin_cuenta = 10,
    parameter int N = (fin_cuenta <= 1) ? 1 : $clog2(fin_cuenta)
)(
    input  logic         clk,
    input  logic         reset,
    input  logic         enable,
    input  logic         UP_DOWN,
    output wire         TC,
    output logic [N-1:0] cuenta
);

    // Terminal Count mediante asignacion continua
    assign TC = reset && enable && (
        (UP_DOWN  && (cuenta == fin_cuenta-1)) ||
        (!UP_DOWN && (cuenta == 0))
    );

    // Contador sincrono
    always_ff @(posedge clk) begin

        // Reset sincrono activo a nivel bajo
        if (!reset) begin
            cuenta <= '0;
        end

        else if (enable) begin

            // Cuenta ascendente
            if (UP_DOWN) begin
                if (cuenta == fin_cuenta-1) begin
                    cuenta <= '0;
                end
                else begin
                    cuenta <= cuenta + 1'b1;
                end
            end

            // Cuenta descendente
            else begin
                if (cuenta == 0) begin
                    cuenta <= fin_cuenta-1;
                end
                else begin
                    cuenta <= cuenta - 1'b1;
                end
            end

			
        end

    end

endmodule