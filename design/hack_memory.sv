
module hack_memory(clock, in, addr, load, out, debug_led, mem_kbd, vga_word_addr, vga_word);

    input  wire         clock;
    input  wire [15:0]  in;
    input  wire [14:0]  addr;
    input  wire         load;
    input  wire [15:0]  mem_kbd;
    input  wire [12:0]  vga_word_addr;

    output wire [15:0]  out;
    output wire [7:0]   debug_led;
    output wire [15:0]  vga_word;
    //internal signals

    wire        load_buf;
    wire        load_ram;
    wire [15:0] ram_out;
    wire [15:0] buf_out;
    wire [15:0] kbd_out;

    // wire [12:0] vga_addr;
    // wire [15:0] vga_word;

    hack_screen_buffer inst_buffer(
            .clock (clock),
            //port A
            .addr_a(addr[12:0]),
            .load_a(load_buf),
            .in_a  (in),
            .out_a (buf_out),
            //port B
            .addr_b(vga_word_addr),
            .load_b(1'b0),
            .in_b  (16'h0000),
            .out_b (vga_word)
        );

    hack_ram16k inst_ram(
            .clock(clock),
            .load(load_ram),
            .in(in),
            .addr(addr[13:0]),
            .out(ram_out)
        );

    //till we implement the keyboard input
    assign kbd_out = mem_kbd;

    //this code is for testing the dual port ram in the system
    //we read the data from a base address of the screen buffer
    //and send that to the vga_word, and then to the on board LEDs
    // assign vga_addr = 13'h0000;
    assign debug_led = vga_word[7:0];


    assign load_ram = (~addr[14]) & load;
    assign load_buf = addr[14] & (~addr[13]) & load;

    assign out = addr[14] ? (addr[13] ? kbd_out : buf_out) : ram_out;
endmodule
