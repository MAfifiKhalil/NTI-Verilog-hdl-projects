module VGA_top (
    input wire clk_50,            
    input wire reset,         
    input wire [2:0] sw,       
    output wire hsync,         
    output wire vsync,         
    output wire [7:0] red,     
    output wire [7:0] green,   
    output wire [7:0] blue, 
    
    output wire vga_clk,
    output wire vga_sync_N,
    output wire vga_blank_N

);
wire clk_25;
wire vide_on;

assign vga_clk = clk_25;
assign vga_sync_N = 1'b0; // Active low sync signal
assign vga_blank_N = video_on; // Active low blanking signal
wire [9:0] pixel_x;
wire [9:0] pixel_y;
wire [16:0] addr;
wire [23:0] q;
wire video_on;             // Video on signal from VGA controller
  
assign addr = (pixel_y[9:1]* 17'd320) + pixel_x[9:1]; // Address for ROM based on pixel coordinates

assign red = video_on ? q[23:16] : 8'd0;   // Red channel from ROM
assign green = video_on ? q[15:8] : 8'd0;
assign blue = video_on ? q[7:0] : 8'd0;

    // Instantiate the VGA controller
VGA_controller clk1 (
 . clk(clk_25),            // Clock input
    . reset(reset),         
    . sw(sw),        // Reset signal
    . hsync(hsync),         // Horizontal sync output
    . vsync(vsync),
    . video_on(video_on),
    // . red(red), 
    // . green(green),
    // . blue(blue),
    . y_counter(pixel_y),
    . x_counter(pixel_x)
);
 vga_pll clk2 (
		 .refclk(clk_50),   //  refclk.clk
		  .rst(0),      //   reset.reset
		 .outclk_0(clk_25)   // outclk0.clk
	);
 ROM_image new (
	.address(addr),
	.clock(clk_25),
	.q(q)
);

endmodule