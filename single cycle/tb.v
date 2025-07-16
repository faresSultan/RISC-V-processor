/* Test program
    00000000000000000000000000000000   // no operation
    0000000_11001_10000_000_01101_0110011 // add x13, x16, x25
    0100000_01011_01000_000_00101_0110011 // sub x5, x8, x3
    0000000_00011_00010_111_00001_0110011 // and x1, x2, x3
    0000000_00101_01110_110_00100_0110011 // or x4, x3, x5
    000000000011_10101_000_10110_0010011  // addi x22, x21, 3
    000000000001_01000_110_01001_0010011  // ori x9, x8, 1
    000000011111_00101_010_01000_0000011  // lw x8, 15(x5)
    000000000011_00011_010_01001_0000011  // lw x9, 3(x3)
    000000_01111_00101_010_01111_0100011  // sw x15, 12(x5)
    0000000_01001_01001_000_01100_1100011 // beq x9, x9, 12
*/
module tb();
    reg clk,rst_n;
    wire [31:0]Instruction;
    
    TopModule DUT(rst_n,clk,Instruction);

    initial begin
        clk =0;

        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin

        $readmemb("insMem.dat",DUT.instructionMem.InstructionMem);
        $readmemh("RF.dat",DUT.RF.RF);
        $readmemh("dataMem.dat",DUT.DataMem.DataMem);

        rst_n = 0;
        @(negedge clk);
        rst_n = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        $stop;
    end

endmodule