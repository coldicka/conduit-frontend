# Stage 1: build
FROM node:18 AS builder

WORKDIR /app

COPY package*.json  ./
RUN npm install

COPY . .
RUN npm run build

# Stage 2: nginx
FROM nginx:stable-alpine-slim
COPY nginx.conf /etc/nginx/nginx.conf

COPY --from=builder /app/dist/angular-conduit /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]