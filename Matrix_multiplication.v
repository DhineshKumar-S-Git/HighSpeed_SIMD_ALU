module matrix #(parameter N = 2) (mat_a, mat_b, mat_c);
    input [N*N*8 - 1 : 0] mat_a;    // Flattened input matrix A
    input [N*N*8 - 1 : 0] mat_b;    // Flattened input matrix B
    output reg [N*N*16 - 1 : 0] mat_c; // Flattened output matrix C

    integer i, j, k;  // Loop variables
    reg [15:0] temp_sum; // Temporary sum for partial results

    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin  
                temp_sum = 0;  
                for (k = 0; k < N; k = k + 1) begin
                    temp_sum = temp_sum + 
                               (mat_a[(i*N + k)*8 +: 8] * mat_b[(k*N +j)*8 +: 8]); 
                end
                mat_c[(i*N + j)*16 +: 16] = temp_sum;
            end
        end
    end
endmodule
