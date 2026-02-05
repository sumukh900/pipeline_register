# Single-Stage Ready/Valid Pipeline Register

This repository contains a **single-stage pipeline register** implemented in **SystemVerilog** with **ready/valid backpressure support**.

The design allows safe data transfer between upstream and downstream modules while handling stalls using standard handshake semantics.

---

## Design Overview

- Single-stage (one-entry) pipeline register
- Uses **ready/valid handshake** for flow control
- Supports **backpressure** from downstream logic
- Parameterized data width
- Synthesizable SystemVerilog RTL

---

## Interface Description

### Input Interface
- `in_valid` : Indicates valid input data
- `in_ready` : Indicates pipeline can accept new data
- `in_data`  : Input data bus

### Output Interface
- `out_valid` : Indicates valid output data
- `out_ready` : Indicates downstream is ready to consume data
- `out_data`  : Output data bus

---

## Handshake Behavior

- Data is accepted when `in_valid && in_ready` is high
- Data is consumed when `out_valid && out_ready` is high
- If downstream is not ready, the pipeline **holds data** and asserts backpressure

---

## Backpressure Logic

The pipeline is ready to accept new data when:
- The internal register is empty, **or**
- The downstream logic is ready to consume the current data

This allows the module to function as a **one-entry buffer**.

---

## Reset Behavior

- Active-low asynchronous reset (`rst_n`)
- Reset clears the valid flag and initializes the pipeline to an empty state

---

## Notes

- No latch is inferred; the design uses edge-triggered sequential logic (`always_ff`)
- When stalled, data is retained until it is safely consumed
- The design can be easily extended to multi-stage pipelines

---

## Files

- `pipeline_reg.sv` : SystemVerilog implementation of the pipeline register
