/*
    16-bit incrementing circuit
    out = in + 1

    Used in the Program Counter of "HACK" CPU
*/


module hack_incrementer16(in, out);

    input  wire [15:0] in;
    output wire [15:0] out;

    //using assign for the increment, will improve in future

    assign out = in + 16'h0001;

endmodule
