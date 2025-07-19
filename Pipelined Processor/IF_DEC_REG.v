module IF_DEC_REG (
    input clk,rst_n,StallD,FlushD,

    input [31:0] InstrFetched, PCF,PCPlus4F,

    output reg [31:0] InstrD, PCD, PCPlus4D
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || FlushD) begin
            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;
        end else if (!StallD) begin
                InstrD <= InstrFetched;
                PCD <= PCF;
                PCPlus4D <= PCPlus4F;        
        end
    end

endmodule