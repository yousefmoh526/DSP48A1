# DSP48A1 Verilog Project – Spartan-6 FPGA

This project implements and verifies a **DSP48A1 slice** from Xilinx Spartan-6 FPGAs using Verilog. The DSP48A1 block is a specialized digital signal processing unit used for high-speed arithmetic operations like multiplication, addition, subtraction, and accumulation—ideal for applications such as filters, FFTs, and MAC units.

---

##  Repository Structure

```
DSP48A1_Project/
│
├── src/                  # RTL and module files for DSP48A1
│   └── dsp48a1.v
│
├── tb/                   # Testbench files
│   └── dsp48a1_tb.v
├── vivado/               # Vivado project files, constraints, and reports
│   ├── constraints.xdc
│   ├── schematic_snippets/
│   ├── utilization_report_snippets
│   └── timing_report_snippets
└── docs/                 # Project report and design description
    ├── DSP_TB_Description.pdf
    └── DSP48A1.pdf
```

---

##  Project Overview

The project focuses on instantiating and simulating the DSP48A1 block with different control paths to validate its arithmetic functionality.

###  Key Parameters Configured:

* **Pipeline Registers:** A0REG = 0, A1REG = 1, B0REG = 0, B1REG = 1, etc.
* **CARRYINSEL = "OPMODE5"**, B\_INPUT = "DIRECT"
* **Synchronous Reset** (`RSTTYPE = "SYNC"`)

These settings ensure realistic pipelining and timing in arithmetic processing.

---

##  Verification & Testing

###  **QuestaSim Simulation**

* Testbench (`dsp48a1_tb.v`) is built to test **4 DSP operational paths**, each corresponding to a specific `OPMODE`.
* Each path verifies different stages like:

  * Pre-adder/subtractor
  * Multiplier
  * Post-adder/subtractor
* **Self-checking assertions** are used to confirm that outputs match expected values after appropriate clock cycles.

###  **Waveform Analysis**

* All simulations were visually inspected using QuestaSim waveform viewer (`wave.do`) to trace input propagation and confirm timing alignment with registers (DREG, MREG, PREG, etc.).

---

##  DSP Path Verification Details

| Path | Operation Type               | OPMODE        | Description                           |
| ---- | ---------------------------- | ------------- | ------------------------------------- |
| 1    | Multiplier + Post-subtractor | `8'b11011101` | Mult + C input → subtraction          |
| 2    | Pre-adder + Zero-path        | `8'b00010000` | Adds A/B via pre-adder, bypasses Mult |
| 3    | Feedback (no pre-add)        | `8'b00001010` | Accumulation via P feedback           |
| 4    | Concatenated D\:A\:B         | `8'b10100111` | Full bypass & custom path             |

Each path is carefully timed, and expected outputs (P, M, CarryOut) are checked using assertions.

---

##  Vivado Implementation

* Synthesized and implemented in **Vivado** using part `xc7a200tffg1156-3`
* Schematic screenshots and utilization/timing reports are included
* Clock constraint of **100 MHz** applied to pin W5

Outputs include:

* Elaborated RTL schematic
* Post-synthesis netlist with DSP slice instantiation
* Reports showing **no timing violations** and **resource usage**

---

##  Linting (Static Analysis)

* **Questa Lint** run with default methodology
* No syntax, style, or synthesis-related errors or warnings
* Ensures clean, maintainable, and synthesizable Verilog code

---

##  Conclusion

This project demonstrates how to accurately model, simulate, and verify a DSP48A1 slice in a modern FPGA development flow. It involves RTL design, simulation with assertion-based verification, static lint checking, and full synthesis with schematic analysis—representing industry-grade FPGA development practices.

---

Let me know if you'd like me to generate a `README.md` file based on this or help organize your folder structure.
