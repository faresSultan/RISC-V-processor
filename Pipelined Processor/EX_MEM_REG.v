module EX_MEM_REG(
    input clk,rst_n,RegWriteE,MemWriteE,
    input [1:0] ResultSrcE,
    input [31:0] ALUresultE,PCPlus4E,WriteDataE,
    input [4:0] RdE,

    output reg RegWriteM,MemWriteM,
    output reg [1:0] ResultSrcM,
    output reg [31:0] ALUresultM, WriteDataM, PCPlus4M,
    output reg [4:0] RdM

);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteM <= 0;
            MemWriteM <= 0;
            ResultSrcM <= 0;
            ALUresultM <= 0;
            WriteDataM <= 0;
            PCPlus4M <= 0;
            RdM <= 0;
        end else begin
            RegWriteM <= RegWriteE;
            MemWriteM <= MemWriteE;
            ResultSrcM <= ResultSrcE;
            ALUresultM <= ALUresultE;
            WriteDataM <= WriteDataE;
            PCPlus4M <= PCPlus4E;
            RdM <= RdE;
        end
    end

endmodule