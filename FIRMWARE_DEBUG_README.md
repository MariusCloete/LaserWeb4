# LaserWeb4 with Enhanced Firmware Detection Logging

This version of LaserWeb4 includes an enhanced communication server with detailed logging for firmware detection issues, specifically designed to help debug SculpFun and other device compatibility problems.

## What's Changed

### 1. Enhanced Server Logging
- **File**: `lw.comm-server/server.js`
- **Changes**: Added detailed logging when unrecognized firmware responses are detected
- **Benefit**: You'll see exactly what your device is sending, helping identify why it's not being recognized

### 2. Updated Dockerfile
- **File**: `Dockerfile`
- **Changes**: 
  - Now installs dependencies for both LaserWeb4 frontend AND the local lw.comm-server
  - Uses the local enhanced server instead of the npm-installed version
  - Better organized build process with proper working directories

### 3. Docker Compose for Testing
- **File**: `docker-compose.debug.yml`
- **Usage**: `docker-compose -f docker-compose.debug.yml up`
- **Features**: 
  - Automatically exposes USB devices to container
  - Mounts `/dev/bus/usb` for proper device access
  - Pre-configured environment variables for debugging

## Quick Start

### Option 1: Using Docker Compose (Recommended)

```bash
cd /home/marius/IdeaProjects/LaserWeb4

# Build and run with Docker Compose
docker-compose -f docker-compose.debug.yml up

# Follow the logs
docker-compose -f docker-compose.debug.yml logs -f laserweb
```

Then open http://localhost:8000 in your browser and connect to your SculpFun device.

### Option 2: Using Docker Build Directly

```bash
cd /home/marius/IdeaProjects/LaserWeb4

# Build the Docker image
docker build -t laserweb4-debug .

# Run the container (with USB device access)
docker run -d \
  --name laserweb4-debug \
  -p 8000:8000 \
  --device=/dev/ttyUSB0:/dev/ttyUSB0 \
  --device=/dev/ttyUSB1:/dev/ttyUSB1 \
  -v /dev/bus/usb:/dev/bus/usb \
  --privileged \
  laserweb4-debug

# View logs
docker logs -f laserweb4-debug
```

### Option 3: Local Node.js Installation

```bash
cd /home/marius/IdeaProjects/LaserWeb4

# Install dependencies
npm install

# Install server dependencies
cd lw.comm-server
npm install
cd ..

# Start the server
node lw.comm-server/server.js
```

## Finding Your Device's Firmware Response

When you connect your SculpFun device, watch the logs for messages like:

### ✅ Successful Detection (Example: GRBL)
```
Grbl v1.1h ['$' for help]
GRBL detected (1.1h)
Connected to /dev/ttyUSB1 at 115200
```

### ❌ Detection Failure (What We're Debugging)
```
Sent: ctrl-x
Sent: version
Sent: {fb:n}
Sent: M115
UNRECOGNIZED FIRMWARE RESPONSE during detection: "YOUR_DEVICE_RESPONSE_HERE"
Raw bytes: [hex codes]
========== FIRMWARE DETECTION TIMEOUT ==========
No supported firmware detected. Closing port /dev/ttyUSB1
Supported firmware types:
  - Grbl (v1.1+)
  - Smoothieware
  - TinyG
  - Repetier, Marlin, MarlinKimbra, RepRapFirmware
```

## Next Steps After Getting the Response

Once you see the "UNRECOGNIZED FIRMWARE RESPONSE" message:

1. **Note the exact response string** (e.g., "SculpFun v1.0 Firmware")
2. **Note the hex bytes** for reference
3. **Contact support** with these details so we can:
   - Identify the firmware type
   - Add detection logic for it
   - Create a fix

## Supported Firmware (Current)

The server currently detects:
- **GRBL** - responds with "Grbl vX.X"
- **Smoothieware** - contains "LPC176"
- **TinyG** - sends JSON with "fb" field
- **Repetier** - responds with "FIRMWARE_NAME:Repetier"
- **Marlin** - responds with "FIRMWARE_NAME:Marlin"
- **MarlinKimbra** - responds with "FIRMWARE_NAME:MK"
- **RepRapFirmware** - responds with "FIRMWARE_NAME: RepRapFirmware"

## Configuration

The server can be configured via environment variables (in docker-compose.debug.yml):

```yaml
environment:
  - NODE_ENV=production
  - VERBOSE_LEVEL=1              # 0=quiet, 1=normal, 2=verbose, 3=debug
  - FIRMWARE_WAIT_TIME=10        # Time to wait for firmware detection (seconds)
  - RESET_ON_CONNECT=1           # Send reset signal on connect
  - WEB_PORT=8000                # Web UI port
```

## File Structure

```
LaserWeb4/
├── Dockerfile                    # Updated for local server
├── docker-compose.debug.yml      # Docker compose for testing
├── lw.comm-server/              # Local enhanced server
│   ├── server.js               # Enhanced with logging (modified)
│   ├── config.js               # Server configuration
│   ├── package.json            # Server dependencies
│   ├── grblStrings.js          # GRBL string mappings
│   └── firmwareFeatures.js     # Firmware feature flags
├── src/                         # LaserWeb4 frontend source
├── dist/                        # Compiled frontend
└── package.json                 # Frontend dependencies
```

## Troubleshooting

### Device not visible in container
- Check: `ls -la /dev/ttyUSB*` on host machine
- Ensure device is not already in use: `lsof /dev/ttyUSB1`
- Try adding `--privileged` flag to docker run command

### No response messages in logs
- Check device is actually connected: `dmesg | tail`
- Try a different USB port
- Verify baud rate setting (usually 115200)

### Docker build fails
- Ensure you're in the LaserWeb4 directory
- Check that node_modules are not included in .dockerignore
- Try `docker build --no-cache -t laserweb4-debug .`

## Support & Contributing

- Original LaserWeb4: https://github.com/LaserWeb/LaserWeb4
- Original lw.comm-server: https://github.com/LaserWeb/lw.comm-server
- This enhanced version: See changes in `lw.comm-server/server.js`

The enhancement adds logging at two key points:
1. When unrecognized firmware responses are detected
2. When firmware detection timeout occurs

This helps identify which devices need additional support.
