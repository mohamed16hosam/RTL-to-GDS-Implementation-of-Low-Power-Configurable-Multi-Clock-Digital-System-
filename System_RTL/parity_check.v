module parity_check (
 input wire                                          sampled_bit,par_check_en,PAR_TYP,CLK,RST,par_en,
 input wire                    [4:0]               edge_cnt,prescale,
 input wire                    [3:0]               bit_cnt,
 output reg                                        par_err
);

reg                          [3:0]                    parity ;
reg                                                     parity_flag ;

//assign par_err=((edge_cnt==5'b1) & bit_cnt==4'b1011) ? (parity_flag!=sampled_bit) : 1'b0 ;

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  par_err<=1'b0 ;
	 else if (bit_cnt==4'b0)
	  par_err<=1'b0 ;
	 else if (par_check_en)
	  par_err<=(parity_flag!=sampled_bit) ;
 end

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin 
		 parity<=4'b0 ;
		 parity_flag<=1'b0 ;
	  end
	 
	 else if(bit_cnt==4'b1100)
	  begin
	     parity<=4'b0 ;
	  end
	  
	 else if (par_en)
	  begin
	     if (edge_cnt==prescale+1'b1)
	      parity<=parity+sampled_bit ;
		 //else if(edge_cnt==prescale+1'b1)
	      //parity<=parity+sampled_bit ;
	  end

     //else if (par_check_en)
     else if ((bit_cnt==4'b1010) &(edge_cnt==prescale))	 
	  begin
	     if(PAR_TYP)
		  parity_flag<=parity[0] ;
		 else
		  parity_flag<=~ parity[0] ;
	  end
	  
 end

endmodule