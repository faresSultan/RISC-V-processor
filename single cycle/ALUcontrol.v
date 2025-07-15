module ALU_Control (ALUOp, fun7, fun3, ALUfunction);

input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] ALUfunction;

always @(*) begin
    case ({ALUOp, fun7, fun3})
        6'b00_0_000: ALUfunction <= 4'be00;
        6'b00_0_001: ALUfunction <= 4'be01;
        6'b00_0_010: ALUfunction <= 4'be10;
        6'b00_0_011: ALUfunction <= 4'be11;
        6'b00_0_100: ALUfunction <= 4'be00;
        6'b00_0_101: ALUfunction <= 4'be01;
        6'b00_0_110: ALUfunction <= 4'be10;
        6'b00_0_111: ALUfunction <= 4'be11;
    endcase
end

endmodule