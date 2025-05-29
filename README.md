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

Simple Moving Average (SMA)

Formula:
SMAₙ = (1 / N) × (xₙ + xₙ₋₁ + ... + xₙ₋ₙ₊₁)

Description:
This takes the average of the last N inputs. For example, when N = 4, it gives equal weight to the 4 most recent values.

Exponential Moving Average (EMA)

Formula:
EMAₙ = α × xₙ + (1 − α) × EMAₙ₋₁
with α = 0.5

Description:
This gives more weight to recent values, allowing faster response to changes. The parameter α controls how quickly older values are "forgotten."

## Architecture

- SMA uses a shift-register buffer and averaging logic
- EMA uses a recursive formula with fixed-point multiplication
- Display decoding via a `seg7_decoder.v` module
- Quartus `.qsf` file for pin assignments
