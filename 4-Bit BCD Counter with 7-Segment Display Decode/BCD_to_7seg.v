module BCD_to_7seg(
    input wire clk,
    input wire reset,
    output wire [6:0] seg,
    output wire [3:0] bcd_out
);

bcd_counter_7segment bcd_counter_unit (
    .clk(clk),
    .reset(reset),
    .seg(seg),
    .bcd_out(bcd_out)
);
seg7_decoder seg7_unit (
    .in(bcd_out),
    .seg(seg)
);
endmodule