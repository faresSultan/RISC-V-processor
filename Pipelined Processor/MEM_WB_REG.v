module MEM_WB_REG(
    input clk,rst_n,RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0] ALUresultM, ReadDataM,PCPlus4M,
    input [4:0] RdM,

    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [31:0] ALUresultW, ReadDataW, PCPlus4W,
    output reg [4:0] RdW

);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            RegWriteW <= 0;
            ResultSrcW <= 0;
            ALUresultW <= 0;
            ReadDataW <= 0;
            PCPlus4W <= 0;
            RdW <= 0;
        end else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            ALUresultW <= ALUresultM;
            ReadDataW <= ReadDataM;
            PCPlus4W <= PCPlus4M;
            RdW <= RdM;
        end
    end

endmodule