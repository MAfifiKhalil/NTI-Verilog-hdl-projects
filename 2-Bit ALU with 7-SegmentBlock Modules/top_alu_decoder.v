module top_alu_decoder(
    input wire [1:0] A, B,
    input wire [2:0] ALU_Sel,
    output wire [6:0] seg,
    output wire [1:0] leds
);
wire [3:0] alu_result;
ALU_2_bit alu_unit (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(alu_result)
);
seg7_decoder seg7_unit (
    .in( alu_result), // Concatenate 2'b00 with the 2-bit ALU result to form a 4-bit input
    .seg(seg)
);
assign leds = alu_result[1:0]; // Directly assign the 2-bit ALU result to the LEDs