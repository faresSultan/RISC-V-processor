module hazard (
    input [4:0] Rs1E, Rs2E, RdM, Rs1D, Rs2D, RdE, RdW,
    input RegWriteM, RegWriteW, ResultSrc0,PCSrcE,
    output reg [1:0] ForwardAE, ForwardBE,
    output reg StallF, FlushE, StallD, FlushD
);
    reg lwStall;

    always@(*) begin
        if(Rs1E == RdM && RegWriteM && Rs1E != 0) begin
            ForwardAE = 2'b10; // Forward from MEM stage
        end else if (Rs1E == RdW && RegWriteW && Rs1E != 0) begin
            ForwardAE = 2'b01; // Forward from WB stage
        end else begin
            ForwardAE = 2'b00; // No forwarding
        end

        if(Rs2E == RdM && RegWriteM && Rs2E != 0) begin
            ForwardBE = 2'b10; // Forward from MEM stage
        end else if (Rs2E == RdW && RegWriteW && Rs2E != 0) begin
            ForwardBE = 2'b01; // Forward from WB stage
        end else begin
            ForwardBE = 2'b00; // No forwarding
        end

        lwStall = ResultSrc0 && (Rs1D == RdE || Rs2D == RdE);
        StallF = lwStall;
        FlushE = lwStall || PCSrcE;
        StallD = lwStall;
        FlushD = PCSrcE;
    end
    
endmodule