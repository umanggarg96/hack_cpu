/*
    16-bit register with synchronous load and reset
    if(reset == 1)
        out = 0
    else if(load == 1)
        out = in
    else
        out = out; (no change)
*/

module hack_register16(clock, reset, load, in, out);

    input  wire         clock;
    input  wire         reset;
    input  wire         load;
    input  wire [15:0]  in;

    output reg  [15:0]  out;

    always @(posedge clock)
        if(reset)
            out <= 16'h0000;
        else if(load)
            out <= in;
endmodule
