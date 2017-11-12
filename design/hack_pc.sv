/*
    A 16-bit counter with load, reset and increment control,
    if(reset == 1)          => out = 0
    else if(load == 1)      => out = in
    else if(increment == 1) => out = out + 1
    else                    => out = out

    Intended to be used as the Program Counter in the "HACK" CPU

*/


module hack_pc(clock, reset, load, increment, in, out);

    input  wire         clock;
    input  wire         reset;
    input  wire         load;
    input  wire         increment;

    input  wire [15:0]  in;

    output wire [15:0]  out;

    //internal signals
    reg  [15:0] pc;
    reg  [15:0] pc_next;

    wire [15:0] pc_incr;

    always @(posedge clock)
        pc <= pc_next;

    always @*
    begin
        //give default value to pc_next
        pc_next = pc;

        //check if there is any signal that might change the pc
        if(reset)
            pc_next = 16'h0000;
        else if(load)
            pc_next = in;
        else if(increment)
            pc_next = pc_incr;
    end

    //calculate an incremented pc, might be improved to be more efficient
    hack_incrementer16 inst_hack_incrementer16(
        .in(pc),
        .out(pc_incr)
        );

    assign out = pc;
endmodule
