🚀 Darrant-V1: 32-bit RISC-V Multi-Cycle Processor Core
Hello! I'm Darrant Meah Wei Zhe, a first-year Electrical Engineering undergraduate at Universiti Malaya. Welcome to the repository of Darrant-V1.

This project is not just another textbook CPU. It is the result of countless hours of RTL coding, tearing down Verilog state machines, chasing elusive timing bugs, and running automated physical implementations. I built this 32-bit RISC-V multi-cycle processor core from the ground up to deeply understand computer architecture, hardware-software co-design, and industrial verification flows.

If you are a fellow hardware enthusiast, a recruiter, or just curious about processor design, feel free to explore my code!

✨ Architectural Highlights
I designed this core to be robust, precise, and highly capable, achieving 100% functional coverage of 47 target instructions:

🧠 11-State FSM Control Unit: Instead of a basic single-cycle design, I implemented a strict multi-cycle architecture. A major challenge I overcame was the bus conflict during JAL/JALR execution. By splitting the jump execution into two distinct FSM states (ExecuteJ_1 and ExecuteJ_2), I resolved the data hazard without stalling the pipeline.

⚡ Custom Hardware Accelerators: To push performance limits, I integrated two custom co-processors:

MUL Extension: Handles 64-bit signed/unsigned multiplications (mul, mulh, mulhsu, mulhu). Note: I implemented explicit sign-extension concatenations to prevent Verilog's notorious implicit unsigned type-casting traps.

CRC Co-processor: Hardware-accelerated Cyclic Redundancy Check (crc8, crc16, crc32) utilizing custom branchless bitwise polynomial logic.

🎯 Surgical Load/Store Unit (LSU): The memory unit handles flawless byte/halfword alignment and strict sign-extensions (lb, lbu, lh, lhu) using precise byte-enable masks (bw_i), ensuring pristine memory operations.

🛠️ Exhaustive Verification
Writing the RTL was only half the battle. To ensure industrial-grade robustness, I utilized a strict verification methodology:

Bottom-Up Unit Testing: Before full-system integration, every core module (ALU, LSU, MUL, CRC, Control Unit) was individually verified using dedicated testbenches to ensure isolated IP stability.

Automated Self-Checking Assembly: The Instruction Memory (IMEM) is pre-loaded with a complete 47-instruction self-verifying test suite. If all arithmetic, branch, and memory operations succeed, the core safely halts at 0x004003EC and writes 0x00000000 to register x4 (PASS). Any logic failure traps the core and writes 0xFFFFFFFF (FAIL).

Control Flow Traps: Passed 6 consecutive conditional branches and 2 jumps with hidden trap instructions.

🌐 Silicon & Cloud Ready (Beyond RTL)
To prove that this design works beyond pure software simulation, the core has been pushed through physical and cloud-level deployment workflows:

ASIC Physical Implementation: Successfully ran the complete RTL-to-GDSII flow using OpenLane (via Google Colab) to synthesize the physical layout, confirming the design's viability for actual silicon tape-out.

AWS Cloud FPGA Deployment: The core is structured for deployment on AWS EC2 F1 Instances (Amazon Cloud FPGA) using AXI/PCIe wrappers, demonstrating readiness for modern data center hardware acceleration.

📁 Repository Structure
design/hdl.v - The complete top-level Verilog netlist, containing the fully wired CPU system.

testbench/testbench.v - The final rigorous integration testbench used for system sign-off and waveform generation (VCD).

rtl/ - Contains the individual isolated Verilog modules (ALU, LSU, MUL, CRC, Control Unit, Register File).

unit_tests/ - Dedicated block-level testbenches for validating individual IP cores prior to system integration.

🤝 Let's Connect
Building this processor was an incredible journey that solidified my passion for digital IC design and the semiconductor industry. I'm always open to discussing tech, hardware optimization, or collaborating on cool projects.

Designed and verified with coffee, persistence, and a lot of Verilog. ☕💻
