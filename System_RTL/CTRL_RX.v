module CTRL_RX (
 input wire                                                 CLK,RST,RX_D_Valid,Busy,
 input wire                    [7:0]                       RX_P_DATA,
 output reg                                                 ALU_EN,CLK_G_EN,WrEn,RdEn,
 output reg                   [3:0]                       ALU_FUN,Addr,
 output reg                   [7:0]                       WrData
);

localparam IDLE_state=4'b0 ,
                 Write_state=4'b1 ,
                 Write_address_state=4'b11 ,				 
                 Write_Data_state=4'b10 ,
                 Read_state=4'b110 ,
				 Read_address_state=4'b100 ,
				 ALU_OPER_W_OP_state=4'b101 ,
                 ALU_OP_A_state=4'b111 ,
                 ALU_OP_B_state=4'b1111 ,
                 ALU_FUN_state=4'b1011 ,
                 ALU_OPER_W_NOP_state=4'b1001 ;				 

reg                            [3:0]                          current_state,next_state ;    
reg                            [3:0]                          address_seq ;                   

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     current_state<=IDLE_state ;
	     address_seq<=4'b0 ;
      end
	 else
	  begin
	     current_state<=next_state ;
		 address_seq<=RX_P_DATA[3:0] ;
	  end
 end

always @(*)
 begin
     ALU_EN=1'b0 ;
	 CLK_G_EN=1'b0 ;
	 WrEn=1'b0 ;
	 RdEn=1'b0 ;
     ALU_FUN=4'b0 ;
	 Addr=4'b0 ;
     WrData=8'b0 ;
	 next_state=IDLE_state ;
	 
     case(current_state)
	     IDLE_state : begin
		             WrEn=1'b0 ;
		             if ((RX_P_DATA==8'b10101010) & RX_D_Valid)
					  next_state=Write_state ;
					 else if ((RX_P_DATA==8'b10111011) & RX_D_Valid)
					  next_state=Read_state ;
					 else if ((RX_P_DATA==8'b11001100) & RX_D_Valid)
					  begin
					     next_state=ALU_OPER_W_OP_state ;
						 CLK_G_EN=1'b1 ;
					  end
					 else if ((RX_P_DATA==8'b11011101) & RX_D_Valid)
					  begin
					     next_state=ALU_OPER_W_NOP_state ;
						 CLK_G_EN=1'b1 ;
					  end
					 else
					  next_state=IDLE_state ;
				  end
		 Write_state : begin
		                     if(RX_D_Valid)
                              next_state=Write_address_state ;
					         else
						      next_state=Write_state ;                             
                            end		 
				  
		 Write_address_state : begin
		             if(RX_D_Valid)
					  begin
					     Addr=address_seq ;
						 WrEn=1'b1 ;
						 WrData=RX_P_DATA ;						 
					     next_state=Write_Data_state ;
					  end
					  
					 else
					  begin
					     Addr=address_seq ;
						 next_state=Write_address_state ;
					  end
				   end
		 Write_Data_state : begin
		                     if(RX_D_Valid)
		                      begin
							     WrData=8'b0 ;
							     WrEn=1'b0 ;
								 if (RX_P_DATA==8'b10101010)
					              next_state=Write_state ;
					             else if (RX_P_DATA==8'b10111011)
					              next_state=Read_state ;
					             else if (RX_P_DATA==8'b11001100)
					              begin
					                 next_state=ALU_OPER_W_OP_state ;
						             CLK_G_EN=1'b1 ;
					              end
					             else if (RX_P_DATA==8'b11011101)
					              begin
					                 next_state=ALU_OPER_W_NOP_state ;
						             CLK_G_EN=1'b1 ;
					              end
					             else
					              next_state=IDLE_state ;
							  end
							  
							 else
							  begin
							     WrData=8'b0 ;
							     WrEn=1'b0 ;
							     next_state=Write_Data_state ;
							  end
						   end
		 Read_state : begin
		             if(RX_D_Valid)
		              begin
					     Addr=4'b0 ;
					     RdEn=1'b0 ;
					     next_state=Read_address_state ;
					 end
					 
					 else
					  begin
					     Addr=4'b0 ;
					     next_state=Read_state ;
					  end
				  end
		 Read_address_state : begin
		                                 if(RX_D_Valid)
		                                  begin
					                         Addr=4'b0 ;
					                         RdEn=1'b0 ;
								             if (RX_P_DATA==8'b10101010)
					                          next_state=Write_state ;
					                         else if (RX_P_DATA==8'b10111011)
					                          next_state=Read_state ;
					                         else if (RX_P_DATA==8'b11001100)
					                          begin
					                             next_state=ALU_OPER_W_OP_state ;
						                         CLK_G_EN=1'b1 ;
					                          end
					                         else if (RX_P_DATA==8'b11011101)
					                          begin
					                             next_state=ALU_OPER_W_NOP_state ;
						                         CLK_G_EN=1'b1 ;
					                          end
					                         else
					                          next_state=IDLE_state ;											 
					                      end
					 
					                     else
					                      begin
					                         Addr=address_seq ;
					                         RdEn=1'b1 ;
					                         next_state=Read_address_state ;
					                      end		                                  
									   end
		 ALU_OPER_W_OP_state : begin
                         		             if(RX_D_Valid)
							                  begin
		                                         Addr=4'b0 ;
							                     WrData=RX_P_DATA ;
							                     WrEn=1'b1 ;
							                     CLK_G_EN=1'b1 ;
							                     next_state=ALU_OP_A_state ;
							                  end
							  
							                 else
							                  begin
							                     CLK_G_EN=1'b1 ;
							                     next_state=ALU_OPER_W_OP_state ;
							                  end                     
											end		 
		 ALU_OP_A_state : begin
		                     if(RX_D_Valid)
							  begin
		                         Addr=4'b1 ;
							     WrData=RX_P_DATA ;
							     WrEn=1'b1 ;
							     CLK_G_EN=1'b1 ;
							     next_state=ALU_OP_B_state ;
							  end
							  
							 else
							  begin
		                         Addr=4'b0 ;
							     WrData=RX_P_DATA ;
							     WrEn=1'b1 ;
							     CLK_G_EN=1'b1 ;
							     next_state=ALU_OP_A_state ;
							  end
						  end
		 ALU_OP_B_state : begin
		                     if(RX_D_Valid)
							  begin
							     ALU_FUN=RX_P_DATA ;
								 ALU_EN=1'b1 ;
							     WrData=8'b0 ;
							     WrEn=1'b0 ;
							     CLK_G_EN=1'b1 ;
							     next_state=ALU_FUN_state ;
							  end
							  
							 else
							  begin
		                         Addr=4'b1 ;
							     WrData=RX_P_DATA ;
							     WrEn=1'b1 ;
							     CLK_G_EN=1'b1 ;
							     next_state=ALU_OP_B_state ;							  
							  end
						  end
		 ALU_FUN_state : begin
		                             if(RX_D_Valid | Busy)
						              begin
		                                 ALU_FUN=4'b0 ;
						                 ALU_EN=1'b0 ;
						                 CLK_G_EN=1'b1 ;
						                 next_state=IDLE_state ;
								         if (RX_P_DATA==8'b10101010)
					                      next_state=Write_state ;
					                     else if (RX_P_DATA==8'b10111011)
					                      next_state=Read_state ;
					                     else if (RX_P_DATA==8'b11001100)
					                      begin
					                         next_state=ALU_OPER_W_OP_state ;
						                     CLK_G_EN=1'b1 ;
					                      end
					                     else if (RX_P_DATA==8'b11011101)
					                      begin
					                         next_state=ALU_OPER_W_NOP_state ;
						                     CLK_G_EN=1'b1 ;
					                      end
					                     else
					                      next_state=IDLE_state ;												  
						              end
						  
						             else
						              begin
		                                 ALU_FUN=RX_P_DATA ;
						                 ALU_EN=1'b1 ;
						                 CLK_G_EN=1'b1 ;
						                 next_state=ALU_FUN_state ;						  
						              end
					            end
		 ALU_OPER_W_NOP_state : begin
                         		                 if(RX_D_Valid)
							                      begin
												     ALU_FUN=RX_P_DATA ;
													 ALU_EN=1'b1 ;
							                         WrEn=1'b0 ;
							                         CLK_G_EN=1'b1 ;
							                         next_state=ALU_FUN_state ;
							                      end
							  
							                     else
							                      begin
							                         CLK_G_EN=1'b1 ;
							                         next_state=ALU_OPER_W_NOP_state ;
							                      end   		                                         
											 end
         default : begin
                         ALU_EN=1'b0 ;
	                     CLK_G_EN=1'b0 ;
	                     WrEn=1'b0 ;
	                     RdEn=1'b0 ;
                         ALU_FUN=4'b0 ;
	                     Addr=4'b0 ;
                         WrData=8'b0 ;
	                     next_state=IDLE_state ;	                 
					  end
	 endcase
 end
 
endmodule