module UART_TX_TOP (
 input wire                                    CLK,RST,PAR_TYP,PAR_EN,DATA_VALID,
 input wire           [15:0]                   P_DATA,
 output wire                                  Busy,
 output reg                                   TX_OUT
);

wire                                             ser_en, S_DATA, ser_out,parity_flag ;  
wire                    [1:0]                   select ;

serializer U_ser (
.P_DATA(P_DATA),
.ser_en(ser_en),
.CLK(CLK),
.RST(RST),
.DATA_VALID(DATA_VALID),
.Busy(Busy),
.S_DATA(S_DATA),
.ser_out(ser_out)
);

FSM_TX U_FSM (
.DATA_VALID(DATA_VALID),
.ser_out(ser_out),
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.select(select),
.parity_flag(parity_flag),
.ser_en(ser_en),
.Busy(Busy)
);

parity_calc U_pc (
.P_DATA(P_DATA),
.parity_flag(parity_flag),
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.PAR_TYP(PAR_TYP),
.parity_out(parity_out)
);

always @(*)
 begin
     case(select)
	 2'b00 : TX_OUT=1'b0 ;
	 2'b01 : TX_OUT=S_DATA ;
	 2'b10 : TX_OUT=parity_out ;
	 2'b11 : TX_OUT=1'b1 ;
	 default : TX_OUT=1'b1 ;
	 endcase
 end

endmodule