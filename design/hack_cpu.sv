/*
    The "HACK" CPU, is the brains behind the "HACK" computer.
*/


module hack_cpu(clock, reset, instr, mem_in, wr_mem, mem_out, wr_addr, pc);

    input  wire         clock;
    input  wire         reset;
    input  wire [15:0]  instr;
    input  wire [15:0]  mem_in;

    output wire         wr_mem;
    output wire [15:0]  mem_out;
    output wire [14:0]  wr_addr;
    output wire [14:0]  pc;

    //internal signals
    wire [15:0] out_reg_a;
    wire [15:0] aluin1;
    wire [15:0] aluin2;
    wire [15:0] mux_a;
    wire [15:0] pc_out;

    wire        load_a;
    wire        load_d;
    wire        load_pc;
    wire        zr;
    wire        ng;
    wire        po;

    //hack alu
    hack_alu inst_hack_alu(
            .zx (instr[11]),
            .nx (instr[10]),
            .zy (instr[9]),
            .ny (instr[8]),
            .f  (instr[7]),
            .no (instr[6]),
            .x  (aluin1),
            .y  (aluin2),
            .zr (zr),
            .ng (ng),
            .out(mem_out)
        );

    hack_register16 reg_a(
            .clock(clock),
            .reset(reset),
            .load(load_a),
            .in(mux_a),
            .out(out_reg_a)
        );

    hack_register16 reg_d(
            .clock(clock),
            .reset(reset),
            .load(load_d),
            .in(mem_out),
            .out(aluin1)
        );

    hack_pc inst_pc(
            .clock    (clock),
            .reset    (reset),
            .load     (load_pc),
            .increment(1'b1),
            .in       (out_reg_a),
            .out      (pc_out)
        );

    assign po = ~(ng | zr);

    assign mux_a  = (instr[15]) ? (mem_out) : (instr);
    assign aluin2 = (instr[12]) ? (mem_in) : (out_reg_a);

    assign load_a   = (~instr[15]) | instr[5];
    assign load_pc  = instr[15] & (|(instr[2:0] & {ng, zr, po}));
    assign load_d   = instr[15] & instr[4];

    assign wr_mem  = instr[15] & instr[3];
    assign pc      = pc_out[14:0];
    assign wr_addr = (wr_mem) ? out_reg_a[14:0] : instr[14:0];
endmodule
