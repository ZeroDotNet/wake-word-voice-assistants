#!/bin/bash

# M5Stack Cardputer Voice Assistant - Flash and Monitor Script
# Ensure you're in the correct directory and have the device connected

set -e

DEVICE_PORT="/dev/ttyACM0"
CONFIG_FILE="m5stack-assistant.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}M5Stack Cardputer Voice Assistant - Flash Script${NC}"
echo "=================================================="

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}Error: $CONFIG_FILE not found${NC}"
    echo "Make sure you're in the correct directory"
    exit 1
fi

# Check if device is connected
if [ ! -e "$DEVICE_PORT" ]; then
    echo -e "${YELLOW}Warning: Device not found at $DEVICE_PORT${NC}"
    echo "Available devices:"
    ls /dev/tty* | grep -E "(USB|ACM)" || echo "No USB/ACM devices found"
    echo ""
    read -p "Enter device path (or press Enter to use $DEVICE_PORT): " USER_PORT
    if [ ! -z "$USER_PORT" ]; then
        DEVICE_PORT="$USER_PORT"
    fi
fi

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}Activating virtual environment...${NC}"
    if [ -d "esphome-venv" ]; then
        source esphome-venv/bin/activate
        echo -e "${GREEN}Virtual environment activated${NC}"
    else
        echo -e "${RED}Error: Virtual environment not found${NC}"
        echo "Run: python -m venv esphome-venv && source esphome-venv/bin/activate && pip install esphome"
        exit 1
    fi
fi

# Function to compile only
compile_only() {
    echo -e "${BLUE}Compiling firmware...${NC}"
    esphome compile "$CONFIG_FILE"
}

# Function to flash device
flash_device() {
    echo -e "${BLUE}Flashing device at $DEVICE_PORT...${NC}"
    esphome run --device "$DEVICE_PORT" "$CONFIG_FILE"
}

# Function to monitor logs
monitor_logs() {
    echo -e "${BLUE}Monitoring device logs...${NC}"
    echo "Press Ctrl+C to stop monitoring"
    esphome logs --device "$DEVICE_PORT" "$CONFIG_FILE"
}

# Main menu
while true; do
    echo ""
    echo -e "${BLUE}Choose an option:${NC}"
    echo "1) Compile only"
    echo "2) Compile and flash"
    echo "3) Monitor logs"
    echo "4) Flash existing firmware"
    echo "5) Exit"
    echo ""
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1)
            compile_only
            ;;
        2)
            echo -e "${YELLOW}This will compile and flash the device${NC}"
            read -p "Continue? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                flash_device
            fi
            ;;
        3)
            monitor_logs
            ;;
        4)
            echo -e "${YELLOW}This will flash without recompiling${NC}"
            read -p "Continue? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                esphome upload --device "$DEVICE_PORT" "$CONFIG_FILE"
            fi
            ;;
        5)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            ;;
    esac
done
