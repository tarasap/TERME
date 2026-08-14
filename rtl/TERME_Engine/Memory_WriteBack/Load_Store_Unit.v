// =============================================================================
// Project Name:   TERME
// File Name:      Load_Store_Unit.v
// Author:         Tara Sarpoolaki /Tarasarpoolaki@gmail.com
// Last Modified:  2026-8-14
// Description:    
// 
// License:        CERN-OHL-S-v2
// =============================================================================
`timescale 1ns/1ns

module Load_Store_Unit #(parameter size = 32) (
    input                     clk,
    input                     rst,

    input                     LSU_Read_En_i,
    input                     LSU_Write_En_i,
    input        [       2:0] LSU_RData_Type_i,
    input        [       1:0] LSU_WData_Type_i,    
    input                     LSU_Req_Ready_i,
    output reg                LSU_Req_Valid_o,
    output reg                LSU_Read_En_o,
    output reg                LSU_Write_En_o,
    output reg   [       3:0] LSU_Wstrb_o, 
    
    input        [size - 1:0] LSU_Address_i,
    input        [size - 1:0] LSU_Store_Data_i,
    input        [size - 1:0] LSU_Load_Data_i,
    output reg   [size - 1:0] LSU_Mem_Store_o,
    output reg   [size - 1:0] LSU_Load_Data_o,
    output reg   [size - 1:0] LSU_Mem_Addr_o    
);

    localparam IDLE       = 1'b0;
    localparam WAIT_READY = 1'b1;

    wire         [       1:0] byte_offset; 
    wire         [size - 1:0] store_data;
    wire         [size - 1:0] load_data;
    
    reg                       p_state;  
    reg                       n_state;  

    assign byte_offset = LSU_Address_i[1:0];
    assign load_data   = LSU_Load_Data_i;
    assign store_data  = LSU_Store_Data_i;

    always @(*) begin
        LSU_Load_Data_o = 32'b0;
        if (LSU_Read_En_i) begin 
            case (LSU_RData_Type_i)
                3'b001: begin 
                    case (byte_offset)
                        2'b00: LSU_Load_Data_o = {{24{load_data[ 7]}}, load_data[ 7: 0]};
                        2'b01: LSU_Load_Data_o = {{24{load_data[15]}}, load_data[15: 8]};
                        2'b10: LSU_Load_Data_o = {{24{load_data[23]}}, load_data[23:16]};
                        2'b11: LSU_Load_Data_o = {{24{load_data[31]}}, load_data[31:24]};
                    endcase
                end
                3'b100: begin 
                    case (byte_offset)
                        2'b00: LSU_Load_Data_o = {24'd0, load_data[ 7: 0]};
                        2'b01: LSU_Load_Data_o = {24'd0, load_data[15: 8]};
                        2'b10: LSU_Load_Data_o = {24'd0, load_data[23:16]};
                        2'b11: LSU_Load_Data_o = {24'd0, load_data[31:24]};
                    endcase
                end
                3'b010: begin 
                    case (byte_offset[1])
                        1'b0: LSU_Load_Data_o  = {{16{load_data[15]}}, load_data[15: 0]};
                        1'b1: LSU_Load_Data_o  = {{16{load_data[31]}}, load_data[31:16]};
                    endcase
                end
                3'b101: begin 
                    case (byte_offset[1])
                        1'b0: LSU_Load_Data_o  = {16'd0, load_data[15: 0]};
                        1'b1: LSU_Load_Data_o  = {16'd0, load_data[31:16]};
                    endcase
                end
                3'b011: begin 
                    LSU_Load_Data_o = load_data;
                end
                default: LSU_Load_Data_o = load_data;
            endcase
        end
    end

    always @(*) begin
        LSU_Mem_Store_o = 32'b0;
        LSU_Wstrb_o     = 4'b0000;
        if (LSU_Write_En_i) begin
            case (LSU_WData_Type_i) 
                2'b01: begin
                    LSU_Wstrb_o = (4'b0001 << byte_offset);
                    case (byte_offset)
                        2'b00: LSU_Mem_Store_o = {24'b0, store_data[7:0]};
                        2'b01: LSU_Mem_Store_o = {16'b0, store_data[7:0],  8'b0};
                        2'b10: LSU_Mem_Store_o = { 8'b0, store_data[7:0], 16'b0};
                        2'b11: LSU_Mem_Store_o = {       store_data[7:0], 24'b0};
                    endcase
                end
                2'b10: begin
                    case (byte_offset[1]) 
                        1'b0: begin 
                            LSU_Mem_Store_o = {16'b0, store_data[15:0]};
                            LSU_Wstrb_o     = 4'b0011;
                        end
                        1'b1: begin
                            LSU_Mem_Store_o = {store_data[15:0], 16'b0};
                            LSU_Wstrb_o     = 4'b1100;
                        end
                    endcase
                end
                2'b11: begin 
                    LSU_Mem_Store_o = store_data;
                    LSU_Wstrb_o     = 4'b1111;
                end
                default: begin
                    LSU_Wstrb_o     = 4'b0000;
                    LSU_Mem_Store_o = 32'b0;
                end
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p_state <= IDLE;
        end else begin
            p_state <= n_state;
        end
    end

    always @(*) begin
        n_state         = p_state; 
        LSU_Req_Valid_o = 1'b0;
        
        case (p_state)
            IDLE: begin
                if (LSU_Read_En_i || LSU_Write_En_i) begin
                    LSU_Req_Valid_o = 1'b1;
                    if (LSU_Req_Ready_i)
                        n_state = IDLE;
                    else
                        n_state = WAIT_READY;
                        // n_state         = WAIT_READY;
                end
            end
            WAIT_READY: begin
                LSU_Req_Valid_o = 1'b1; 
                if (LSU_Req_Ready_i) begin
                    n_state         = IDLE;
                end
            end
            default: begin
                n_state = IDLE;
            end
        endcase
    end

    always @(*) begin
        LSU_Mem_Addr_o = {LSU_Address_i[31:2], 2'b00};
        LSU_Read_En_o  = LSU_Read_En_i;
        LSU_Write_En_o = LSU_Write_En_i;
    end

endmodule