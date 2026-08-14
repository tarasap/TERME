// =============================================================================
// Project Name:   TERME
// File Name:      MUL_Unit.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-10
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Mul_Unit #(
    parameter size = 32
) (
    input                        clk,
    input                        rst,

    input                        Mul_Start_i,
    input                        Mul_Hi_i,
    input                        Mul_Signa_i,
    input                        Mul_Signb_i,
    output                       Mul_Busy_mul_o,
    output                       Mul_Done_mul_o,

    input         [size - 1 : 0] Operand_a_i,
    input         [size - 1 : 0] Operand_b_i,
    output        [size - 1 : 0] Mul_Result_mul_o
);



    localparam [1:0] IDLE    = 2'd0, 
                     COMPUTE = 2'd1, 
                     NEGATE  = 2'd2, 
                     DONE    = 2'd3;

    reg  [1:0]          state_q, state_d;
    wire [size - 1 : 0] op_a, op_b;
    reg  [66:0]         prod_q;
    reg  [size:0]       mcand_q;
    reg  [size:0]       mplier_q;
    reg                 negate_q;
    reg                 hi_q;
    reg  [5:0]          count;
    reg  [size:0]       abs_a, abs_b;
    wire                neg_a, neg_b, load_negate;
    reg  [33:0]         sum;
    wire                mplier_zero;
    wire [33:0]         adder_b;

    assign op_a             = Operand_a_i & {32{Mul_Start_i}};
    assign op_b             = Operand_b_i & {32{Mul_Start_i}};
    assign neg_a            = Mul_Signa_i & op_a[31];
    assign neg_b            = Mul_Signb_i & op_b[31];
    assign load_negate      = neg_a ^ neg_b;
    
    
    assign adder_b = mplier_q[0] ? {1'b0, mcand_q[32:0]} : 34'd0;
    assign Mul_Result_mul_o = hi_q ? prod_q[63:32] : prod_q[31:0];
    assign Mul_Busy_mul_o   = (state_q == COMPUTE) | (state_q == NEGATE);
    assign Mul_Done_mul_o   = (state_q == DONE);

    always @(*) begin
        if (Mul_Signa_i && op_a[31])
            abs_a = {1'b0, ~op_a} + 33'd1;
        else
            abs_a = {1'b0, op_a};

        if (Mul_Signb_i && op_b[31])
            abs_b = {1'b0, ~op_b} + 33'd1;
        else
            abs_b = {1'b0, op_b};
    end

    always @(*) begin
        state_d = state_q;
        case (state_q)
            IDLE:    if (Mul_Start_i)    state_d = COMPUTE;
            COMPUTE: if (count == 6'd32) state_d = negate_q ? NEGATE : DONE;
            NEGATE:                      state_d = DONE;
            DONE:                        state_d = IDLE;
            default:                     state_d = IDLE;
        endcase
    end

    always @(*) begin
        sum = prod_q[66:33] + adder_b;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_q  <= IDLE;
            prod_q   <= 67'd0;
            mcand_q  <= 0;
            mplier_q <= 0;
            negate_q <= 1'b0;
            hi_q     <= 1'b0;
            count    <= 6'd0;
        end else begin
            state_q <= state_d;

            case (state_q)
                IDLE: begin
                    if (Mul_Start_i) begin
                        prod_q   <= 67'd0;
                        mcand_q  <= abs_a;  
                        mplier_q <= abs_b; 
                        negate_q <= load_negate;
                        hi_q     <= Mul_Hi_i;
                        count    <= 6'd0;
                    end
                end

                COMPUTE: begin
                    prod_q   <= {1'b0, sum, prod_q[32:1]};
                    mplier_q <= {1'b0, mplier_q[32:1]};
                    count    <= count + 6'd1;
                end

                NEGATE: begin
                    prod_q[63:0] <= ~prod_q[63:0] + 64'd1;
                end

                DONE: begin
                end

                default: ;
            endcase
        end
    end

endmodule