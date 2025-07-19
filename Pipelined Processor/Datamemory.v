module DataMemory(clk,MemWrite,Address,Write_data,Read_data);

    input MemWrite,clk;
    input [31:0] Address,Write_data;
    output reg [31:0] Read_data;

    reg [7:0] DataMem [0:5120];
    
    // read is performed before write
    always @(posedge clk) begin
        if (MemWrite) begin
            {DataMem[Address],DataMem[Address+1],DataMem[Address+2],DataMem[Address+3]} <= Write_data; 
        end
        Read_data <= {DataMem[Address],DataMem[Address+1],DataMem[Address+2],DataMem[Address+3]};
    end

endmodule