module simd #(parameter N=2) (a,b,opcode,out,clk,reset,Cin,carry,borrow);
 input[31:0] a,b;
 input[15:0] opcode;
 input clk,reset;
 input [3:0] Cin;
 output reg[63:0] out;
 output reg[3:0] carry;
 output reg[3:0] borrow;
 
 wire [7:0] add_out0, add_out1, add_out2, add_out3;
 wire [7:0] sub_out0, sub_out1, sub_out2, sub_out3;
 wire [7:0] shift_out0, shift_out1, shift_out2, shift_out3;
 wire [15:0] mul_out0, mul_out1, mul_out2, mul_out3;
 wire [63:0] mat_out;
 
 wire add_carry0, add_carry1, add_carry2, add_carry3;
 wire sub_borrow0, sub_borrow1, sub_borrow2, sub_borrow3;
 
 sparse           alu1_lane1(.A(a[7:0]), .B(b[7:0]), .Cin(Cin[0]),.Sum(add_out0), .Cout(add_carry0));
 subtractor       alu2_lane1(.A(a[7:0]), .B(b[7:0]), .Bin(Cin[0]), .Diff(sub_out0), .Bout(sub_borrow0));
 dadda_multiplier alu3_lane1(.a(a[7:0]), .b(b[7:0]), .p(mul_out0));
 barrel_shifter   alu5_lane1(.data_in(a[7:0]), .shift_amt(b[7:0]), .opcode(opcode[3:0]), .data_out(shift_out0));
 
 sparse           alu1_lane2(.A(a[15:8]), .B(b[15:8]), .Cin(Cin[1]),.Sum(add_out1), .Cout(add_carry1));
 subtractor       alu2_lane2(.A(a[15:8]), .B(b[15:8]), .Bin(Cin[1]), .Diff(sub_out1), .Bout(sub_borrow1));
 dadda_multiplier alu3_lane2(.a(a[15:8]), .b(b[15:8]), .p(mul_out1));
 barrel_shifter   alu5_lane2(.data_in(a[15:8]), .shift_amt(b[15:8]), .opcode(opcode[7:4]), .data_out(shift_out1));
 
 sparse           alu1_lane3(.A(a[23:16]), .B(b[23:16]), .Cin(Cin[2]),.Sum(add_out2), .Cout(add_carry2));
 subtractor       alu2_lane3(.A(a[23:16]), .B(b[23:16]), .Bin(Cin[2]), .Diff(sub_out2), .Bout(sub_borrow2));
 dadda_multiplier alu3_lane3(.a(a[23:16]), .b(b[23:16]), .p(mul_out2));
 barrel_shifter   alu5_lane3(.data_in(a[23:16]), .shift_amt(b[23:16]), .opcode(opcode[11:8]), .data_out(shift_out2));
 
 sparse           alu1_lane4(.A(a[31:24]), .B(b[31:24]), .Cin(Cin[3]),.Sum(add_out3), .Cout(add_carry3));
 subtractor       alu2_lane4(.A(a[31:24]), .B(b[31:24]), .Bin(Cin[3]), .Diff(sub_out3), .Bout(sub_borrow3));
 dadda_multiplier alu3_lane4(.a(a[31:24]), .b(b[31:24]), .p(mul_out3));
 barrel_shifter   alu5_lane4(.data_in(a[31:24]), .shift_amt(b[31:24]), .opcode(opcode[15:12]), .data_out(shift_out3));
 
 matrix #(N)      alu6(.mat_a(a), .mat_b(b), .mat_c(mat_out));
 
initial begin
   carry = 0; borrow = 0; out = 64'b0;
end

