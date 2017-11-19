/**
 * The ALU (Arithmetic Logic Unit).
 * Computes one of the following functions:
 * x+y, x-y, y-x, 0, 1, -1, x, y, -x, -y, !x, !y,
 * x+1, y+1, x-1, y-1, x&y, x|y on two 16-bit inputs,
 * according to 6 input bits denoted zx,nx,zy,ny,f,no.
 * In addition, the ALU computes two 1-bit outputs:
 * if the ALU output == 0, zr is set to 1; otherwise zr is set to 0;
 * if the ALU output < 0, ng is set to 1; otherwise ng is set to 0.
 */

/*
Implementation :
    if(zx == 1) => x = 0
    if(nx == 1) => x = ~x
    if(zy == 1) => y = 0
    if(ny == 1) => y = ~y

    // here the steps on the input x,y are sequential i.e. if both zx and nx
    // are 1 then we will first set x = 0 then set the new value of x to
    // ~x thus resulting in x = 0xffff. The same is true of y.

    if(f == 0) => out = x & y
    else if (f == 1) => out = x + y

    if (no == 1) => out = ~out

    // these steps are also sequential we first apply the f to calculate out
    // then if the no == 1 then invert the resulting out

    if(out == 0) => zr = 1
    if(out < 0 ) => ng = 1

    // if the above conditions are not satisfied we the status (zr, ng) will be
    // set to 0
*/

module hack_alu(zx, nx, zy, ny, f, no, x, y, zr, ng, out);

    input  wire        zx;
    input  wire        nx;
    input  wire        zy;
    input  wire        ny;
    input  wire        f ;
    input  wire        no;

    input  wire [15:0] x;
    input  wire [15:0] y;

    output wire        zr;
    output wire        ng;
    output wire [15:0] out;

    //internal signals
    wire [15:0] zr_stage_x;
    wire [15:0] zr_stage_y;
    wire [15:0] ng_stage_x;
    wire [15:0] ng_stage_y;

    wire [15:0] and_out;
    wire [15:0] add_out;

    wire [15:0] f_stage_out;



    // data-flow model of the circuit

    assign zr_stage_x = (zx) ? 16'h0000 : x;
    assign zr_stage_y = (zy) ? 16'h0000 : y;

    assign ng_stage_x = (nx) ? ~zr_stage_x : zr_stage_x;
    assign ng_stage_y = (ny) ? ~zr_stage_y : zr_stage_y;

    //adder was given its own unit, so its design can be improved if the need
    //is there in future, without changing this file

    hack_adder16 inst_adder16(
        .x(ng_stage_x),
        .y(ng_stage_y),
        .out(add_out)
        );

    //bit wise AND is simple, no room for improvement so modeled with
    //just bitwise AND verilog operator

    assign and_out = ng_stage_x & ng_stage_y;

    assign f_stage_out = (f) ? add_out : and_out;

    assign out = (no) ? ~f_stage_out : f_stage_out;

    assign zr = (out == 16'h0000);
    assign ng = (out[15] == 1'b1);
endmodule
