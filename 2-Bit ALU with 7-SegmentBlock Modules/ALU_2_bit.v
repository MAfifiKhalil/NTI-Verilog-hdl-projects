module ALU_2_bit(
input wire [1:0] A, B,
input wire [2:0] ALU_Sel,
output reg [1:0] ALU_Out
)
always @(*) begin
    case (ALU_Sel)
    3'b000: ALU_Out = A&B; // ADD operation
    3'b001: ALU_Out = A|B; // OR operation
    3'b010: ALU_Out = A+B; // ADD operation
    3'b011: ALU_Out = A-B; // SUBTRACT operation
    3'b100: ALU_Out = A*B; // MULTIPLY operation
    3'b101: 
    ALU_Out = A > B? 4'b1010 : 4'b1011; // GREATER THAN operation
    3'b110: 
    ALU_Out = A < B ? 4'b1011 : 4'b1010; // LESS THAN operation
    3'b111: 
    ALU_Out = A == B? 4'b1100 : 4'b0000; // EQUAL operation
    default: ALU_Out = 4'b0; // Default case
endcase
end 
endmodule