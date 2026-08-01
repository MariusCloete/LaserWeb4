FROM node:10-alpine AS base

WORKDIR /app

COPY . .

# Install build dependencies and serial port tools
# eudev is needed for udev device access, required for USB/serial port enumeration
RUN apk add --no-cache make gcc g++ python python3 linux-headers eudev eudev-dev git pkgconfig libusb-dev
RUN git config --global url."https://github.com".insteadOf "ssh://git@github.com"
RUN npm set progress=false && npm config set depth 0

# Install LaserWeb4 frontend dependencies
RUN npm ci
RUN npm run bundle-dev

# Install lw.comm-server dependencies
WORKDIR /app/lw.comm-server
RUN npm ci

WORKDIR /app

#
# ---- Release ----
FROM node:10-alpine

ENV ENV="production"
ENV NODE_ENV="production"

# Install eudev and create dialout group for serial port access
RUN apk add --no-cache eudev
RUN addgroup -g 20 -S dialout && addgroup node dialout || true

WORKDIR /app
COPY --from=base /app ./

EXPOSE 8000

# Use the local server with enhanced logging
CMD [ "node", "lw.comm-server/server.js" ]
