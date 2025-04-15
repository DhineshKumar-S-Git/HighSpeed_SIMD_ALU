module subtractor(
    input  wire [7:0] A, B,
    input  wire Bin, // Borrow In
    output wire [7:0] Diff, // Difference
    output reg Bout  // Borrow Out
);

  wire [7:0] B_comp; // 2's complement of B
  assign B_comp = (~B + 1) + Bin;

  wire [7:0] G, P, C;
  wire Bout1;
  
  assign G = A & B_comp; // Generate signal
  assign P = A ^ B_comp; // Propagate signal
  assign C[0] = Bin;
  assign C[1] = G[0] | (P[0] & C[0]);
  assign C[2] = G[1] | (P[1] & C[1]);
  assign C[3] = G[2] | (P[2] & C[2]);
  assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & C[2]);
  assign C[5] = G[4] | (P[4] & C[4]);
  assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & C[4]);
  assign C[7] = G[6] | (P[6] & C[6]);

  FA_sub F_A0 (.a(A[0]), .b(B_comp[0]), .cin(C[0]), .sum(Diff[0]), .cout());
  FA_sub F_A1 (.a(A[1]), .b(B_comp[1]), .cin(C[1]), .sum(Diff[1]), .cout());
  FA_sub F_A2 (.a(A[2]), .b(B_comp[2]), .cin(C[2]), .sum(Diff[2]), .cout());
  FA_sub F_A3 (.a(A[3]), .b(B_comp[3]), .cin(C[3]), .sum(Diff[3]), .cout());
  FA_sub F_A4 (.a(A[4]), .b(B_comp[4]), .cin(C[4]), .sum(Diff[4]), .cout());
  FA_sub F_A5 (.a(A[5]), .b(B_comp[5]), .cin(C[5]), .sum(Diff[5]), .cout());
  FA_sub F_A6 (.a(A[6]), .b(B_comp[6]), .cin(C[6]), .sum(Diff[6]), .cout());
  FA_sub F_A7 (.a(A[7]), .b(B_comp[7]), .cin(C[7]), .sum(Diff[7]), .cout(Bout1));
  
  always @(*)begin
   if (Bout1 ==1) begin
    Bout <=0;
   end 
   else if (Bout1 <=0)  begin
    Bout <=1;
   end
  end

endmodule

module FA_sub(
    input  wire a, b, cin,
    output wire sum, cout
);
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
