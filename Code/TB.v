module processor_tb;
  reg clk;
  reg rst;
  reg [12:0] instruction;
  wire [511:0] A [0:3];
  processor uut (
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .A(A)
  );
  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;
    instruction = 13'b0;
    // Monitor signals
    $monitor("Time=%0t, instruction=%b, A[0]=%h, A[1]=%h, A[2]=%h, A[3]=%h", 
             $time, instruction, A[0], A[1], A[2], A[3]);
    // Reset the processor
    #5 rst = 0;
    #5 rst = 1;
    // Wait for reset
    #10;
    // Test 1: Add two numbers
    // Load values into registers
    // Load value 1000 into register 0
    instruction = 13'b100_00_000000000; // load R0
    #10;
    instruction = 13'b000_00_000000001; //   instruction to wait
    #10;
    // Load value 2000 into register 1
    instruction = 13'b100_01_000000010; // load R1
    #10;
    instruction = 13'b000_00_000000001; //   instruction to wait
    #10;
    // Perform addition: R0 + R1 -> R2, R3
    instruction = 13'b000_00_000000000; // add
    #10;
    // Test 2: Multiply two numbers
    // Load value 3 into register 0
    instruction = 13'b100_00_000000011; // load R0
    #10;
    instruction = 13'b000_00_000000001; //   instruction to wait
    #10;
    // Load value 4 into register 1
    instruction = 13'b100_01_000000100; // load R1
    #10;
    instruction = 13'b000_00_000000001; //   instruction to wait
    #10;
    // Perform multiplication: R0 * R1 -> R2, R3
    instruction = 13'b001_00_000000000; // multiply
    #10;
    // Test 3: Store value to memory
    // Store the result of addition (R2) to memory address 5
    instruction = 13'b110_10_000000101; // store R2
    #10;
    // Test 4: Load value from memory
    // Load the value from memory address 5 to register 0
    instruction = 13'b101_00_000000101; // load R0
    #10;
    instruction = 13'b000_00_000000001; //   instruction to wait
    #10;
    // End of simulation
    $finish;
  end
  // Generate clock signal
  always #5 clk = ~clk;

endmodule
