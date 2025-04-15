module sparse(
    input  wire [7:0] A, B,
    input  wire Cin,
    output wire [7:0] Sum,
    output wire Cout
);
wire [7:0] G, P, C;  
assign G = A & B;  
assign P = A ^ B; 
assign C[0] = Cin; 
assign C[1] = G[0] | (P[0] & C[0]); 
assign C[2] = G[1] | (P[1] & C[1]); 
assign C[3] = G[2] | (P[2] & C[2]); 
assign C[4] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & C[2]);  
assign C[5] = G[4] | (P[4] & C[4]);  
assign C[6] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & C[4]);  
assign C[7] = G[6] | (P[6] & C[6]);  
FA FA0 (.a(A[0]), .b(B[0]), .cin(C[0]), .sum(Sum[0]), .cout());
FA FA1 (.a(A[1]), .b(B[1]), .cin(C[1]), .sum(Sum[1]), .cout());
FA FA2 (.a(A[2]), .b(B[2]), .cin(C[2]), .sum(Sum[2]), .cout());
FA FA3 (.a(A[3]), .b(B[3]), .cin(C[3]), .sum(Sum[3]), .cout());
FA FA4 (.a(A[4]), .b(B[4]), .cin(C[4]), .sum(Sum[4]), .cout());
FA FA5 (.a(A[5]), .b(B[5]), .cin(C[5]), .sum(Sum[5]), .cout());
FA FA6 (.a(A[6]), .b(B[6]), .cin(C[6]), .sum(Sum[6]), .cout());
FA FA7 (.a(A[7]), .b(B[7]), .cin(C[7]), .sum(Sum[7]), .cout(Cout));
endmodule

module FA(
    input  wire a, b, cin,
    output wire sum, cout
);
assign sum  = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);
endmodule
