# Specify a base image
FROM node:alpine as builder

# Specify a working directory
WORKDIR '/app'

# Install some depenendencies
COPY ./package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

FROM nginx
EXPOSE 3000
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html
