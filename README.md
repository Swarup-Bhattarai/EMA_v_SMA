# FPGA-Based Real-Time SMA/EMA Signal Processing System

> Developed on Intel DE10-Lite FPGA

## Overview

This project implements real-time **Simple Moving Average (SMA)** and **Exponential Moving Average (EMA)** calculators on the Intel DE10-Lite FPGA. Based on the relationship between the two, the system generates actionable signals: **BUY**, **SELL**, or **HOLD**.

## Features

- **Inputs:**  
  - `SW[3:0]` – 4-bit value input  
  - `KEY[1]` – Push input into buffer  
  - `KEY[0]` – Reset all values  
- **Outputs:**  
  - `HEX0–1` – SMA  
  - `HEX2–3` – EMA  
  - `HEX5` – Signal (1=HOLD, 2=BUY, 3=SELL)  
  - `LEDR[9:8]` – Signal indicator  

## Signal Logic

- **BUY** if `SMA > EMA`  
- **SELL** if `SMA < EMA`  
- **HOLD** if `SMA == EMA`

## Math Behind It

### Simple Moving Average (SMA)

\[
\text{SMA}_n = \frac{1}{N} \sum_{i=n-N+1}^{n} x_i
\]

Equal weighting across the last \( N = 4 \) inputs.

### Exponential Moving Average (EMA)

\[
\text{EMA}_n = \alpha \cdot x_n + (1 - \alpha) \cdot \text{EMA}_{n-1}
\quad \text{with} \quad \alpha = 0.5
\]

Faster response to recent inputs.

## Architecture

- SMA uses a shift-register buffer and averaging logic
- EMA uses a recursive formula with fixed-point multiplication
- Display decoding via a `seg7_decoder.v` module
- Quartus `.qsf` file for pin assignments
