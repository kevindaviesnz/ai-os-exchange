#include "os_types.h"

/* --- UART0: The Gateway Pipe (ttyAMA0) --- */
#define UART0_BASE 0x09000000
#define UART0_DR   ((volatile uint32_t *)(UART0_BASE + 0x000))
#define UART0_FR   ((volatile uint32_t *)(UART0_BASE + 0x018))

#define UART_FR_TXFF (1 << 5)  /* Transmit FIFO Full */
#define UART_FR_RXFE (1 << 4)  /* Receive FIFO Empty */

/* --- OS Debug Logging --- */
void uart_print(const char *str) {
    while (*str) {
        while (*UART0_FR & UART_FR_TXFF);
        *UART0_DR = *str++;
    }
}

void uart_print_hex(uint64_t val) {
    const char *hex_chars = "0123456789ABCDEF";
    char buffer[ 19 ];
    buffer[ 0 ] = '0';
    buffer[ 1 ] = 'x';
    buffer[ 18 ] = '\0';
    
    for (int i = 15; i >= 0; i--) {
        buffer[ 2 + i ] = hex_chars[ val & 0xF ];
        val >>= 4;
    }
    uart_print(buffer);
}

/* --- THE KERNEL POLLER --- */
char uart_poll_rx(void) {
    if ((*UART0_FR & UART_FR_RXFE) == 0) {
        return (char)(*UART0_DR & 0xFF);
    }
    return 0;
}