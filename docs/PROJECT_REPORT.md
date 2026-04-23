# Project Report & Benchmarks

## Overview
The AI-OS Exchange project successfully demonstrated the viability of a custom-built, hardware-polling operating system for processing JSON trade payloads at high volume without kernel-level network stacks.

## Key Development Milestones & Fixes
* **MMU Firewall Hardening:** Resolved EL0/EL1 exception panics (Level 2 Permission Faults) by explicitly mapping user-space string literals to `.el0_user_rodata` and preventing user-space binaries from dereferencing kernel-protected `.rodata` blocks.
* **Pointer Decay Mitigation:** Addressed aggressive array pointer decay during rapid byte-by-byte UART ingestion by enforcing strict index-0 evaluations (`payload != '\0'`).
* **VirtIO Disk Initialization:** Overcame FAT32 "Zero-LBA" boot failures by integrating macOS DOS filesystem tools to properly structure the raw binary `.img` file with a compliant Boot Parameter Block (BPB).
* **The 200GB Bottleneck:** Discovered that synchronous GPU flushing on every trade severely degraded performance. Implemented UI Batching, allowing network execution to operate independently of visual rendering.

## Final Benchmarks
Tested on Apple Silicon via QEMU AArch64 virtualization targeting a local Alpine Linux network bridge.

* **Volume:** 50,000 discrete JSON trade payloads.
* **Execution:** Read from UART, parsed, visually batched, routed via IPC, and synchronously committed to FAT32 disk (`TRADES.LOG`).
* **Time to Completion:** 1.178 seconds (real-time).
* **Throughput:** ~42,400 transactions per second.
* **Latency:** ~23 microseconds per transaction cycle.