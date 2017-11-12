
module hack_top(clock, reset_n, debug_led, vsync, hsync, rgb);

    input  wire        clock;
    input  wire        reset_n;

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
            .debug_led(debug_led)
        );

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

    assign vsync = 1'b0;
    assign hsync = 1'b0;
    assign rgb   = 3'b000;
    // assign debug_led = mem_out[7:0];
endmodule
