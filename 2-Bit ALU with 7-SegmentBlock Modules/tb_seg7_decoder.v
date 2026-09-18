`timescale 1ns/1ps

module tb_seg7_decoder();
    reg  [3:0] in;
    wire [6:0] seg;

    
    seg7_decoder dut (
        .in(in),
        .seg(seg)
    );

    integer i;

    initial begin
        $monitor("Time=%0t | Input=%d (4'b%b) | Segments {g,f,e,d,c,b,a}=7'b%b", $time, in, in, seg);

        // Loop through inputs 0 to 3
        for (i = 0; i < 4; i = i + 1) begin
            in = i;
            #10;
        end

        $finish;
    end
endmodule