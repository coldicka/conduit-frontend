# ==========================================
# STAGE 1: Build the Angular Application
# ==========================================
# Use Node:20 image
FROM node:20 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json in the container to install dependencies
COPY package*.json  .

# Install dependencies
RUN npm install

# Copy the project files rest into the container
COPY . .

# Run the build command to create the production-ready files
RUN npm run build --configuration=production

# ==========================================
# STAGE 2: Serve the App with Nginx
# ==========================================

# nginx - deploy the built files with nginx
FROM nginx:alpine

# Copy the Angular build output from Stage 1 to the NGINX web directory
COPY --from=builder /app/dist/angular-conduit /usr/share/nginx/html

# Add Nginx Configuration for Angular Routing
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 to access the frontend
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]