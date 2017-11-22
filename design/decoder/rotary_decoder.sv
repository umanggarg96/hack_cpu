module rotary_decoder(clk, reset, in_a, in_b, val);

    input  wire          clk;
    input  wire          reset;
    input  wire          in_a;
    input  wire          in_b;

    output logic [8:0]   val;

    logic count_dir;
    logic count_enable;
    logic up_limit;
    logic down_limit;

    logic [2:0] in_a_delayed;
    logic [2:0] in_b_delayed;

    logic filtered_a;
    logic filtered_b;

    d_filter filter (
            .clk       (clk),
            .reset     (reset),
            .in_a      (in_a),
            .in_b      (in_b),
            .filtered_a(filtered_a),
            .filtered_b(filtered_b)
        );

    always @(posedge clk)
    begin
        if(reset)
            val <= 8'h00;
        else if(count_enable)
        begin
            if(count_dir & ~up_limit)
                val <= val + 8'h01;
            else if(~count_dir &  ~down_limit)
                val <= val - 8'h01;
            else
                val <= val;
        end
        else
            val <= val;
    end

    always @(posedge clk)
        if(reset)  in_a_delayed <= 3'b000;
        else       in_a_delayed <= {in_a_delayed[1:0], filtered_a};

    always @(posedge clk)
        if(reset)  in_b_delayed <= 3'b000;
        else       in_b_delayed <= {in_b_delayed[1:0], filtered_b};

    assign count_dir = in_a_delayed[1] ^ in_b_delayed[2];
    assign count_enable = in_a_delayed[1] ^ in_a_delayed[2] ^ in_b_delayed[1]
                                ^ in_b_delayed[2];


    assign up_limit = (val == 8'hff);
    assign down_limit = (val == 8'h00);

endmodule
