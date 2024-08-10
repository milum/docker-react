# Multi-Stage Build Dockerfile for building the React app and then serving it on an nginx server

################ builder phase ################

# use specific alpine version to avoid bugs
FROM node:16-alpine as builder

WORKDIR '/app'

COPY package.json .
# install dependencies listed in package.json
RUN npm install
COPY . .

# outputs to /home/node/app/build
RUN npm run build

################ run phase ################

# no "as run" label required
FROM nginx

# copy output from builder phase to where nginx looks for static content to host 
COPY --from=builder /app/build /usr/share/nginx/html

# default command of nginx image starts up nginx server, no need to specify