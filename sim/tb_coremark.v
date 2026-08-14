`timescale 1ns/1ns

module tb_coremark #(parameter size = 32)();

    reg clk;
    reg rst;

    wire        Irq_Timer_i = 0;
    wire        Irq_Ext_i = 0;
    wire        Irq_software_i = 0;
    
    wire        DMem_Interface_Req_Ready_i = 1'b1;
    wire        Imem_Interface_Valid_i;
    wire        Imem_Interface_Stall_o;
    wire        Imem_Interface_Req_o;
    wire        DMem_Interface_Req_Valid_o;
    wire        DMem_Interface_Read_En_o;
    wire        DMem_Interface_Write_En_o;
    wire [3:0]  DMem_Interface_Wstrb_o;

    wire [31:0] Imem_Interface_Data_i;
    reg  [31:0] DMem_Interface_Data_i;
    wire [31:0] Imem_Interface_Addr_o;
    wire [31:0] DMem_Interface_Data_o;
    wire [31:0] DMem_Interface_Addr_o;

    TERME #(.size(size)) dut (
        .clk                        (clk),
        .rst                        (rst),
        .Irq_Timer_i                (Irq_Timer_i),
        .Irq_Ext_i                  (Irq_Ext_i),
        .Irq_software_i             (Irq_software_i),
        .DMem_Interface_Req_Ready_i (DMem_Interface_Req_Ready_i),
        .Imem_Interface_Valid_i     (Imem_Interface_Valid_i),
        .Imem_Interface_Stall_o     (Imem_Interface_Stall_o),
        .Imem_Interface_Req_o       (Imem_Interface_Req_o),
        .DMem_Interface_Req_Valid_o (DMem_Interface_Req_Valid_o),
        .DMem_Interface_Read_En_o   (DMem_Interface_Read_En_o),
        .DMem_Interface_Write_En_o  (DMem_Interface_Write_En_o),
        .DMem_Interface_Wstrb_o     (DMem_Interface_Wstrb_o),
        .Imem_Interface_Data_i      (Imem_Interface_Data_i),
        .DMem_Interface_Data_i      (DMem_Interface_Data_i),
        .Imem_Interface_Addr_o      (Imem_Interface_Addr_o),
        .DMem_Interface_Data_o      (DMem_Interface_Data_o),
        .DMem_Interface_Addr_o      (DMem_Interface_Addr_o)
    );

    parameter CLINT_BASE   = 32'h02000000;
    parameter UART_TX_ADDR = 32'h10000000;
    parameter SIMEND_ADDR  = 32'h20000000;
    
    wire is_mem     = (DMem_Interface_Addr_o < 32'h00040000);
    wire clint_sel  = (DMem_Interface_Addr_o >= CLINT_BASE) && (DMem_Interface_Addr_o < CLINT_BASE + 32'h0001_0000);
    wire uart_sel   = (DMem_Interface_Addr_o == UART_TX_ADDR);
    wire simend_sel = (DMem_Interface_Addr_o == SIMEND_ADDR);

    wire [31:0] mem_dmem_rdata;
    
    Shared_Memory memory_system (
        .clk        (clk),
        
        .imem_req   (Imem_Interface_Req_o),
        .imem_addr  (Imem_Interface_Addr_o),
        .imem_rdata (Imem_Interface_Data_i),
        
        .dmem_ren   (DMem_Interface_Read_En_o && is_mem),
        .dmem_wen   (DMem_Interface_Write_En_o && DMem_Interface_Req_Valid_o && is_mem),
        .dmem_wstrb (DMem_Interface_Wstrb_o),
        .dmem_addr  (DMem_Interface_Addr_o),
        .dmem_wdata (DMem_Interface_Data_o),
        .dmem_rdata (mem_dmem_rdata)
    );

    assign Imem_Interface_Valid_i = Imem_Interface_Req_o;

    always @(*) begin
        if (is_mem) begin
            DMem_Interface_Data_i = mem_dmem_rdata;
        end else begin
            DMem_Interface_Data_i = 32'h00000000;
        end
    end

    always @(posedge clk) begin
        if (DMem_Interface_Write_En_o && DMem_Interface_Req_Valid_o) begin
            if (uart_sel) begin
                $write("%c", DMem_Interface_Data_o[7:0]);
            end 
            else if (simend_sel) begin
                $display("\n=============================================");
                $display("   COREMARK FINISHED - SIMEND write detected  ");
                $display("   Exit code written: %0d", DMem_Interface_Data_o);
                $display("   Total cycles: %0d", cycle_count);
                $display("=============================================\n");
                $finish;
            end
        end
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #20 rst = 0;
    end

    integer cycle_count = 0;
    integer hang_counter = 0;
    reg [31:0] last_pc = 32'hFFFFFFFF;

    always @(posedge clk) begin
        if (!rst) begin
            cycle_count <= cycle_count + 1;
            
            if (cycle_count > 100 && Imem_Interface_Addr_o == 32'h00000000) begin
                $display("\n[FATAL ERROR] CPU Trap/Exception detected!");
                $finish;
            end

            if (Imem_Interface_Req_o) begin
                if (Imem_Interface_Addr_o == last_pc) hang_counter <= hang_counter + 1;
                else hang_counter <= 0;
                last_pc <= Imem_Interface_Addr_o;
            end

            if (hang_counter > 1000) begin
                $display("\n[WATCHDOG] PC stuck, SIMEND never written.");
                $finish;
            end
        end
    end
   
endmodule