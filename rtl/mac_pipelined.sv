`timescale 1ns/1ps

module mac_pipelined #(
    parameter int DATA_WIDTH = 8,
    parameter int ACC_WIDTH  = 32
)(
    input  logic                         clk,
    input  logic                         rst_n,
    input  logic                         en,
    input  logic signed [DATA_WIDTH-1:0] a,
    input  logic signed [DATA_WIDTH-1:0] b,
    output logic signed [ACC_WIDTH-1:0]  acc_out
);

    // stage 1 input registers
    logic signed [DATA_WIDTH-1:0] a_reg;
    logic signed [DATA_WIDTH-1:0] b_reg;
    logic                         en_reg;

    // stage 2 product register
    logic signed [(2*DATA_WIDTH)-1:0] product_reg;
    logic                             en_product_reg;

    // sign-extended product
    logic signed [ACC_WIDTH-1:0] product_ext;

    assign product_ext = {{(ACC_WIDTH-(2*DATA_WIDTH)){product_reg[2*DATA_WIDTH-1]}}, product_reg};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg          <= '0;
            b_reg          <= '0;
            en_reg         <= 1'b0;
            product_reg    <= '0;
            en_product_reg <= 1'b0;
            acc_out        <= '0;
        end else begin
            // stage 1: register inputs
            a_reg  <= a;
            b_reg  <= b;
            en_reg <= en;

            // stage 2: multiply registered inputs
            product_reg    <= a_reg * b_reg;
            en_product_reg <= en_reg;

            // stage 3: accumulate registered product
            if (en_product_reg) begin
                acc_out <= acc_out + product_ext;
            end
        end
    end

endmodule