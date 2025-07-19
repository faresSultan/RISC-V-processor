module MUX2#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input sel,
    output [DATA_WIDTH-1:0] out
);
    assign out = sel ? b : a;
endmodule

module MUX3#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    input [DATA_WIDTH-1:0] c,
    input [1:0] sel,
    output [DATA_WIDTH-1:0] out
);
    assign out = (sel == 2'b00) ? a :
                 (sel == 2'b01) ? b :
                 (sel == 2'b10) ? c : 32'b0; // Default case
endmodule