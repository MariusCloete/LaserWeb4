#
# ---- Base Node ----
FROM node:10-alpine AS base
# set working directory
WORKDIR /usr/src/app

# copy project file
COPY package*.json ./
EXPOSE 8000
# copy app sources
COPY . .

#
# ---- Dependencies ----
FROM base AS dependencies
# Install build dependencies and serial port tools
# eudev is needed for udev device access, required for USB/serial port enumeration
RUN apk add --no-cache make gcc g++ python python3 linux-headers eudev git
# Create dialout group and add node user for serial port access
RUN addgroup -g 20 -S dialout && addgroup node dialout || true
RUN git config --global url."https://github.com".insteadOf "ssh://git@github.com"
# install node packages
RUN npm set progress=false && npm config set depth 0
RUN npm ci

#
# ---- Test ----
# run linters, setup and tests
FROM dependencies AS test
#RUN  npm run lint && npm run setup && npm run test
RUN  npm run test

#
# ---- Dev ----
FROM dependencies AS dev
RUN npm install && npm install -g nodemon
# copy production node_modules
COPY --from=dependencies /usr/src/app/node_modules node_modules
# define CMD
CMD [ "npm", "run", "start-server" ]
