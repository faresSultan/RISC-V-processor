module ALU (ALUoprand1,ALUoprand2,ALUOP,Zero,ALUresult);

input [31:0] ALUoprand1,ALUoprand2;
input [2:0] ALUOP;
output reg signed[31:0] ALUresult;
output Zero;

always @(*) begin
    case (ALUOP)
        3'b010: ALUresult = ALUoprand1 & ALUoprand2;
        3'b011: ALUresult = ALUoprand1 | ALUoprand2;
        3'b000: ALUresult = ALUoprand1 + ALUoprand2;
        3'b101: ALUresult = ALUoprand1 < ALUoprand2 ? 32'b1 : 32'b0; // SLT 
        3'b001: ALUresult = ALUoprand1 - ALUoprand2; 
        default: ALUresult = 32'b0; 
    endcase
end

assign Zero = (ALUresult === 0);
    
endmodule
