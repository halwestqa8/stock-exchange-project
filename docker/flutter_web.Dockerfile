# Stage 1: Build
FROM debian:bullseye-slim AS build-env

ARG FLUTTER_VERSION=3.41.2

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download the pinned SDK bundle directly instead of cloning the whole repo.
RUN curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o /tmp/flutter.tar.xz && \
    tar -xJf /tmp/flutter.tar.xz -C /usr/local && \
    rm /tmp/flutter.tar.xz
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Web support is available in current stable Flutter builds without an extra
# enable step, and the archived SDK can fail if we force a config write here.
RUN flutter --version

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
