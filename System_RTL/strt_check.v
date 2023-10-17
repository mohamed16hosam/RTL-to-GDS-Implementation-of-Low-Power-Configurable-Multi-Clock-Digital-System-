module strt_check (
 input wire                                          strt_check_en,CLK,RST,RX_IN,
 input wire         [4:0]                          edge_cnt,prescale,
 output reg                                        strt_glitch 
);

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  strt_glitch<=1'b0 ;
	 else if (strt_check_en)
	  strt_glitch<=((edge_cnt<prescale+1'b1)&(RX_IN)) ;
	 else
	 strt_glitch<=1'b0 ;
 end

endmodule