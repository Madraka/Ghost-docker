# Ghost Dockerfile
FROM ghost:5-alpine

# Set environment variables
ENV NODE_ENV=development
ENV database__client=mysql
ENV database__connection__host=mysql-dev
ENV database__connection__user=ghost
ENV database__connection__password=ghostpassword
ENV database__connection__database=ghost_dev
ENV url=http://localhost:2368

# Create custom content directory
USER root
RUN mkdir -p /var/lib/ghost/content && \
    chown -R node:node /var/lib/ghost/content

# Switch back to node user
USER node

# Expose port
EXPOSE 2368

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:2368/ || exit 1

# Start Ghost
CMD ["node", "current/index.js"]
