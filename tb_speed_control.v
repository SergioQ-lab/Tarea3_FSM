`timescale 1ns/1ps

module tb_speed_control;

    //Entradas
    logic CLK_50;
    logic [2:0] KEY;
	 
	 //Señales internas
	 wire ENABLE;
	 wire UP_DOWN;
	 wire LEDR;
	 
speed_control DUT (

	.CLK_50(CLK_50),
	.KEY(KEY),
	.LEDR(LEDR)
);


		initial begin
		
			CLK = 1'b0;
			KEY = 3'b110;
			
			$display(" INICIO DE SIMULACION");
			
			
			
			
			end
		
//Asignamos un periodo de 20ns de reloj
	always begin
		#10 CLK_50 = ~CLK_50;
	end
		