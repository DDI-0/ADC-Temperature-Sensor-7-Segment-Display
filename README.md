# Temperature Measurements: Clock Domain Crossing (CDC)

A digital system design project implementing temperature measurement using analog-to-digital conversion with proper clock domain crossing techniques on Intel MAX10 FPGA.

## 📋 Project Overview

This project demonstrates the implementation of **Clock Domain Crossing (CDC)** technique for transferring temperature sensor data between two different clock domains:
- **Producer Domain**: 1 MHz (ADC control and data acquisition)
- **Consumer Domain**: 50 MHz (Seven-segment display updates)

The design ensures data integrity during cross-domain transfers using FIFO synchronizers and Gray code conversion to prevent metastability issues.

## 🔧 Hardware USED

- **FPGA Board**: Intel DE10-Lite (MAX10 FPGA)
- **Development Tool**: Intel Quartus Prime
- **Additional**: Temperature sensor (built-in ADC)

## 🏗️ Architecture

### System Components

1. **ADC Controller** (Producer Domain - 1 MHz)
   - Controls MAX10's built-in 12-bit SAR ADC
   - Handles temperature sensor readings
   - Implements finite state machine for ADC operation

2. **FIFO Synchronizer** (CDC Interface)
   - Transfers data between clock domains
   - Uses Gray code for pointer synchronization
   - Implements two-stage synchronizers

3. **Display Controller** (Consumer Domain - 50 MHz)
   - Decimal conversion logic
   - Seven-segment display driver
   - Real-time temperature display

