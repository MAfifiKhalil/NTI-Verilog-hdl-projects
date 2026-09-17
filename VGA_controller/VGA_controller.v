module VGA_controller(
    input wire clk,            // Clock input
    input wire reset,         
    input wire [2:0] sw,        // Reset signal
    output wire hsync,         // Horizontal sync output
    output wire vsync,
    output wire  video_on,
    // output reg [7:0] red, 
    // output reg [7:0] green,
    // output reg [7:0] blue
    output [9:0] y_counter,
    output [9:0] x_counter 

);
     assign y_counter = v_counter;
     assign x_counter = h_counter;
 // VGA timing parameters for 640x480 @ 50 Hz 
 parameter H_VISIBLE_AREA = 640;   // Visible horizontal pixels
 parameter H_FRONT_PORCH = 16;      // Horizontal front porch
 parameter H_SYNC_PULSE = 96;      // Horizontal sync pulse width
 parameter H_BACK_PORCH = 48;      // Horizontal back porch
 parameter H_TOTAL = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;      

// VGA timing parameters for 480p @ 50 Hz
parameter V_VISIBLE_AREA = 480;   
parameter V_FRONT_PORCH = 10;      
parameter V_SYNC_PULSE = 2;      
parameter V_BACK_PORCH = 33;         
parameter V_TOTAL = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

reg [1:0] state, next_state;
reg [1:0] v_state, v_next_state;

localparam [2:0]
    STATE_IDLE_H = 2'b00,
    STATE_FRONT_H = 2'b01,
    STATE_SYNC_H = 2'b10,
    STATE_BACK_H = 2'b11
;
localparam [2:0]
    STATE_IDLE_V= 2'b00,
    STATE_FRONT_V = 2'b01,
    STATE_SYNC_V = 2'b10,
    STATE_BACK_V = 2'b11
;
   
reg [9:0] h_counter;  // Horizontal pixel counter
reg [9:0] v_counter;  // Vertical pixel counter

always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        h_counter <= 0;
        v_counter <= 0;

    end else begin
        // Horizontal counter logic
        if (h_counter <= (H_TOTAL - 1)) begin
            h_counter <= h_counter + 1;
            v_counter <= v_counter ; 
        end else begin
            h_counter <= 0;
            // Vertical counter logic
            if (v_counter <=  (V_TOTAL - 1) ) begin
                v_counter <= v_counter + 1;
            end else begin
                v_counter <= 0;
            end
        end

    end
end
assign hsync = (state == STATE_SYNC_H) ? 0 : 1; 
assign vsync = (v_state == STATE_SYNC_V) ? 0 : 1;


// FSM logic for horizontal timing

always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        state <= STATE_IDLE_H;
    end else begin
        state <= next_state;
    end
end
// HORIZONTAL FSM
always @(*) begin
    case (state)
    STATE_IDLE_H : begin
        if (h_counter ==  (H_VISIBLE_AREA - 1) ) begin
            next_state = STATE_FRONT_H;
        end else begin
            next_state = STATE_IDLE_H;
        end
    end
   STATE_FRONT_H : begin
        if (h_counter ==  (H_VISIBLE_AREA + H_FRONT_PORCH - 1) ) begin
            next_state = STATE_SYNC_H;
        end else begin
            next_state = STATE_FRONT_H;
        end
   end
   STATE_SYNC_H : begin
        if (h_counter ==  (H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE - 1) ) begin
            next_state = STATE_BACK_H;
        end else begin
            next_state = STATE_SYNC_H;
        end
   end
    STATE_BACK_H : begin
          if (h_counter == (H_TOTAL - 1) ) begin
                next_state = STATE_IDLE_H;
          end else begin
                next_state = STATE_BACK_H;
          end
    end
endcase
end 


// FSM logic for vertical timing

always @ (posedge clk or negedge reset) begin
    if (!reset) begin
        v_state <= STATE_IDLE_V;
    end else begin
        v_state <= v_next_state;
    end
end
// VERTICAL FSM
always @(*) begin
    case (v_state)
    STATE_IDLE_V : begin
        if (v_counter ==  (V_VISIBLE_AREA ) ) begin
            v_next_state = STATE_FRONT_V;
        end else begin
            v_next_state = STATE_IDLE_V;
        end
    end
   STATE_FRONT_V : begin
        if (v_counter ==  (V_VISIBLE_AREA + V_FRONT_PORCH - 1) ) begin
            v_next_state = STATE_SYNC_V;
        end else begin
            v_next_state = STATE_FRONT_V;
        end
   end
   STATE_SYNC_V : begin
        if (v_counter ==  (V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE - 1) ) begin
            v_next_state = STATE_BACK_V;
        end else begin
            v_next_state = STATE_SYNC_V;
        end
   end
    STATE_BACK_V : begin
          if (v_counter == (V_TOTAL - 1) ) begin
                v_next_state = STATE_IDLE_V;
          end else begin
                v_next_state = STATE_BACK_V;
          end
    end
endcase
end
///////////////// OUTPUT RGB LOGIC ///////////////////////
assign video_on = ( state == STATE_IDLE_H && v_state == STATE_IDLE_V ) ? 1 : 0;
// always @(*) begin
//     if (!video_on) begin
//        {red, green, blue} = 24'b0;
//     end else begin
//         case (sw)
//             3'b000: {red, green, blue} = 24'b0; // Black
//             3'b001: {red, green, blue} = 24'h0000FF; // Blue
//             3'b010: {red, green, blue} = 24'h00FF00; // Green
//             3'b011: {red, green, blue} = 24'h00FFFF; // Cyan
//             3'b100: {red, green, blue} = 24'hFF0000; // Red
//             3'b101: {red, green, blue} = 24'hFF00FF; // Magenta
//             3'b110: {red, green, blue} = 24'hFFFF00; // Yellow
//             3'b111: {red, green, blue} = 24'hFFFFFF; // White
//         endcase
//     end
// end

endmodule
