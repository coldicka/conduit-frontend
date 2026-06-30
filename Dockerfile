# --- Schritt 1: Build-Umgebung ---
# Use Node:20 image
FROM node:20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json  ./

# Install dependencies
RUN npm install

# Copy the project files into the container
COPY . ${WORKDIR}

# Run the build command to create the production-ready files
RUN npm run build

# --- Schritt 2: Produktions-Server ---
# nginx - deploy the built files with nginx
FROM nginx:stable-alpine-slim

# Copy the app from the build stage to the Nginx directory
COPY --from=builder /app/dist/angular-conduit /usr/share/nginx/html

# Expose port 80 to access the frontend
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]