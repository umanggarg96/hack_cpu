
module hack_top(clock, reset_n, debug_led, vsync, hsync, rgb, in_a, in_b);

    input  wire        clock;
    input  wire        reset_n;
    input  wire        in_a;
    input  wire        in_b;

    output wire        vsync;
    output wire        hsync;
    output wire [2:0]  rgb;
    output wire [7:0]  debug_led;
    //internal signals
    wire         reset;
    wire  [15:0] instr;
    wire  [15:0] mem_in;
    wire         wr_mem;
    wire  [15:0] mem_out;
    wire  [14:0] wr_addr;
    wire  [14:0] pc;
    wire  [7:0]  out_decoder;
    wire  [15:0] mem_kbd;

    wire         video_on;
    wire  [12:0] word_addr;
    wire  [3:0]  bit_addr;
    wire  [15:0] vga_word;
    wire         bit_on;

    hack_cpu inst_cpu(
            .clock(clock),
            .reset(reset),
            .instr(instr),
            .mem_in(mem_in),
            .wr_mem(wr_mem),
            .mem_out(mem_out),
            .wr_addr(wr_addr),
            .pc(pc)
        );
    hack_memory inst_mem(
            .clock    (clock),
            .in       (mem_out),
            .addr     (wr_addr),
            .load     (wr_mem),
            .out      (mem_in),
            .debug_led(debug_led),
            .mem_kbd  (mem_kbd),
            .vga_word_addr (word_addr),
            .vga_word (vga_word)
        );
    rotary_decoder decoder(
            .clk  (clock),
            .reset(reset),
            .in_a (in_a),
            .in_b (in_b),
            .val  (out_decoder)
        );

    vga_driver inst_vga_driver (
            .clock     (clock),
            .reset     (reset),
            .v_sync    (vsync),
            .h_sync    (hsync),
            .video_on  (video_on),
            .word_addr (word_addr),
            .bit_addr  (bit_addr)
        );

    assign bit_on = video_on && vga_word[bit_addr];
    assign rgb = {3{bit_on}};

    // hack_ram16k inst_ram(
    //         .clock(clock),
    //         .load(wr_mem),
    //         .in(mem_out),
    //         .addr(wr_addr),
    //         .out(mem_in),
    //     );

    hack_rom32k inst_rom(
            .clock(clock),
            .addr(pc),
            .out(instr)
        );

    // hack_screen_buffer inst_buffer(
    //         .clock (clock),
    //         .addr_a(addr_a),
    //         .addr_b(addr_b),
    //         .load_a(load_a),
    //         .load_b(1'b0),
    //         .in_a  (mem_out),
    //         .in_b  (16'h0000),
    //         .out_a (out_a),
    //         .out_b (out_b)
    //     );

    assign reset =  ~reset_n;

    assign mem_kbd = {out_decoder, out_decoder};

    // assign vsync = 1'b0;
    // assign hsync = 1'b0;
    // assign rgb   = 3'b000;
    // assign debug_led = mem_out[7:0];
endmodule
