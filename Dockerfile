# ---- Stage 1: Build ----
# Use an official Node.js runtime as a parent image for building
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# ---- Stage 2: Production ----
# Use a smaller, more secure image for the final production stage
FROM node:18-alpine

# Set the working directory
WORKDIR /usr/src/app

# Copy the built application and dependencies from the 'builder' stage
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app .

# Your app binds to port 3000, so you'll use this port
EXPOSE 3000

# Define the command to run your app
CMD [ "node", "index.js" ]
