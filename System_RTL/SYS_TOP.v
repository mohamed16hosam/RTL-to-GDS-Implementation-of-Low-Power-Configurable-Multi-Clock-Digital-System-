module SYS_TOP (
 input wire                                        REF_CLK,UART_CLK,RST,RX_IN,
 output wire                                      TX_OUT,parity_error,framing_error
);

wire                                                      TX_CLK,SYNC_RST_2,RX_D_Valid,OUT_Valid,RdData_Valid,Busy,ALU_EN,CLK_G_EN,WrEn,RdEn,TX_D_Valid ;
wire                                                      SYNC_RST_1,ALU_CLK,parity_enable,parity_type,clk_div_en,TX_enable_data_sync,RX_enable_data_sync ;
wire                                                       Busy_sync ;
wire                            [7:0]                   OP_A,OP_B,RX_P_DATA,WrData,RdData,RX_Data_Sync ;
wire                            [15:0]                  ALU_OUT,TX_P_DATA,TX_Data_Sync ;
wire                            [3:0]                   ALU_FUN,Addr,div_ratio ;
wire                            [4:0]                   Prescale ;

SYS_CTRL U_ctrl (
.CLK(REF_CLK),
.RST(RST),
.RX_D_Valid(RX_enable_data_sync),
.OUT_Valid(OUT_Valid),
.RdData_Valid(RdData_Valid),
.Busy(Busy_sync),
.RX_P_DATA(RX_Data_Sync),
.RdData(RdData),
.ALU_OUT(ALU_OUT),
.ALU_EN(ALU_EN),
.CLK_G_EN(CLK_G_EN),
.WrEn(WrEn),
.RdEn(RdEn),
.TX_D_Valid(TX_D_Valid),
.ALU_FUN(ALU_FUN),
.Addr(Addr),
.WrData(WrData),
.TX_P_DATA(TX_P_DATA),
.clk_div_en(clk_div_en)
);

UART U_uart (
.RST(SYNC_RST_2),
.TX_CLK(TX_CLK),
.RX_CLK(UART_CLK),
.RX_IN_S(RX_IN),
.RX_OUT_P(RX_P_DATA), 
.RX_OUT_V(RX_D_Valid),
.TX_IN_P(TX_Data_Sync), 
.TX_IN_V(TX_enable_data_sync), 
.TX_OUT_S(TX_OUT),
.TX_OUT_V(Busy),  
.Prescale(Prescale),
.parity_enable(parity_enable),
.parity_type(parity_type),
.parity_error(parity_error),
.framing_error(framing_error)
);

ALU U_alu (
.A(OP_A), 
.B(OP_B),
.EN(ALU_EN),
.ALU_FUN(ALU_FUN),
.CLK(ALU_CLK),
.RST(SYNC_RST_1),  
.ALU_OUT(ALU_OUT),
.OUT_VALID(OUT_Valid)  
);

RegFile U_regfile (
.CLK(REF_CLK),
.RST(SYNC_RST_1),
.WrEn(WrEn),
.RdEn(RdEn),
.Address(Addr),
.WrData(WrData),
.RdData(RdData),
.RdData_VLD(RdData_Valid),
.REG0(OP_A),
.REG1(OP_B),
.REG2({Prescale,parity_type,parity_enable}),
.REG3(div_ratio)
);

ClkDiv U_clkdiv (
.i_ref_clk(UART_CLK),           
.i_rst(SYNC_RST_2),              
.i_clk_en(clk_div_en),              
.i_div_ratio(div_ratio),  
.o_div_clk(TX_CLK)  
);

CLK_GATE U_clkgate (
.CLK_EN(CLK_G_EN),
.CLK(REF_CLK),
.GATED_CLK(ALU_CLK)
);

DATA_SYNC #(.bus_width(16)) U0_DS (                                                //for TX
.dest_clk(TX_CLK),
.dest_rst(SYNC_RST_2),
.unsync_bus(TX_P_DATA),
.bus_enable(TX_D_Valid),
.sync_bus(TX_Data_Sync),
.enable_pulse_d(TX_enable_data_sync)
);

DATA_SYNC #(.bus_width(8)) U1_DS (                                                //for ctrl
.dest_clk(REF_CLK),
.dest_rst(SYNC_RST_1),
.unsync_bus(RX_P_DATA),
.bus_enable(RX_D_Valid),
.sync_bus(RX_Data_Sync),
.enable_pulse_d(RX_enable_data_sync)
);

RST_SYNC U0_rstsync (                                        //rst sync 1
.RST(RST),
.CLK(REF_CLK),
.SYNC_RST(SYNC_RST_1)
);

RST_SYNC U1_rstsync (                                        //rst sync 2
.RST(RST),
.CLK(UART_CLK),
.SYNC_RST(SYNC_RST_2)
);

BIT_SYNC U_bitsync (
.dest_clk(REF_CLK),
.dest_rst(SYNC_RST_1),
.unsync_bit(Busy),
.sync_bit(Busy_sync)
);


endmodule