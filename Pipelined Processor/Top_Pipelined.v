module top_pipelined (
    input rst_n,clk,
    output [31:0] Instruction // to probe current instruction
);

    wire [31:0] PCF,PCF_,PCPlus4F;
    wire [2:0] ALUfunction;

    wire ALUSrcD,RegWriteD,MemWriteD,BranchD;
    wire [1:0] ALUOp;
    wire [31:0] ReadDataM;

    // ============ Instruction Fetch Stage Signals ============
    wire [31:0] InstructionD;
    wire [6:0] op;
    wire [4:0] Rs1D , Rs2D, RdD;
    wire [31:0] PCD, ImmExtD, PCPlus4D;
    wire [2:0] Func3;
    wire Func7;
    wire [24:0] ImmValue;
    wire [31:0] WD3 , RD1D, RD2D;

    wire [1:0] ResultSrcD;

    assign op = InstructionD[6:0];
    assign Rs1D = InstructionD[19:15];
    assign Rs2D = InstructionD[24:20];
    assign RdD = InstructionD[11:7];
    assign ImmValue = InstructionD[31:7];
    assign Func3 = InstructionD[14:12];
    assign Func7 = InstructionD[30];

    // ============ Hazard Unit ============
    wire StallF, StallD, FlushD , FlushE;
    wire [1:0] ForwardAE, ForwardBE;
    wire [4:0] Rs1E, Rs2E, RdM, RdE, RdW;
    wire RegWriteM, RegWriteW, PCSrcE;
    wire ResultSrc0;
    wire [1:0] ResultSrcE, ResultSrcM, ResultSrcW;
    wire [1:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, ImmExtE, PCPlus4E, ALUresultE, WriteDataE;
    wire [31:0] ALUresultM, WriteDataM, PCPlus4M, ReadDataW, ALUresultW, PCPlus4W;
    wire [1:0] ImmSrcD;

    assign ResultSrc0 = ResultSrcE[0];

    hazard HU(.StallD(StallD), .StallF(StallF), .FlushD(FlushD), .FlushE(FlushE),
              .ForwardAE(ForwardAE), .ForwardBE(ForwardBE),
                .Rs1E(Rs1E), .Rs2E(Rs2E), .RdM(RdM), .Rs1D(Rs1D), .Rs2D(Rs2D),
                .RdE(RdE), .RdW(RdW), .PCSrcE(PCSrcE),
                .RegWriteM(RegWriteM), .RegWriteW(RegWriteW), .ResultSrc0(ResultSrc0));

    // ============ Pipeline Registers ============
    PC pc(.rst_n(rst_n), .clk(clk), .nextInstructionAddress(PCF_),
       .currentInstructionAddress(PCF), .StallF(StallF));
    
    ADD4 add4(.currentInstructionAddress(PCF), .nextInstructionAddress(PCPlus4F));

    IF_DEC_REG if_dec_reg(
        .rst_n(rst_n), .clk(clk), .PCF(PCF), .PCPlus4F(PCPlus4F),
        .StallD(StallD), .FlushD(FlushD),.PCD(PCD) , .PCPlus4D(PCPlus4D),
        .InstrFetched(Instruction), .InstrD(InstructionD)
    );

    DEC_EX_REG dec_ex_reg(
        .rst_n(rst_n), .clk(clk), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD),
        .JumpD(JumpD), .BranchD(BranchD), .ALUSrcD(ALUSrcD), .FlushE(FlushE),
        .ResultSrcD(ResultSrcD), .ALUOpD(ALUOp),
        .RD1D(RD1D), .RD2D(RD2D), .PCD(PCD), .ImmExtD(ImmExtD), .PCPlus4D(PCPlus4D),
        .RdD(RdD), .Rs1D(Rs1D), .Rs2D(Rs2D),
        .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .JumpE(JumpE),
        .BranchE(BranchE), .ALUSrcE(ALUSrcE), .ResultSrcE(ResultSrcE),
        .ALUOpE(ALUControlE), .RD1E(RD1E), .RD2E(RD2E), .PCE(PCE),
        .ImmExtE(ImmExtE), .PCPlus4E(PCPlus4E),
        .RdE(RdE), .Rs1E(Rs1E), .Rs2E(Rs2E)
    );

    EX_MEM_REG ex_mem_reg(
        .clk(clk), .rst_n(rst_n), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE), .ALUresultE(ALUresultE), .PCPlus4E(PCPlus4E),
        .WriteDataE(WriteDataE), .RdE(RdE),
        .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM), .ALUresultM(ALUresultM),
        .WriteDataM(WriteDataM), .PCPlus4M(PCPlus4M), .RdM(RdM)
    );

    MEM_WB_REG mem_wb_reg(
        .clk(clk), .rst_n(rst_n), .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM), .ALUresultM(ALUresultM), .ReadDataM(ReadDataM),
        .PCPlus4M(PCPlus4M), .RdM(RdM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW), .ALUresultW(ALUresultW),
        .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W), .RdW(RdW)
    );

    // ============ Control Unit ==================
    ControlUnit CU(
        .Opcode(op),
        .RegWriteD(RegWriteD), .MemWriteD(MemWriteD), .JumpD(JumpD),
        .BranchD(BranchD), .ALUSrcD(ALUSrcD), .ResultSrcD(ResultSrcD),
        .ImmSrcD(ImmSrcD), .ALUOp(ALUOp)
    );

    // ============ Instruction Memory ============
    InstructionMemory instructionMem(.ReadAddress(PCF), .Instruction(Instruction));

    // ============ Register File =================
    RegisterFile RF ( .clk(clk), .Read_register1(Rs1D), .Read_register2(Rs2D),
        .Write_register(RdW), .Write_data(WD3), .RegWrite(RegWriteW),
        .Read_data1(RD1D), .Read_data2(RD2D));

    // ============ Immediate Value Generation =======
    ImmGen immGen(.Opcode(op), .instruction(InstructionD), .ImmExt(ImmExtD));

    // ============ MUXes ============================

    wire [31:0]SrcAE, SrcBE, PCTargetE;
    assign PCTargetE = PCE + ImmExtE;

    MUX3 mux3srcAE(
        .sel(ForwardAE), .a(RD1E), .b(WD3), .c(ALUresultM), .out(SrcAE)
    );

    MUX3 mux3SrcBE(
        .sel(ForwardBE), .a(RD2E), .b(WD3), .c(ALUresultM), .out(WriteDataE)
    );

    MUX2 mux2SrcBE(
        .sel(ALUSrcE), .a(WriteDataE), .b(ImmExtE), .out(SrcBE)
    );

    // ============ ALU ============================
    wire ZeroE;
    ALU_Control aluControl(
        .ALUOp(ALUOp), .fun7(Func7), .fun3(Func3), .ALUfunction(ALUfunction), .op5(op[5])
    );

    ALU alu(.ALUoprand1(SrcAE), .ALUoprand2(SrcBE), .ALUOP(ALUfunction),
        .Zero(ZeroE), .ALUresult(ALUresultE));


    // ============ Data Memory =====================
    DataMemory dataMemory(
        .clk(clk), .MemWrite(MemWriteM), .Address(ALUresultM),
        .Write_data(WriteDataM), .Read_data(ReadDataM)
    );

    // ============ Write Back MUX ==================
    MUX3 mxWB(
        .sel(ResultSrcW), .a(ALUresultW), .b(ReadDataW), .c(PCPlus4W), .out(WD3)
    );

    // ============ PC Mux =========================
    MUX2 pcmx(
        .sel(PCSrcE), .a(PCPlus4F), .b(PCTargetE), .out(PCF_)
    );

    assign PCSrcE = (BranchE & ZeroE) | JumpE; 

    
endmodule