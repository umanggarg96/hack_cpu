
module hack_ram16k(clock, load, in, addr, out);

    input  wire         clock;
    input  wire         load;
    input  wire [15:0]  in;
    input  wire [13:0]  addr;

    output wire [15:0]  out;

    //memory 16K x 16
    reg [15:0] mem [0:16383];
    reg [13:0] addr_reg;

    always @(posedge clock)
    begin
        if(load)
            mem[addr] <= in;
        addr_reg <= addr;
    end

    assign out = mem[addr_reg];

endmodule
