// -------------------------------------------------------------------
// Universitat Politècnica de València 
// Departamento de Ingeniería Electronica 
// -------------------------------------------------------------------
// Sistemas Digitales Programables MUISE 
// Curso 2026 - 2027 
// -------------------------------------------------------------------
// Nombre del archivo: contador_param.v 
// 
// Descripción: 
// -------------------------------------------------------------------
//   Versión: V1.0 | Fecha Modificación: 12/10/2026 
// 
//   Autor(es): Pablo Ruiz López y Sergio Quesada Moreno 
//   Ordenador de trabajo: DISE01 // 
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