module ALU_Control (ALUOp, fun7, fun3, ALUfunction, op5);

input fun7;
input [2:0] fun3;
input op5;
input [1:0] ALUOp;
output reg [2:0] ALUfunction;

always @(ALUOp or fun3 or fun7 or op5) begin
    case (ALUOp)
       2'b00 : ALUfunction = 3'b000;
       2'b01 : ALUfunction = 3'b001;
       2'b10 : begin
                case (fun3) 
                    3'b000: ALUfunction = (fun7 && op5) ? 3'b001 : 3'b000; // ADD/SUB
                    3'b010: ALUfunction = 3'b101; // SLT
                    3'b110: ALUfunction = 3'b011; // OR
                    3'b111: ALUfunction = 3'b010; // AND
                    default: ALUfunction = 3'b000; // Default case
                endcase
          end 
        default: ALUfunction = 3'b000; // Default case
    endcase
end

endmodule