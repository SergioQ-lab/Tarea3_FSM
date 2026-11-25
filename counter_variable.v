// --------------------------------------------------------------------
// Universitat Politècnica de València
// Departamento de Ingeniería Electronica
// --------------------------------------------------------------------
// Sistemas Digitales Programables MUISE
// Curso 2026 - 2027
// --------------------------------------------------------------------
// Nombre del archivo: counter_variable.v
//
// Descripción: Contador ascendente de módulo variable (END_COUNT + 1)
// proporcionado para el Apartado 3:
// 1. CLK, Reloj activo por flanco de subida.
// 2. RSTn, Reset asíncrono activo a nivel bajo.
// 3. ENABLE, Habilitación de cuenta.
// 4. END_COUNT, Valor máximo de cuenta (módulo = END_COUNT + 1).
// 5. COUNT, Valor actual de la cuenta.
// 6. TC, Terminal Count activo cuando COUNT == END_COUNT y ENABLE == 1.
//
// --------------------------------------------------------------------
// Versión: V1.0 | Fecha Modificación: 25/11/2026
//
// Autor(es): Sergio Quesada Moreno y Pablo Ruíz López
// Ordenador de trabajo: DISE02
//
// --------------------------------------------------------------------

module counter_variable (CLK, RSTn, ENABLE, END_COUNT, COUNT, TC);

    parameter width = 4;

    input CLK, RSTn, ENABLE;
    input [width-1:0] END_COUNT;
    output reg [width-1:0] COUNT;
    output TC;

    always @(posedge CLK or negedge RSTn)
        if (~RSTn)
            COUNT <= 0;
        else if (ENABLE)
        begin
            if (COUNT >= END_COUNT)
                COUNT <= 0;
            else
                COUNT <= COUNT + 1;
        end

    assign TC = ((COUNT == END_COUNT) && (ENABLE == 1)) ? 1 : 0;

endmodule
