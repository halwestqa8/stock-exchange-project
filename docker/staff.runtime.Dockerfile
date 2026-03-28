FROM nginx:alpine

LABEL org.opencontainers.image.source="https://github.com/halwestqa8/stock-exchange-project"

COPY . /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
