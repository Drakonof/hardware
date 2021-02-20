//Линию задержки нужно использовать без сигналов валидности
//Можно использовать без сигнала сброса
module tick_delay#(
	parameter	DATAWIDTH = 1,
	parameter	DELAY_TICK_NUMBER = 1
)
(
	input			clk,
	input			[DATAWIDTH-1:0]	data_i,
	output logic	[DATAWIDTH-1:0]	data_o
);
//Инициализируем память размером в указанную задержку...или так называемый сдвиговый регистр в нашем случае:
	logic			[DELAY_TICK_NUMBER:0][DATAWIDTH-1:0]	delay_line;
//logic - заменяет reg и wire из verilog, компилятор понимает сам.	
	assign delay_line[0]		= data_i;
//Каждый такт сдвигаем данные в памяти:
	always@(posedge clk)
		delay_line[DELAY_TICK_NUMBER:1] <= delay_line[DELAY_TICK_NUMBER-1:0];
	assign data_o			= (DELAY_TICK_NUMBER==0) ? data_i : delay_line[DELAY_TICK_NUMBER];
endmodule
