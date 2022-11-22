# Node LTS
FROM node:lts AS builder

WORKDIR /app
COPY package.json .
COPY package-lock.json .
COPY .env .
RUN npm install
COPY . .
RUN npm run build

# NGINX
FROM anroe/nginx-brotli:stable-alpine 
COPY --from=builder /app/dist /var/www/html
RUN rm /etc/nginx/conf.d/default.conf
COPY config/nginx.conf /etc/nginx/conf.d
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]