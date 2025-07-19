module DEC_EX_REG(
    input clk,rst_n,RegWriteD,MemWriteD,JumpD,BranchD,ALUSrcD,FlushE,
    input [1:0] ResultSrcD,
    input [1:0] ALUOpD,
    input [31:0]RD1D,RD2D,PCD,ImmExtD,PCPlus4D,
    input [4:0] RdD,Rs1D,Rs2D,

    output reg RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE,
    output reg [1:0] ALUOpE,
    output reg [1:0] ResultSrcE,
    output reg [31:0] RD1E,RD2E,PCE,ImmExtE,PCPlus4E,
    output reg [4:0] RdE,Rs1E,Rs2E

);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || FlushE) begin
            RegWriteE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUSrcE <= 0;
            ResultSrcE <= 2'b00;
            ALUOpE <= 2'b00;
            RD1E <= 32'b0;
            RD2E <= 32'b0;
            PCE <= 32'b0;
            ImmExtE <= 32'b0;
            PCPlus4E <= 32'b0;
            RdE <= 5'b00000;
            Rs1E <= 5'b00000;
            Rs2E <= 5'b00000;
        end else begin
            RegWriteE <= RegWriteD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUSrcE <= ALUSrcD;
            ResultSrcE <= ResultSrcD;
            ALUOpE <= ALUOpD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            PCE <= PCD;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
            RdE <= RdD;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D; 
        end
    end

endmodule