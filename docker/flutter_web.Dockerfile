# Stage 1: Build
FROM debian:stable-slim AS build-env

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa lib32stdc++6 python3 ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web
RUN flutter config --enable-web

# Copy the whole monorepo to build with local packages
WORKDIR /app
COPY . .

# Argument for the specific app to build
ARG APP_DIR
ARG BASE_URL
WORKDIR /app/${APP_DIR}

# Build the app with the production API URL
RUN flutter pub get
RUN flutter build web --release --dart-define=BASE_URL=${BASE_URL}

# Stage 2: Serve
FROM nginx:alpine
ARG APP_DIR
COPY --from=build-env /app/${APP_DIR}/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
