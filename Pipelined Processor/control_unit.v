module ControlUnit(
    input [6:0] Opcode,
    
    output reg RegWriteD,MemWriteD, JumpD, BranchD, ALUSrcD,
    output reg [1:0] ResultSrcD, ImmSrcD,
    output reg [1:0] ALUOp
);

    always @(*) begin
        case (Opcode)
            7'b0110011: begin // R-type
                RegWriteD = 1;
                MemWriteD = 0;
                JumpD = 0;
                BranchD = 0;
                ALUSrcD = 0;
                ResultSrcD = 2'b00; // ALU result
                ImmSrcD = 2'b00; // No immediate value
                ALUOp = 2'b10; // ALU operation for R-type
            end
            
            7'b0000011: begin // Lw
                RegWriteD = 1;
                MemWriteD = 0;
                JumpD = 0;
                BranchD = 0;
                ALUSrcD = 1; // Use immediate value
                ResultSrcD = 2'b01; // Memory data
                ImmSrcD = 2'b00; // Load immediate value
                ALUOp = 2'b00; // ALU operation for load
            end
            
            7'b0100011: begin // Sw
                RegWriteD = 0;
                MemWriteD = 1;
                JumpD = 0;
                BranchD = 0;
                ALUSrcD = 1; // Use immediate value
                ResultSrcD = 2'b00; // No write back
                ImmSrcD = 2'b01; // Store immediate value
                ALUOp = 2'b00; // ALU operation for store
            end

            7'b1100011: begin // Branch
                RegWriteD = 0;
                MemWriteD = 0;
                JumpD = 0;
                BranchD = 1; // Enable branching
                ALUSrcD = 0; // No immediate value for ALU
                ResultSrcD = 2'b00; // No write back
                ImmSrcD = 2'b10; // Branch immediate value
                ALUOp = 2'b01; // ALU operation for branch
            end

            7'b1101111: begin // Jal
                RegWriteD = 1;
                MemWriteD = 0;
                JumpD = 1; // Enable jump
                BranchD = 0;
                ALUSrcD = 0; // No immediate value for ALU
                ResultSrcD = 2'b10; // PC + 4 for jump
                ImmSrcD = 2'b11; // Jump immediate value
                ALUOp = 2'b00; // ALU operation for jump
            end

            7'b0010011: begin // I-type ALU operations
                RegWriteD = 1;
                MemWriteD = 0;
                JumpD = 0;
                BranchD = 0;
                ALUSrcD = 1; // Use immediate value
                ResultSrcD = 2'b00; // ALU result
                ImmSrcD = 2'b00; // Immediate value for I-type
                ALUOp = 2'b10; // ALU operation for I-type
                
            end
            
            default: begin // Default case for unsupported opcodes
                RegWriteD = 0;
                MemWriteD = 0;
                JumpD = 0;
                BranchD = 0;
                ALUSrcD = 0;
                ResultSrcD = 2'b00; 
                ImmSrcD = 2'b00; 
                ALUOp = 2'b00; 
            end
        endcase
    end
    
endmodule