module edge_bit_counter(
 input wire                                   CLK,RST,counter_en,new_start,
 input wire           [4:0]                  prescale,
 output reg          [4:0]                  edge_cnt,
 output reg          [3:0]                  bit_cnt
);

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     edge_cnt<=5'b0 ;
	  end
	 
     else if (counter_en)
      begin
         //if (end_signal)
		 // edge_cnt<=5'b0 ;
		 //else 
		 if (edge_cnt<(prescale+1'b1) & (!new_start))
		  edge_cnt<=edge_cnt+1'b1 ;
		 else if (new_start)
		  edge_cnt<=5'b10 ;
		 else
		 edge_cnt<=5'b1 ;
	  end	  
	 
	 else
	  edge_cnt<=5'b0 ;
	 
 end

always @(posedge CLK or negedge RST)
 begin
     if(!RST)
	  begin
	     bit_cnt<=4'b0 ;
	  end
	  
	 else if (counter_en)
	  begin
	     if ((edge_cnt==prescale)&(!new_start))
		  bit_cnt<=bit_cnt+1'b1 ;
		 else if (new_start)
		  bit_cnt<=4'b1 ;
	  end
	 
	 else
	  bit_cnt<=4'b0 ;
	 
 end
 
endmodule