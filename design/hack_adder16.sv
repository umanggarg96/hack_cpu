/**
 * Adds two 16-bit values.
 * The most significant carry bit is ignored.
 */


module hack_adder16(x, y, out);

    input  wire [15:0] x;
    input  wire [15:0] y;

    output wire [15:0] out;

    //simple assign statement to model adder
    //will improve in future

    assign out = x + y;

endmodule
