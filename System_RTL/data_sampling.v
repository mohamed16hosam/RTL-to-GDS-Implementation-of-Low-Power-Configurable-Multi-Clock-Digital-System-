module data_sampling (
 input wire                                               RX_IN,CLK,RST,samp_en,
 input wire             [4:0]                           prescale,
 input wire             [4:0]                           edge_cnt,
 output reg                                              sampled_bit
);

reg                        [31:0]                         edge_bits ;
reg                        [2:0]                           sum ;

always @(*)
 begin
     if (samp_en) 
	  begin
	     if(edge_cnt>=5'b100 & prescale==5'b11)
		  sampled_bit=edge_bits[2] ;
	     
		 else if (((edge_cnt==5'b1000)|(edge_cnt==5'b1)) & (prescale==5'b111))
	      begin
	         if (sum==3'b0 | sum==3'b1)
		      sampled_bit=1'b0 ;
		     else  // if (sum==3'b10 | sum==3'b11)
		      sampled_bit=1'b1 ;
	     end
	 
	     else if (((edge_cnt>=5'b1101)|(edge_cnt==5'b1))&( prescale==5'b1111))
	      begin
	         if (sum==3'b0 | sum==3'b1 | sum==3'b10)
		      sampled_bit=1'b0 ;
		     else
		      sampled_bit=1'b1 ;
	     end
	 
	     else if (((edge_cnt>=5'b10110)|(edge_cnt==5'b1))&(prescale==5'b1111))
	      begin
	         if (sum==3'b0 | sum==3'b1 | sum==3'b10 | sum==3'b11)
		      sampled_bit=1'b0 ;
		     else
		      sampled_bit=1'b1 ;
	     end
	     
		 else
		 sampled_bit=1'b0 ;
		 
	  end
	 
	 else
	  sampled_bit=1'b0 ;
 
 end

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
		 edge_bits<=32'b0 ;
		 sum<=3'b0 ;
	  end
	 
	 else if (samp_en) 
	  begin
	     if (edge_cnt==5'b11 & prescale==5'b11)
		  edge_bits[2]<=RX_IN ;
		  
	     if(edge_cnt==5'b100 & prescale==5'b111) 
	      edge_bits[3]<=RX_IN ;
	 
	     if ( edge_cnt==5'b101 & prescale==5'b111)
	      edge_bits[4]<=RX_IN ;
	 
	     if (edge_cnt==5'b110 & prescale==5'b111)
	      edge_bits[5]<=RX_IN ;
	 
	     if (edge_cnt==5'b111 & prescale==5'b1111)
	      edge_bits[6]<=RX_IN ;
	 
	     if (edge_cnt==5'b1000 & prescale==5'b1111)
	      edge_bits[7]<=RX_IN ;
		 
	     if (edge_cnt==5'b1001 & prescale==5'b1111)
	      edge_bits[8]<=RX_IN ;

	     if (edge_cnt==5'b1010 & prescale==5'b1111)
	      edge_bits[9]<=RX_IN ;
		  
	     if (edge_cnt==5'b1011 & prescale==5'b1111)
	      edge_bits[10]<=RX_IN ;
		  
		 if (edge_cnt==5'b1110 & prescale==5'b11111)
		  edge_bits[13]<=RX_IN ;

		 if (edge_cnt==5'b1111 & prescale==5'b11111)
		  edge_bits[14]<=RX_IN ;
		  
		 if (edge_cnt==5'b10000 & prescale==5'b11111)
		  edge_bits[15]<=RX_IN ;
		  
		 if (edge_cnt==5'b10001 & prescale==5'b11111)
		  edge_bits[16]<=RX_IN ;
		 
		 if (edge_cnt==5'b10010 & prescale==5'b11111)
		  edge_bits[17]<=RX_IN ;
		  
		 if (edge_cnt==5'b10011 & prescale==5'b11111)
		  edge_bits[18]<=RX_IN ;
		  
		 if (edge_cnt==5'b10100 & prescale==5'b11111)
		  edge_bits[19]<=RX_IN ;
		  
	     if(edge_cnt==5'b111 & prescale==5'b111)
	      sum<=edge_bits[3]+edge_bits[4]+edge_bits[5] ;
	  
	     if(edge_cnt==5'b1100 & prescale==5'b1111)
	      sum<=edge_bits[6]+edge_bits[7]+edge_bits[8]+edge_bits[9]+edge_bits[10] ;
	  
	     if(edge_cnt==5'b10101 & prescale==5'b11111)
	      sum<=edge_bits[13]+edge_bits[14]+edge_bits[15]+edge_bits[16]+edge_bits[17]+edge_bits[18]+edge_bits[19] ;
		  
	  end
	 
 end
 
endmodule