module UART_RX_TOP (
 input wire                                             CLK,RST,PAR_TYP,PAR_EN,RX_IN,
 input wire                  [4:0]                    prescale,
 output wire                [7:0]                    P_DATA,
 output wire                                           data_valid,PAR_ERR,framing_err
);

wire                samp_en,sampled_bit,counter_en,new_start,deser_en,par_check_en,par_calc_en,strt_check_en,strt_glitch,stp_check_en ;
wire    [4:0]     edge_cnt ;
wire    [3:0]     bit_cnt ;

data_sampling U_dsamp (
.RX_IN(RX_IN),
.CLK(CLK),
.RST(RST),
.samp_en(samp_en),
.prescale(prescale),
.edge_cnt(edge_cnt),
.sampled_bit(sampled_bit)
);

edge_bit_counter U_bitcount (
.CLK(CLK),
.RST(RST),
.counter_en(counter_en),
.new_start(new_start),
.prescale(prescale),
.edge_cnt(edge_cnt),
.bit_cnt(bit_cnt)
);

deserializer U_des (
.sampled_bit(sampled_bit),
.deser_en(deser_en),
.CLK(CLK),
.RST(RST),
.P_DATA(P_DATA)
);

parity_check U_pc (
.sampled_bit(sampled_bit),
.par_check_en(par_check_en),
.PAR_TYP(PAR_TYP),
.CLK(CLK),
.RST(RST),
.par_en(par_calc_en),
.edge_cnt(edge_cnt),
.prescale(prescale),
.bit_cnt(bit_cnt),
.par_err(PAR_ERR)
);

strt_check U_stchck (
.strt_check_en(strt_check_en),
.strt_glitch(strt_glitch),
.CLK(CLK),
.RST(RST),
.RX_IN(RX_IN),
.edge_cnt(edge_cnt),
.prescale(prescale)
);

Stop_check U_stpchck (
.sampled_bit(sampled_bit),
.stp_check_en(stp_check_en),
.stp_err(framing_err)
);

FSM_RX U_fsm (
.RX_IN(RX_IN),
.CLK(CLK),
.RST(RST),
.PAR_EN(PAR_EN),
.par_err(PAR_ERR),
.strt_glitch(strt_glitch),
.stp_err(framing_err),
.edge_cnt(edge_cnt),
.prescale(prescale),
.bit_cnt(bit_cnt),
.samp_en(samp_en),
.counter_en(counter_en),
.deser_en(deser_en),
.par_calc_en(par_calc_en),
.par_check_en(par_check_en),
.strt_check_en(strt_check_en),
.stp_check_en(stp_check_en),
.data_valid(data_valid),
.new_start(new_start)
);

endmodule