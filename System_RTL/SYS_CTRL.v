module SYS_CTRL (
 input wire                                                 CLK,RST,RX_D_Valid,OUT_Valid,RdData_Valid,Busy,
 input wire                    [7:0]                       RX_P_DATA,RdData,
 input wire                    [15:0]                     ALU_OUT,
 output wire                                               ALU_EN,CLK_G_EN,WrEn,RdEn,TX_D_Valid,clk_div_en,
 output wire                   [3:0]                      ALU_FUN,Addr,
 output wire                   [7:0]                      WrData,
 output wire                   [15:0]                     TX_P_DATA
);

CTRL_RX U_CRX (
.CLK(CLK),
.RST(RST),
.RX_D_Valid(RX_D_Valid),
.RX_P_DATA(RX_P_DATA),
.ALU_EN(ALU_EN),
.CLK_G_EN(CLK_G_EN),
.WrEn(WrEn),
.RdEn(RdEn),
.ALU_FUN(ALU_FUN),
.Addr(Addr),
.WrData(WrData),
.Busy(Busy)
);

CTRL_TX U_CTX (
.CLK(CLK),
.RST(RST),
.OUT_Valid(OUT_Valid),
.RdData_Valid(RdData_Valid),
.Busy(Busy),
.RdData(RdData),
.ALU_OUT(ALU_OUT),
.TX_P_DATA(TX_P_DATA),
.TX_D_Valid(TX_D_Valid),
.clk_div_en(clk_div_en)
);

endmodule