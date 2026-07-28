#!/bin/bash
# LaserWeb4 Enhanced Firmware Detection Debug Docker Runner

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "🔧 LaserWeb4 with Enhanced Firmware Detection Logging"
echo "=================================================="
echo ""
echo "This script will build and run LaserWeb4 with detailed logging for firmware detection issues."
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

echo "📦 Building Docker image..."
docker build -t laserweb4-debug .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""
echo "🚀 Starting LaserWeb4 container..."
echo ""

# Check if device is specified as argument
DEVICE="${1:- /dev/ttyUSB1}"

docker run -it --rm \
    --name laserweb4-debug \
    -p 8000:8000 \
    --device=$DEVICE:$DEVICE \
    -v /dev/bus/usb:/dev/bus/usb \
    --privileged \
    -e VERBOSE_LEVEL=1 \
    -e FIRMWARE_WAIT_TIME=10 \
    laserweb4-debug

