`timescale 1us/1ns
module SYS_TOP_tb ();

 reg                                       REF_CLK_tb,UART_CLK_tb,RST_tb,RX_IN_tb ;
 wire                                      TX_OUT_tb,parity_error_tb,framing_error_tb ;


initial
 begin
     $dumpfile("SYS_TOP.vcd") ;
	 $dumpvars ;
	 
	 Reset() ;
	 
	 initialize() ;
	 //#0.005
	 RX_IN_tb=1'b1 ;
	 #52.083
	 //11'b11010101010    Write cmd
	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b0 ;	 
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333 
	 RX_IN_tb=1'b0 ;
	 #833.333 
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 
	 
	 //11'b11000001010        address cmd
	 
	 RX_IN_tb=1'b0 ;
	 #833.333	
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	 
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333		 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333	 


	 //8'b11101010          data to be written cmd
	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	
     //11'b01011101111          read cmd
	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333		
	 RX_IN_tb=1'b1 ;
	 #833.333		
	 RX_IN_tb=1'b1 ;
	 #833.333	
	 
	 //11'b00000010111	          address cmd
	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333
	 
	 #16666.56
	 #2500
	 
	 //11'b00011001111         alu wit operands
	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 
	 //11'b00101000011       OP-A
	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 	 
	 
	 //11'b01110000011       OP-B
	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 		 
	 
	 //11'b01000000001           alu fun(subtraction)

	 RX_IN_tb=1'b0 ;
	 #833.333	 	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 
	 #16666.56
	 #2500	 
	 
	 //11'b01011101111         alu without operands
	 
	 RX_IN_tb=1'b0 ;
	 #833.333
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 
	 //11'b00010000001           alu fun(and)

	 RX_IN_tb=1'b0 ;
	 #833.333	 	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1;
	 #833.333	 	
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 
	 RX_IN_tb=1'b0 ;
	 #833.333	 	
	 RX_IN_tb=1'b1 ;
	 #833.333	 
	 
	 #16666.56
	 #2500	 	 
	
	 $finish ;
	 
 end 
 
task Reset();
 begin
     RST_tb=1'b1 ;
	 #0.005
	 RST_tb=1'b0 ;
	 #0.005
	 RST_tb=1'b1 ;
 end
endtask 

task initialize() ;
 begin
     REF_CLK_tb=1'b0 ;
	 UART_CLK_tb=1'b0 ;
 end
endtask

always #0.01 REF_CLK_tb=~REF_CLK_tb ;
always #52.083 UART_CLK_tb=~UART_CLK_tb ; 
 
SYS_TOP DUT (
.REF_CLK(REF_CLK_tb),
.UART_CLK(UART_CLK_tb),
.RST(RST_tb),
.RX_IN(RX_IN_tb),
.TX_OUT(TX_OUT_tb),
.parity_error(parity_error_tb),
.framing_error(framing_error_tb)
);

endmodule