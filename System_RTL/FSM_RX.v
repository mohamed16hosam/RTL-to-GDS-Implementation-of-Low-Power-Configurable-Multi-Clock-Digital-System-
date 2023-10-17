module FSM_RX (
 input wire                                      RX_IN,CLK,RST,PAR_EN,par_err,strt_glitch,stp_err,
 input wire             [4:0]                  edge_cnt,prescale,
 input wire             [3:0]                  bit_cnt,
 output reg                                     samp_en,counter_en,deser_en,par_calc_en,par_check_en,strt_check_en,stp_check_en,data_valid,new_start
);

localparam   IDLE=3'b0 ,
                   START=3'b1 ,
				   DATA=3'b11 ,
				   PARITY=3'b10 ,
				   STOP=3'b110;

reg                     [2:0]                           current_state,next_state ;

always @(posedge CLK or negedge RST)
 begin
     if (!RST)
      current_state<=IDLE ;	     
	 else
	  current_state<=next_state ;
 end
 
always @(*)
 begin
     samp_en=1'b0 ;
	 new_start=1'b0 ;
	 counter_en=1'b0 ;
	 deser_en=1'b0 ;
	 par_calc_en=1'b0 ;
	 par_check_en=1'b0 ;
	 strt_check_en=1'b0 ;
	 stp_check_en=1'b0 ;
	 data_valid=1'b0 ;
	// end_signal=1'b0 ;
	 
     case(current_state)
	     IDLE : begin
				     samp_en=1'b0 ;
					 //end_signal=(bit_cnt==4'b1100) ;
                     par_calc_en=1'b0 ;
                     par_check_en=1'b0 ;
					 //counter_en=1'b0 ;
					 deser_en=1'b0 ;
					 stp_check_en=1'b0 ;
				     data_valid=1'b0 ;

		             if (RX_IN)
				      begin
					     next_state=IDLE ;
						 new_start=1'b0 ;
						 strt_check_en=1'b0 ;
						 counter_en=1'b0 ;
					  end
					  
					 else 
					  begin
				         next_state=START ;
						 new_start=1'b1 ;
						 strt_check_en=1'b1 ;
						 counter_en=1'b1 ;
				      end
					  
				  end
		 START : begin
		                 if(strt_glitch)
						  next_state=IDLE ;
						 else	if(bit_cnt==4'b10)
						  next_state=DATA ;
						 else
						  next_state=START ;
						  
                         samp_en=1'b1 ;
                         new_start=(edge_cnt<5'b10) ;						 
                         counter_en=1'b1 ;
						 par_calc_en=1'b1 ;
						 par_check_en=1'b0 ;
						 stp_check_en=1'b0 ;
						 strt_check_en=1'b1 ;
                         deser_en=(edge_cnt==prescale+1'b1) ;						  
					 end
		 DATA : begin
					     deser_en=(edge_cnt==prescale+1'b1) ;
						 par_calc_en=1'b1 ;
						 new_start=1'b0 ;
						 par_check_en=1'b0 ;
					     samp_en=1'b1 ;
						 stp_check_en=1'b0 ;
						 strt_check_en=1'b0 ;
					     counter_en=1'b1 ;
		                 if((bit_cnt==4'b1010) & (PAR_EN==1'b1))
					      next_state=PARITY ;
					     else if ((bit_cnt==4'b1010) & (PAR_EN==1'b0))
					      next_state=STOP ;
					     else
					      next_state=DATA ;
				   end
		 PARITY : begin
		                 samp_en=1'b1 ;
						 new_start=1'b0 ;
						 counter_en=1'b1 ;
						 stp_check_en=1'b0 ;
					     par_calc_en=(edge_cnt<=5'b1) ;
						 //par_check_en=(edge_cnt>5'b1) ;
						 par_check_en=1'b0 ;
						 strt_check_en=1'b0 ;
					     deser_en=1'b0 ;
						 if(bit_cnt==4'b1011)
						  begin
						     next_state=STOP ;
					         par_check_en=1'b1 ;							 
						  end
						 else
						  next_state=PARITY ;
					  end
		 STOP : begin
	                 deser_en=1'b0 ;
	                 stp_check_en=(edge_cnt==prescale+1'b1) ;
	                 data_valid=((~(strt_glitch|par_err|stp_err))&(bit_cnt==4'b1100)&(edge_cnt==prescale+1'b1)) ;
	                 //end_signal=(bit_cnt==4'b1100) ;
					 new_start=1'b0 ;
					 par_calc_en=1'b0 ;
                     new_start=1'b0 ;					 
					 counter_en=(bit_cnt<4'b1100) ;
					 samp_en=1'b1 ;
					 //par_check_en=(bit_cnt==4'b1011)&(edge_cnt==prescale+1'b1) ;
					 //par_check_en=(bit_cnt==4'b1100)&(edge_cnt==prescale+1'b1) ;
					 strt_check_en=1'b0 ;
					 if((bit_cnt==4'b1100)&(edge_cnt==prescale+1'b1))
				      begin
						 if(RX_IN)
						  next_state=IDLE ;
						 else
						  next_state=START ;
				      end
					  
					 else
					     next_state=STOP ;
				   end
		 default : begin
		                 samp_en=1'b0 ;
	                     counter_en=1'b0 ;
	                     deser_en=1'b0 ;
	                     par_calc_en=1'b0 ;
	                     par_check_en=1'b0 ;
	                     strt_check_en=1'b0 ;
	                     stp_check_en=1'b0 ;
	                     data_valid=1'b0 ;
	                     new_start=1'b0 ;
						 next_state=IDLE ;
					  end
	 endcase
	 
 end
 
endmodule