module barrel_shifter (
    input [7:0] data_in,        // Input Data
    input [2:0] shift_amt,      // Shift Amount (0 to 7)
    input [3:0] opcode,         // 8-bit Opcode
    output reg [7:0] data_out   // Output Data
);

    wire [7:0] stage1, stage2, stage3;

    // Stage 1: Shift or Rotate by 1 bit
    assign stage1 = shift_amt[0] ? 
                    (opcode == 8'b1000 ? {data_in[6:0], 1'b0} :       // Logical Left Shift
                     opcode == 8'b1001 ? {1'b0, data_in[7:1]} :       // Logical Right Shift
                     opcode == 8'b1010 ? {data_in[6:0], data_in[7]} : // Rotate Left
                     opcode == 8'b1011 ? {data_in[0], data_in[7:1]} : // Rotate Right
                     data_in) : data_in;

    // Stage 2: Shift or Rotate by 2 bits
    assign stage2 = shift_amt[1] ? 
                    (opcode == 8'b1000 ? {stage1[5:0], 2'b00} : 
                     opcode == 8'b1001 ? {2'b00, stage1[7:2]} : 
                     opcode == 8'b1010 ? {stage1[5:0], stage1[7:6]} : 
                     opcode == 8'b1011 ? {stage1[1:0], stage1[7:2]} : 
                     stage1) : stage1;

    // Stage 3: Shift or Rotate by 4 bits
    assign stage3 = shift_amt[2] ? 
                    (opcode == 8'b1000 ? {stage2[3:0], 4'b0000} : 
                     opcode == 8'b1001 ? {4'b0000, stage2[7:4]} : 
                     opcode == 8'b1010 ? {stage2[3:0], stage2[7:4]} : 
                     opcode == 8'b1011 ? {stage2[3:0], stage2[7:4]} : 
                     stage2) : stage2;

    // Final Output
    always @(*) begin
        data_out = stage3;
    end

endmodule