always @(posedge clk or posedge reset)
  begin
  if (reset) begin
        out <= 63'b0;
        carry <= 4'b0;
        borrow <= 4'b0;
   end 
   else begin
   case(opcode[3:0])                                     // Lane 1
            4'b0001: begin                               // ADD
                out[15:0] <= {8'b0, add_out0}; 
                carry[0] <= add_carry0;      
            end
            4'b0010: begin                               // SUBTRACT
                out[15:0] <= {8'b0, sub_out0}; 
                borrow[0] <= sub_borrow0;    
            end
            4'b0011: begin                               // MULTIPLY
                out[15:0] <= mul_out0; 
            end
            4'b0100: out[15:0] <= {8'b0, a[7:0] & b[7:0]};  // AND operation (8-bit result extended)
            4'b0101: out[15:0] <= {8'b0, a[7:0] | b[7:0]};   // OR operation
            4'b0110: out[15:0] <= {8'b0, a[7:0] ^ b[7:0]};   // XOR operation
            4'b0111: out[15:0] <= {8'b0, ~a[7:0]};             // NOT operation
            4'b1000: out[15:0] <= {8'b0, shift_out0};       // Logical shift Left
            4'b1001: out[15:0] <= {8'b0, shift_out0};       // Logical shift right
            4'b1010: out[15:0] <= {8'b0, shift_out0};       // Rotate left
            4'b1011: out[15:0] <= {8'b0, shift_out0};       // Rotate right
            4'b1100: out[63:0] <= mat_out;
            4'b1101: begin out[63:60] <= (a[31:30] * b[31:30]) + (a[29:28] * b[23:22]) + (a[27:26] * b[15:14]) + (a[25:24] * b[7:6]);
                 out[59:56] <= (a[31:30] * b[29:28]) + (a[29:28] * b[21:20]) + (a[27:26] * b[13:12]) + (a[25:24] * b[5:4]);
                 out[55:52] <= (a[31:30] * b[27:26]) + (a[29:28] * b[19:18]) + (a[27:26] * b[11:10]) + (a[25:24] * b[3:2]);
                 out[51:48] <= (a[31:30] * b[25:24]) + (a[29:28] * b[17:16]) + (a[27:26] * b[9:8])  + (a[25:24] * b[1:0]); end

            default: begin
             out[15:0] <= 16'b0;
             carry[0] <= 1'b0;
             borrow[0] <= 1'b0;
            end  
   endcase
   
   case(opcode[7:4])                                       // Lane 2
            4'b0001: begin                               // ADD
                out[31:16] <= {8'b0, add_out1}; 
                carry[1] <= add_carry1;      
            end
            4'b0010: begin                               // SUBTRACT
                out[31:16] <= {8'b0, sub_out1}; 
                borrow[1] <= sub_borrow1;    
            end
            4'b0011: begin                               // MULTIPLY
                out[31:16] <= mul_out1; 
            end
            4'b0100: out[31:16] <= {8'b0, a[15:8] & b[15:8]};  // AND operation (8-bit result extended)
            4'b0101: out[31:16] <= {8'b0, a[15:8] | b[15:8]};   // OR operation
            4'b0110: out[31:16] <= {8'b0, a[15:8] ^ b[15:8]};   // XOR operation
            4'b0111: out[31:16] <= {8'b0, ~a[15:8]};             // NOT operation
            4'b1000: out[31:16] <= {8'b0, shift_out1};       // Logical shift Left
            4'b1001: out[31:16] <= {8'b0, shift_out1};       // Logical shift right
            4'b1010: out[31:16] <= {8'b0, shift_out1};       // Rotate left
            4'b1011: out[31:16] <= {8'b0, shift_out1};       // Rotate right
            4'b1100: out[63:0] <= mat_out;
            4'b1101: begin  out[47:44] = (a[23:22] * b[31:30]) + (a[21:20] * b[23:22]) + (a[19:18] * b[15:14]) + (a[17:16] * b[7:6]);
               out[43:40] = (a[23:22] * b[29:28]) + (a[21:20] * b[21:20]) + (a[19:18] * b[13:12]) + (a[17:16] * b[5:4]);
               out[39:36] = (a[23:22] * b[27:26]) + (a[21:20] * b[19:18]) + (a[19:18] * b[11:10]) + (a[17:16] * b[3:2]);
               out[35:32] = (a[23:22] * b[25:24]) + (a[21:20] * b[17:16]) + (a[19:18] * b[9:8])  + (a[17:16] * b[1:0]); end
            default: begin
             out[31:16] <= 16'b0;
             carry[1] <= 1'b0;
             borrow[1] <= 1'b0;
            end  
   endcase
   
   case(opcode[11:8])                                        // Lane 3
            4'b0001: begin                               // ADD
                out[47:32] <= {8'b0, add_out2}; 
                carry[2] <= add_carry2;      
            end
            4'b0010: begin                               // SUBTRACT
                out[47:32] <= {8'b0, sub_out2}; 
                borrow[2] <= sub_borrow2;    
            end
            4'b0011: begin                               // MULTIPLY
                out[47:32] <= mul_out2; 
            end
            4'b0100: out[47:32] <= {8'b0, a[23:16] & b[23:16]};  // AND operation (8-bit result extended)
            4'b0101: out[47:32] <= {8'b0, a[23:16] | b[23:16]};   // OR operation
            4'b0110: out[47:32] <= {8'b0, a[23:16] ^ b[23:16]};   // XOR operation
            4'b0111: out[47:32] <= {8'b0, ~a[23:16]};             // NOT operation
            4'b1000: out[47:32] <= {8'b0, shift_out2};       // Logical shift Left
            4'b1001: out[47:32] <= {8'b0, shift_out2};       // Logical shift right
            4'b1010: out[47:32] <= {8'b0, shift_out2};       // Rotate left
            4'b1011: out[47:32] <= {8'b0, shift_out2};       // Rotate right
            4'b1100: out[63:0] <= mat_out;
            4'b1101: begin  out[31:28] <= (a[15:14] * b[31:30]) + (a[13:12] * b[23:22]) + (a[11:10] * b[15:14]) + (a[9:8] * b[7:6]);
                        out[27:24] <= (a[15:14] * b[29:28]) + (a[13:12] * b[21:20]) + (a[11:10] * b[13:12]) + (a[9:8] * b[5:4]);
                        out[23:20] <= (a[15:14] * b[27:26]) + (a[13:12] * b[19:18]) + (a[11:10] * b[11:10]) + (a[9:8] * b[3:2]);
                        out[19:16] <= (a[15:14] * b[25:24]) + (a[13:12] * b[17:16]) + (a[11:10] * b[9:8])  + (a[9:8] * b[1:0]);end
            default: begin
             out[47:32] <= 16'b0;
             carry[2] <= 1'b0;
             borrow[2] <= 1'b0;
            end 
   endcase
   
   case(opcode[15:12])                                        // Lane 4
            4'b0001: begin                               // ADD
                out[63:48] <= {8'b0, add_out3}; 
                carry[3] <= add_carry3;      
            end
            4'b0010: begin                               // SUBTRACT
                out[63:48] <= {8'b0, sub_out3}; 
                borrow[3] <= sub_borrow3;    
            
            
            end
            4'b0011: begin                               // MULTIPLY
                out[63:48] <= mul_out3; 
            end
            4'b0100: out[63:48] <= {8'b0, a[31:24] & b[31:24]};  // AND operation (8-bit result extended)
            4'b0101: out[63:48] <= {8'b0, a[31:24] | b[31:24]};   // OR operation
            4'b0110: out[63:48] <= {8'b0, a[31:24] ^ b[31:24]};   // XOR operation
            4'b0111: out[63:48] <= {8'b0, ~a[31:24]};             // NOT operation
            4'b1000: out[63:48] <= {8'b0, shift_out3};       // Logical shift Left
            4'b1001: out[63:48] <= {8'b0, shift_out3};       // Logical shift right
            4'b1010: out[63:48] <= {8'b0, shift_out3};       // Rotate left
            4'b1011: out[63:48] <= {8'b0, shift_out3};       // Rotate right
            4'b1100: out[63:0]  <= mat_out;
            4'b1011: begin out[15:12] <= (a[7:6] * b[31:30]) + (a[5:4] * b[23:22]) + (a[3:2] * b[15:14]) + (a[1:0] * b[7:6]);
                       out[11:8]  <= (a[7:6] * b[29:28]) + (a[5:4] * b[21:20]) + (a[3:2] * b[13:12]) + (a[1:0] * b[5:4]);
                       out[7:4]   <= (a[7:6] * b[27:26]) + (a[5:4] * b[19:18]) + (a[3:2] * b[11:10]) + (a[1:0] * b[3:2]);
                       out[3:0]   <= (a[7:6] * b[25:24]) + (a[5:4] * b[17:16]) + (a[3:2] * b[9:8])  + (a[1:0] * b[1:0]);end
            default: begin
             out[63:48] <= 16'b0;
             carry[3] <= 1'b0;
             borrow[3] <= 1'b0;
            end  
   endcase
   end
  end
endmodule
    
   
