
module hack_screen_buffer(clock, addr_a, addr_b, load_a, load_b, out_a, out_b,
                                in_a, in_b);

    input  wire         clock;
    input  wire [12:0]  addr_a;
    input  wire [12:0]  addr_b;
    input  wire         load_a;
    input  wire         load_b;
    input  wire [15:0]  in_a;
    input  wire [15:0]  in_b;

    output reg  [15:0]  out_a;
    output reg  [15:0]  out_b;

    //memory
    reg [15:0] mem [0:8191];

    always @(posedge clock)
    begin
        if(load_a)
        begin
            mem[addr_a] <= in_a;
            out_a <= in_a;
        end
        else
            out_a <= mem[addr_a];
    end

    always @(posedge clock)
    begin
        if(load_b)
        begin
            mem[addr_b] <= in_b;
            out_b <= in_b;
        end
        else
            out_b <= mem[addr_b];
    end
endmodule
