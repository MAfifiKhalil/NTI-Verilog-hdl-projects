module BCD (
    input clk ,
    input rest,
    output reg [3:0] bcd_out
); 
always @( posedge clk or negedge reset ) begin
    if (!reset ) begin
        bcd_out <= 4'b0000;
    end else begin
        if (count == 9) begin
        bcd_out <= 4'b0000;
        end else begin
            bcd_out <= bcd_out + 1;
        end
    end
    
end

endmodule