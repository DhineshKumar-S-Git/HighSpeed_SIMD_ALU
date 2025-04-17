In this project, we have designed a 8-bit high speed ALU using Verilog language that performs various arithmetic operation which includes Addition, Subtraction, Multiplication and Logical operations which includes AND, OR, NOT, XOR and Shifting operations includes Logical shift right, Logical shift Left, Rotate Right and Rotate Left. To increase the speed of operation and decrease the latency in ALU, we have used various algorithms for each operation. Arithmetic Operation:
	Addition     - Sparse Kogge Stone Adder
	Subtraction  - Sparse Kogge Stone Subtracter
    Multiplication - Dadda Multiplier
	Logical Operation: Logical Gates  - AND, OR, NOT, XOR
	Shifting Operation - Barrel Shifter

SIMD (Single Instruction Multiple Data)
	To further increase the speed of operation, we have used SIMD, a type of parallel processing where a single instruction operates on multiple data elements simultaneously. It is widely used in vector processing, multimedia applications, AI acceleration, and scientific computing to improve performance and efficiency. Further we have added Matrix Multiplication, a fundamental operation in AI, graphics processing and scientific computing.

Sparse Kogge Stone Adder
	The Sparse Kogge-Stone Adder (SKSA) is a high-speed parallel prefix adder that balances area, power, and speed by reducing the number of black cells compared to a regular Kogge-Stone Adder (KSA). It is widely used in high-performance ALUs, GPUs, and DSPs. Structure of Sparse Kogge-Stone Adder Like the Kogge-Stone Adder (KSA), SKSA follows three main stages:
	A. Preprocessing Stage (Generate & Propagate)
		Each bit computes:
			Gi= Ai ⋅Bi
			Pi=Ai⊕Bi
		where: Gi (Generate) → Carry generated at bit i,  Pi (Propagate) → Carry propagation at bit i
	B. Carry Computation Stage (Parallel Prefix)
		 Unlike KSA, which uses full carry computation for all bits, SKSA computes carries at every alternate (sparse) stage. 
		 Reduces the number of black cells (full prefix operations). 
		 Retains gray cells (final carry computation).
	 C. Sum Computation Stage
		The sum bits are computed as:
			Si=Pi⊕Ci
		where Ci is the carry propagated from the previous stage. Black Cell – computes both propagate and generate functions for a group of bits. Gray Cell – computes only the 		generate function (carry computation).

Dadda Multiplier
	The Dadda multiplier is a high-speed binary multiplier that optimizes the Wallace Tree multiplier by reducing the number of half adders. It is widely used in DSPs, ALUs, GPUs, and FPGAs due to its low delay and efficient area usage. 
Working of Dadda Multiplier
The Dadda multiplier consists of three main steps:
	Step 1: Partial Product Generation
		 The multiplier generates partial products using AND gates. 
		 For an N-bit multiplication, we get N x N partial products. 
	Step 2: Column Reduction Using Dadda’s Technique
		 Unlike Wallace Tree, Dadda delays full adder usage to reduce hardware complexity. 
		 The reduction follows Dadda’s threshold values:
			o Select a target height dn (smallest power of 3). 
			o Reduce each column only when exceeding the target height. 
			o First use full adders (3→2), then half adders (2→1).
			o Move to the next stage with a reduced height. 
	Step 3: Final Addition
		 The final sum is computed using a fast adder (like Ripple Carry Adder or Kogge-Stone Adder). Dadda defines a sequence of maximum row heights (hi) that the matrix must follow. 
Formula:
		ℎi = [ 1.5 × ℎi+1 ]
where: 
	 ℎi is the maximum allowed height at stage i. 
   ℎi+1 is the height in the next reduction stage. 
The sequence continues until the last height is 2 (for final summation). For an 8×8 Dadda multiplier, we start with 8 rows (since we generate an 8×8 partial product matrix). Find Maximum Heights Using the Formula:
	o Start with the final stage where h = 2. 
	o Apply the formula repeatedly. 
	Stage 		Formula 		Max Height hi
	Final 		h4=2 			      2
	Step 3 		h3=⌊1.5×2⌋=3 		      3
	Step 2		h2=⌊1.5×3⌋=4 		      4
	Step 1 		h1=⌊1.5×4⌋=6 		      6
	Initial 	h0=8 			      8
So, the allowed heights at each reduction step are: 8 → 6 → 4 → 3 → 2.

Barrel Shifter
	A barrel shifter is a high-speed digital circuit used to perform bitwise shifting and rotation operations efficiently. It can shift a binary number left or right by multiple positions in one clock cycle using a multiplexer-based structure.

Matrix Multiplication
	Matrix multiplication is a fundamental operation in digital signal processing (DSP), artificial intelligence (AI), image processing, cryptography, and scientific computing. It is widely used in neural networks, graphics rendering, and high-performance computing. Since traditional ALUs perform scalar arithmetic, they are not efficient for parallel matrix operations. Modern ALUs (like Tensor Cores in NVIDIA GPUs) integrate matrix multiplication accelerators for high-speed processing. 
Given two matrices:
	A= [a11 a21 a12 a22 ], B= [b11 b21 b12 b22 ]
	The result C = A × B is calculated as:
		C= [a11 b11 +a12 b21 a21 b11 +a22 b21
                    a11 b12 +a12 b22 a21 b12 +a22 b22 ]
	Each element of the output matrix is computed as:
		Cij =k∑ Aik ⋅Bkj

SIMD
	Single Instruction, Multiple Data (SIMD) is a parallel computing technique where a single instruction operates on multiple data elements simultaneously. It is widely used in high-performance computing (HPC), AI, DSP, multimedia processing, and cryptography. 
    Faster than scalar processing – Multiple operations in one cycle
    Used in modern CPUs, GPUs, AI accelerators – Optimized for vector/matrix operations
    Common in ALU design – Efficient for DSP, convolution, and deep learning

In this alu we have used a 16-bit opcode consists of 4 4-bit opcodes with support four different operation for a single opcode. 
Consider a 16-bit opcode:
	0001011010101100
which computes parallel processing by 4 lanes. 
	0001_0110_1010_1100
	Lane_3 Lane_2 Lane_1 Lane_0

4-bit Opcode Description
In this 8-bit High speed Alu we have used 4-bit opcode to specify each arithmetic and logical operation. 
They are listed. 
0001 – Addition
0010 – Subtraction
0011 – Multiplication
0100 – AND (&)
0101 – OR ( | )
0110 – XOR ( ^ )
0111 – NOT ( ~ )
1000 – Logical Shift Left
1001 – Logical Shift Right
1010 – Rotate Left
1011 – Rotate Right
1100 – 2x2 Matrix Multiplication
1101 – 4x4 Matrix Multiplication
