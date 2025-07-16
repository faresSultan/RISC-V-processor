module ALU_Control (ALUOp, fun7, fun3, ALUfunction);

input fun7;
input [2:0] fun3;
input [1:0] ALUOp;
output reg [3:0] ALUfunction;

always @(*) begin
    case ({ALUOp, fun7, fun3})
        6'b000000: ALUfunction <= 4'b0010;
        6'b010000: ALUfunction <= 4'b0110;
        6'b100000: ALUfunction <= 4'b0010;
        6'b101000: ALUfunction <= 4'b0110;
        6'b100111: ALUfunction <= 4'b0000;
        6'b100110: ALUfunction <= 4'b0001;
    endcase
end

endmodule