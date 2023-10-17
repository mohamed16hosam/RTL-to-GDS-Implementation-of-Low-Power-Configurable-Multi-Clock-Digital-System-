module FSM_TX (
 input wire                                     DATA_VALID,ser_out,CLK,RST,PAR_EN,
 output reg           [1:0]                   select,
 output reg                                    parity_flag,ser_en,Busy
);

reg                       [2:0]                  current_state, next_state ;

localparam IDLE=3'b000  ,
                 STR=3'b001   ,
				 DATA=3'b011 ,
				 P=3'b010       ,
				 STP=3'b110   ;

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     current_state<=IDLE ;
	  end
	  
	 else
	  begin
	     current_state<=next_state ;
	  end
	  
 end

always @(*)
 begin
     parity_flag=1'b0 ;
	 Busy=1'b0 ;
	 select=2'b11 ;
	 ser_en=1'b0 ;
     case(current_state)
	     IDLE : begin
		             if(DATA_VALID)
					  begin
					     next_state=STR ;
					  end
					 else
					  next_state=IDLE ;
		          end
		 STR : begin
		             select=2'b00 ;
					 ser_en=1'b1 ;
					 Busy=1'b1 ;
					 if(PAR_EN)
					  parity_flag=1'b1 ;
					 else
					  parity_flag=1'b0 ;
					 next_state=DATA ;
				 end
		 DATA : begin
		             ser_en=1'b1 ;
					 select=2'b01 ;
					 Busy=1'b1 ;
					 if (ser_out)
					  begin
					     if(PAR_EN)
						  begin
						     next_state=P ;
						  end
						 else
						  next_state=STP ;
					  end
					  
					 else
					  next_state=DATA ;
				   end
		 P : begin
		         select=2'b10 ;
				 ser_en=1'b0 ;
				 Busy=1'b1 ;
				 next_state=STP ;
			  end
		 STP : begin
		             select=2'b11 ;
					 ser_en=1'b0 ;
					 Busy=1'b0 ;
					 parity_flag=1'b0 ;
					 if(DATA_VALID)
					  next_state=STR ;
					 else
					  next_state=IDLE ;
				 end
		 default : begin
		                 next_state=IDLE ;
					  end
	 endcase
	 
 end

endmodule