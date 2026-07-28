# 🚀 START HERE - LaserWeb4 with SculpFun Firmware Debug

**You've got everything you need to debug your SculpFun connection!**

## In 30 Seconds...

```bash
cd /home/marius/IdeaProjects/LaserWeb4
./run-debug-docker.sh
```

Then open http://localhost:8000 and connect your device.

---

## What Happens Next?

1. **Watch the console output** for messages about your device
2. **Look for "UNRECOGNIZED FIRMWARE RESPONSE"** - that's what we need!
3. **Note the response string** (e.g., "SculpFun v1.0" or similar)
4. **Share it with support** so we can add official support

---

## 📚 Full Documentation

- **`QUICK_START.md`** - Quick setup guide (5 min read)
- **`FIRMWARE_DEBUG_README.md`** - Complete documentation (20 min read)
- **`INTEGRATION_SUMMARY.txt`** - What was changed and why
- **`.env.example`** - All configuration options

---

## Common Commands

```bash
# Build and run with one command
./run-debug-docker.sh

# Or use Docker Compose
docker-compose -f docker-compose.debug.yml up

# Or manually with Docker
docker build -t laserweb4-debug .
docker run -it --rm -p 8000:8000 \
  --device=/dev/ttyUSB1:/dev/ttyUSB1 \
  -v /dev/bus/usb:/dev/bus/usb \
  --privileged laserweb4-debug

# View logs
docker logs laserweb4-debug

# Stop container
docker stop laserweb4-debug
```

---

## 🎯 What You'll See

### ✅ If it works (GRBL example):
```
Grbl v1.1h ['$' for help]
GRBL detected (1.1h)
Connected to /dev/ttyUSB1 at 115200
```

### ⚙️ If we need to debug (what we're looking for):
```
Sent: ctrl-x
Sent: version
Sent: {fb:n}
Sent: M115

UNRECOGNIZED FIRMWARE RESPONSE during detection: "[DEVICE RESPONSE HERE]"
Raw bytes: [hex values]

========== FIRMWARE DETECTION TIMEOUT ==========
No supported firmware detected. Closing port /dev/ttyUSB1
```

**The text in quotes is what we need!** Copy it and share with support.

---

## 🔧 What Changed?

- ✅ Enhanced server logging in `lw.comm-server/server.js`
- ✅ Updated `Dockerfile` to use local server
- ✅ Created `docker-compose.debug.yml` for easy testing
- ✅ Added convenience scripts and documentation
- ✅ All dependencies included in Docker build

---

## 🆘 Quick Troubleshooting

**"Command not found: ./run-debug-docker.sh"**
```bash
chmod +x run-debug-docker.sh
./run-debug-docker.sh
```

**"Device not found"**
```bash
# Check device exists
ls -la /dev/ttyUSB*

# Try different port
./run-debug-docker.sh /dev/ttyUSB0
```

**"Docker build fails"**
```bash
docker build --no-cache -t laserweb4-debug .
```

**"No output visible"**
```bash
# Edit docker-compose.debug.yml and change:
VERBOSE_LEVEL=3  # More verbose output
```

---

## ✨ Next Steps

1. Run the Docker container
2. Connect your SculpFun device
3. Capture any "UNRECOGNIZED FIRMWARE RESPONSE" message
4. Note the exact response string
5. Share with support for official device support

---

## 📞 Questions?

- **Full docs**: Read `FIRMWARE_DEBUG_README.md`
- **Setup help**: Read `QUICK_START.md`
- **What changed**: Check `INTEGRATION_SUMMARY.txt`

---

**Happy debugging! 🎉**
