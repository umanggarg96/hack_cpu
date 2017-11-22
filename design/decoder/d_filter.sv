module d_filter(clk, reset, in_a, in_b, filtered_a, filtered_b);

    input  wire clk;
    input  wire reset;
    input  wire in_a;
    input  wire in_b;

    output wire filtered_a;
    output wire filtered_b;


    reg [3:0] reg_a;
    reg [3:0] reg_b;

    always @(posedge clk)
        if(reset)  reg_a <= 4'b0000;
        else       reg_a <= {reg_a[2:0], in_a};

    always @(posedge clk)
        if(reset)  reg_b <= 4'b0000;
        else       reg_b <= {reg_b[2:0], in_b};

    assign filtered_a = &reg_a;
    assign filtered_b = &reg_b;

endmodule

