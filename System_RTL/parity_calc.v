module parity_calc(
 input wire            [15:0]                 P_DATA,
 input wire                                    parity_flag,CLK,RST,PAR_EN,PAR_TYP,
 output reg                                   parity_out
);

reg                       [4:0]                 parity ;
integer i ;

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     parity_out<=1'b0 ;
		 parity<=5'b0 ;
	  end
	  
	 else if(parity_flag)
	  begin		
	     if(PAR_TYP)
		  begin
		     if(parity[0]==1'b1)
			  parity_out<=1'b1 ;
			 else
			  parity_out<=1'b0 ;
		  end
		  
		 else
		  begin
		     if(parity[0]==1'b0)
			  parity_out<=1'b1 ;
			 else
			  parity_out<=1'b0 ;
		  end
		 
	  end
	  
	 else if(PAR_EN)
	  parity<=P_DATA[0]+P_DATA[1]+P_DATA[2]+P_DATA[3]+P_DATA[4]+P_DATA[5]+P_DATA[6]+P_DATA[7]+P_DATA[8]+P_DATA[9]+P_DATA[10]+P_DATA[11]+P_DATA[12]+P_DATA[13]+P_DATA[14]+P_DATA[15] ;
	 
 end

endmodule