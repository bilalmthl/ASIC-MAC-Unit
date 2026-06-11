`timescale 1ns/1ps

module mac_pipelined_tb;

    localparam int DATA_WIDTH = 8;
    localparam int ACC_WIDTH  = 32;

    logic clk;
    logic rst_n;
    logic en;
    logic signed [DATA_WIDTH-1:0] a;
    logic signed [DATA_WIDTH-1:0] b;
    logic signed [ACC_WIDTH-1:0] acc_out;

    mac_pipelined #(
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .a(a),
        .b(b),
        .acc_out(acc_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        en = 0;
        a = 0;
        b = 0;

        #20;
        rst_n = 1;
        en = 1;

        a = 8'sd3;
        b = 8'sd4;
        #10;

        a = -8'sd2;
        b = 8'sd5;
        #10;

        a = 8'sd7;
        b = -8'sd3;
        #10;

        en = 0;
        a = 0;
        b = 0;

        // wait for pipeline to drain
        #50;

        $display("Final acc_out = %0d", acc_out);

        if (acc_out == -19) begin
            $display("TEST PASSED");
        end else begin
            $display("TEST FAILED expected -19 got %0d", acc_out);
        end

        $finish;
    end

endmodule