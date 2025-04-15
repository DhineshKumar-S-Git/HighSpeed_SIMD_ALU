module tb_SIMD_ALU;
  parameter N=2;
  // Inputs
  reg [31:0] a, b;
  reg [15:0] opcode;
  reg clk,reset;
  reg [3:0] Cin;

  // Outputs
  wire [63:0] out;
  wire [3:0] carry;
  wire [3:0] borrow;

  // Instantiate the SIMD_ALU module
  simd #(N) uut (
    .a(a),
    .b(b),
    .opcode(opcode),
    .clk(clk),
    .reset(reset),
    .Cin(Cin),
    .out(out),
    .carry(carry),
    .borrow(borrow)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Initialize inputs
    clk = 0;
    a = 0;
    b = 0;
    opcode = 0;
    Cin = 0;
    reset = 1;
    #10; reset = 0;

    // Apply test vectors
    a = 32'h12341234; 
    b = 32'h43214321; 

    opcode = 16'h1231;
    #10;

    opcode = 16'h4567;
    #10;
    // Test logical left shift

    opcode = 16'h89AB;
    #10;
    // Test default case
    opcode = 16'hCCCC;
    #20;
    
    $stop;  // End simulation
  end

endmodule
