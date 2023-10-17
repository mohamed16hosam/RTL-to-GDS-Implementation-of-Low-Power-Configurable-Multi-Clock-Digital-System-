module CTRL_TX (
 input wire                                        CLK,RST,OUT_Valid,RdData_Valid,Busy,
 input wire             [7:0]                     RdData,
 input wire             [15:0]                   ALU_OUT,
 output reg            [15:0]                    TX_P_DATA,
 output reg                                        TX_D_Valid,clk_div_en
);

localparam IDLE_state=2'b0 ,
                 Read_regfile_state=2'b1 ,
				 Read_ALU_state=2'b11 ;
				 
reg                        [1:0]                     current_state,next_state ;

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  current_state<=IDLE_state ;
	 else
	  current_state<=next_state ;
 end

always @(*)
 begin
     TX_P_DATA=16'b0 ;
	 TX_D_Valid=1'b0 ;
	 next_state=IDLE_state ;     
	 clk_div_en=1'b1 ;
	 
     case(current_state)
	     IDLE_state : begin
		                     if (OUT_Valid & (!Busy))
							  begin
							     next_state=Read_ALU_state ;
							     TX_D_Valid=1'b1 ;
                              end
							  
							 else if (RdData_Valid & (!Busy))
							  begin
								 next_state=Read_regfile_state ;
							     TX_D_Valid=1'b1 ;							  
							  end
							  
							 else
							 next_state=IDLE_state ;
						  end
		 Read_ALU_state : begin
									 if((!Busy) & OUT_Valid)
		                              begin
									     TX_P_DATA=ALU_OUT ;
		                                 TX_D_Valid=1'b1 ;									     
										 next_state=Read_ALU_state ;
									  end
									  
									 else if (Busy & (!OUT_Valid))
									  begin
									     TX_P_DATA=ALU_OUT ;
									     TX_D_Valid=1'b0 ;
									     next_state=Read_ALU_state ;
									  end									  
                                     else 
                                         next_state=IDLE_state ;										 
								  end
		 Read_regfile_state : begin
		                                 if(!Busy)
		                                  begin
										     TX_P_DATA[7:0]=RdData ;
										     TX_D_Valid=1'b1 ;
										     next_state=Read_regfile_state ;
										  end
										  
										 else
										  begin
										     TX_P_DATA[7:0]=RdData ;
										     TX_D_Valid=1'b0 ;
										     next_state=IDLE_state ;										     
										  end
									 end
		 default : begin
	                     TX_P_DATA=16'b0 ;
						 TX_D_Valid=1'b0 ;
						 next_state=IDLE_state ; 
	                     clk_div_en=1'b1 ;						 
					  end		 
	 endcase
 end
 
endmodule