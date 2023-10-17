module Stop_check (
 input wire                                     sampled_bit,stp_check_en,
 output wire                                   stp_err
);

assign stp_err=(stp_check_en) ? (~sampled_bit) : 1'b0 ;

endmodule