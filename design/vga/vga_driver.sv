
module vga_driver(clock, reset, v_sync, h_sync, video_on, word_addr, bit_addr);

    input  wire         clock;
    input  wire         reset;

    output wire         v_sync;
    output wire         h_sync;
    output wire         video_on;

    output wire [12:0]  word_addr;
    output wire [3:0]   bit_addr;

    parameter [10:0] UPPER_X = 11'd576, UPPER_Y = 11'd368;
    parameter [10:0] LOWER_X = 11'd64,  LOWER_Y = 11'd112;

    wire [10:0] pixel_x, adjusted_x;
    wire [10:0] pixel_y, adjusted_y;

    vga_sync inst_vga_sync (
            .clk     (clock),
            .reset   (reset),
            .h_sync  (h_sync),
            .v_sync  (v_sync),
            .pixel_x (pixel_x),
            .pixel_y (pixel_y)
            // .video_on(video_on) // NOT CONNECTED
            // .p_tick  (p_tick)   // NOT CONNECTED
        );


    assign video_on = pixel_x >= LOWER_X && pixel_x <= UPPER_X && pixel_y <= UPPER_Y && pixel_y >= LOWER_Y;

    assign adjusted_x = pixel_x - 10'd64;
    assign adjusted_y = pixel_y - 10'd112;

    assign word_addr = {adjusted_y[7:0], adjusted_x[8:4]};
    assign bit_addr  = ~adjusted_x[3:0];

endmodule
