module serializer (
 input wire                   [15:0]                          P_DATA,
 input wire                                                    ser_en,CLK,RST,DATA_VALID,Busy,
 output reg                                                   S_DATA,ser_out
);

reg                  [15:0]                          mem ;
reg                              [4:0]                          counter ;
integer i ;

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     S_DATA<=1'b0 ;
		 mem<=16'b0 ;
	  end
	  
	 else if(DATA_VALID & !Busy)
	  begin
	     mem<=P_DATA ;
	  end
	 
	 else if(ser_en & (counter!=5'b0))
      begin
         S_DATA<=mem[0] ;
		 for (i=0 ;i<15;i=i+1)
		  begin
		     mem[i]<=mem[i+1] ;
		 end
		 mem[15]<=1'b0 ;
	  end
	  
 end
 
always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     counter<=5'b10000 ;
		 ser_out<=1'b0 ;
	  end
	  
	 else if (ser_en & (counter>5'b1))
	  begin
	     counter<=counter-1'b1 ;
		 ser_out<=1'b0 ;
	  end

	 else if(ser_en & (counter==5'b1))
	  begin
	     ser_out<=1'b1 ;
		 counter<=counter-1'b1 ;
	  end
	  
	 else 
	  counter<=5'b10000 ;
	  
 end

endmodule