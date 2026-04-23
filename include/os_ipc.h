#ifndef OS_IPC_H
#define OS_IPC_H

#include "os_types.h"

/* --- Standard Return Codes --- */
#define IPC_SUCCESS  0
#define IPC_ERROR   -1

/* --- System Call Numbers --- */
#define SYS_IPC_SEND        1
#define SYS_IPC_RECV        2
#define SYS_GPU_FLUSH       3
#define SYS_HW_DRAIN        4
#define SYS_UART_RECV       5 /* Safe EL1 UART0 Polling */

/* --- IPC Message Types --- */
#define IPC_MSG_NONE              0
#define IPC_MSG_KEY_PRESS         1
#define IPC_MSG_FS_LIST_REQ       2
#define IPC_MSG_FS_LIST_RESP      3
#define IPC_MSG_FS_READ_REQ       4
#define IPC_MSG_FS_READ_RESP      5
#define IPC_MSG_FS_WRITE_REQ      6
#define IPC_MSG_FS_WRITE_RESP     7
#define IPC_MSG_ATK_EXEC_REQ      8
#define IPC_MSG_ATK_EXEC_RESP     9
#define IPC_MSG_WATCHER_DUMP_REQ  10
#define IPC_MSG_WATCHER_DUMP_RESP 11
#define IPC_MSG_WATCHER_SYNC_REQ  12
#define IPC_MSG_WATCHER_SYNC_RESP 13

/* --- System Module IDs --- */
#define SYS_MOD_KERNEL    0x01
#define SYS_MOD_UART      0x02
#define SYS_MOD_GUI_SHELL 0x03
#define SYS_MOD_FS        0x04

/* --- Standard Message Structure --- */
typedef struct {
    uint8_t  sender_id;
    uint8_t  target_id;
    uint16_t type;
    uint32_t length;
    uint8_t  payload[ 256 ];
} os_message_t;

#endif