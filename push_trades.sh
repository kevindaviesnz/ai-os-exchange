#!/bin/bash

# Check if the user provided an argument
if [ -z "$1" ]; then
    echo "Usage: ./push_trades.sh <number_of_trades>"
    exit 1
fi

NUM_TRADES=$1
TARGET_IP="192.168.64.8"
TARGET_PORT="8080"

echo "Initiating High-Frequency Trade Stream..."
echo "Target: $TARGET_IP:$TARGET_PORT"
echo "Volume: $NUM_TRADES trades"
echo "-------------------------------------------"

# The 'time' command wraps our execution block to measure exact performance
time {
    # Generate payloads in a tight loop and pipe them into a single TCP connection
    for ((i=1; i<=NUM_TRADES; i++)); do
        # Alternating assets slightly just so the OS screen looks realistic
        if (( i % 2 == 0 )); then
            echo '{"action": "SELL", "asset": "ETH", "qty": 12.5}'
        else
            echo '{"action": "BUY", "asset": "BTC", "qty": 1.5}'
        fi
    done | nc $TARGET_IP $TARGET_PORT
}

echo "-------------------------------------------"
echo "Stream Complete."