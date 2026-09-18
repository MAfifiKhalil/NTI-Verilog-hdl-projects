`timescale 1ns/1ps

module tb_alu_2bit();
    reg  [1:0] A, B;
    reg  [1:0] sel;
    wire [1:0] alu_out;

   
    alu_2bit dut (
        .A(A),
        .B(B),
        .sel(sel),
        .alu_out(alu_out)
    );

    initial begin
        $monitor("Time=%0t | A=%b B=%b sel=%b | alu_out=%b", $time, A, B, sel, alu_out);

        // Test 1: Addition 
        A = 2'b10; B = 2'b01; sel = 2'b00; #10;

        // Test 2: Subtraction 
        A = 2'b11; B = 2'b01; sel = 2'b01; #10;

        // Test 3: Bitwise AND 
        A = 2'b10; B = 2'b01; sel = 2'b10; #10;

        // Test 4: Bitwise OR 
        A = 2'b10; B = 2'b01; sel = 2'b11; #10;

        $finish;
    end
endmodule