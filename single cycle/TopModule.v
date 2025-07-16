module TopModule(rst_n,clk,Instruction);
    input rst_n,clk;
    output [31:0] Instruction;

    wire [31:0] nextInstructionAddress,currentInstructionAddress,currentInstructionAddressP4;
    wire [31:0] ALUoprand1,ALUoprand2;
    wire [31:0] Read_data2;
    wire [31:0] Write_data;
    wire [4:0] Write_register;
    wire [31:0] ImmediateValue;

    wire [3:0] ALUfunction;
    wire Zero;
    wire [31:0] ALUresult;

    wire ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch;
    wire [1:0] ALUOp;
    wire [31:0] DataMemOut;
    
//========================================
    PC pc(.rst_n(rst_n),.clk(clk),.nextInstructionAddress(nextInstructionAddress),
    .currentInstructionAddress(currentInstructionAddress));

    ADD4 add4(.currentInstructionAddress(currentInstructionAddress),.nextInstructionAddress(currentInstructionAddressP4));

    BranchModule Next_Instruction(.Branch(Branch),.ImmediateValue(ImmediateValue),.Zero(Zero),
    .currentInstructionAddress(currentInstructionAddressP4),.nextInstructionAddress(nextInstructionAddress));

    InstructionMemory instructionMem(.ReadAddress(currentInstructionAddress),.Instruction(Instruction));
    
    RegisterFile RF (.clk(clk),.Read_register1(Instruction[25:21]),.Read_register2(Instruction[20:16]),
    .Write_register(Write_register),.Write_data(Write_data),.RegWrite(RegWrite),
    .Read_data1(ALUoprand1),.Read_data2(Read_data2));

    ImmGen immGen(.Opcode(Instruction[6:0]), .instruction(Instruction), .ImmExt(ImmediateValue));
    
    ControlUnit CU(.Opcode(Instruction[6:0]),.ALUSrc(ALUSrc),.MemtoReg(MemtoReg),.RegWrite(RegWrite),
    .MemRead(MemRead),.MemWrite(MemWrite),.Branch(Branch),.ALUOp(ALUOp));

    ALU_Control ALU_CTR(.ALUOp(ALUOp),.fun3(Instruction[14:12]),.fun7(Instruction[30]),.ALUfunction(ALUfunction));

    ALU alu (.ALUoprand1(ALUoprand1),.ALUoprand2(ALUoprand2),.ALUOP(ALUfunction),.Zero(Zero),.ALUresult(ALUresult));

    DataMemory DataMem (.clk(clk),.MemRead(MemRead),.MemWrite(MemWrite),.Address(ALUresult),
    .Write_data(Read_data2),.Read_data(DataMemOut));


//======================================

    assign ALUoprand2 = (ALUSrc)? ImmediateValue : Read_data2;
    assign Write_data = (MemtoReg)? DataMemOut : ALUresult;
    assign Write_register = Instruction[11:7];

endmodule
