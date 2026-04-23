# AI-OS Exchange: Bare-Metal HFT Gateway

> ⚠️ **WARNING: NOT FOR COMMERCIAL USE.**
> This project is an educational prototype and technical demonstration of High-Frequency Trading concepts. It is an emulator-bound OS that lacks the custom hardware drivers, dedicated TCP/IP stack, fault tolerance, and security encryption required for a live financial environment. **Do not deploy this system, or any derivative of it, with real capital.** Read the `DISCLAIMER.md` for full details.

A custom, bare-metal ARM64 (AArch64) operating system engineered strictly for zero-jitter, high-frequency trade ingestion. Designed to run in QEMU, it establishes a direct, memory-safe TCP hardware bridge to an Alpine Linux gateway, entirely bypassing standard OS kernel scheduling overhead.

**Author:** Kevin Davies  
**Architecture:** AArch64 / Cortex-A53  
**Status:** Demo / Prototype Completed  

## Core Architecture
* **The Hot Path:** Trades are ingested via a tight hardware-polling loop on UART0, avoiding network interrupt latency.
* **Zero-Jitter Allocation:** Employs an $O(1)$ DMA bump-allocator with a self-clearing Arena Snapshot reset, eliminating memory fragmentation and garbage collection pauses.
* **Decoupled UI:** Uses asynchronous UI batching to prevent 4MB `sys_gpu_flush()` framebuffers from blocking machine-speed network ingestion.
* **Persistent Ledger:** Direct FAT32 block-device manipulation via VirtIO, providing synchronous data persistence.

## Build & Run Instructions
Requires `aarch64-elf-gcc`, `qemu-system-aarch64`, and `dosfstools` (macOS/Homebrew compatible).

1. **Format the Drive:** `mkfs.fat -F 32 ai-os-live.img`
2. **Build & Boot:** `make clean && make run`
3. **Execute Mode:** In the OS terminal, type `trade.listen`
4. **Fire Payload (Host):** `echo '{"action": "BUY", "asset": "BTC", "qty": 1.5}' | nc <TARGET_IP> 8080`

## AI Collaboration Disclosure
*This project, including its architectural design, custom C kernel, hardware drivers, and documentation, was heavily developed in collaboration with AI tools (Google Gemini) acting as a pair-programmer and systems architecture consultant.*