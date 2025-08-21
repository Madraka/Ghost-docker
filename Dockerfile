# Multi-stage Dockerfile for Ghost
FROM node:18-alpine AS base

# Install system dependencies
RUN apk add --no-cache \
    bash \
    curl \
    git \
    python3 \
    make \
    g++ \
    vips-dev

# Set working directory
WORKDIR /var/lib/ghost

# Install Ghost CLI globally
RUN npm install -g ghost-cli@latest

# Development stage
FROM base AS development

# Set environment
ENV NODE_ENV=development
ENV GHOST_INSTALL=/var/lib/ghost
ENV GHOST_CONTENT=/var/lib/ghost/content

# Create ghost user
RUN addgroup -g 1000 ghost && \
    adduser -D -s /bin/bash -u 1000 -G ghost ghost

# Create necessary directories
RUN mkdir -p /var/lib/ghost/content && \
    chown -R ghost:ghost /var/lib/ghost

# Switch to ghost user
USER ghost

# Expose port
EXPOSE 2368

# Start command for development
CMD ["ghost", "run"]

# Production stage
FROM base AS production

# Set environment for production
ENV NODE_ENV=production
ENV GHOST_INSTALL=/var/lib/ghost
ENV GHOST_CONTENT=/var/lib/ghost/content

# Create ghost user
RUN addgroup -g 1000 ghost && \
    adduser -D -s /bin/bash -u 1000 -G ghost ghost

# Create necessary directories
RUN mkdir -p /var/lib/ghost/content && \
    chown -R ghost:ghost /var/lib/ghost

# Switch to ghost user
USER ghost

# Install Ghost
RUN ghost install local --no-prompt --no-start

# Copy custom configuration if exists
COPY --chown=ghost:ghost config.production.json /var/lib/ghost/

# Expose port
EXPOSE 2368

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:2368/ || exit 1

# Start command for production
CMD ["ghost", "start"]
