#!/bin/sh

# Check if a service name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <service_name>"
    exit 1
fi

SERVICE="$1"

# Function to start the service
start_service() {
    echo "Starting service $SERVICE..."
    if $SERVICE start; then
        echo "Service $SERVICE started successfully."
    else
        echo "Failed to start service $SERVICE." >&2
        exit 1
    fi
}

# Function to stop the service
stop_service() {
    echo "Stopping service $SERVICE..."
    if $SERVICE stop; then
        echo "Service $SERVICE stopped successfully."
    else
        echo "Failed to stop service $SERVICE." >&2
        exit 1
    fi
}

# Trap signals to stop the service
trap 'stop_service; exit 0' INT TERM

# Start the service
start_service

# Keep the script running to catch signals
echo "Service $SERVICE is running. Press Ctrl+C to stop."
while true; do
    sleep 1
done
