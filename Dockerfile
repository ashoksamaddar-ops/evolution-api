# ----------------------------
# 1️⃣ Base Build Stage
# ----------------------------
FROM node:20-alpine AS builder

# Install necessary tools. bash and dos2unix are needed for the build stage.
# We also include bash here, but it MUST be included in the runner stage too.
RUN apk add --no-cache bash dos2unix git openssl ffmpeg

WORKDIR /evolution

# Copy dependency files
COPY package*.json ./

# Disable Husky (Git hooks) to prevent error 127
ENV HUSKY=0
ENV CI=true
# Install dependencies quietly
RUN npm install --ignore-scripts --no-audit --no-fund

# Copy the rest of the app
COPY . .

# Ensure all shell scripts are Unix-compatible
RUN find . -type f -name "*.sh" -exec dos2unix {} \;

# Generate Prisma client from schema
RUN npx prisma generate --schema=./prisma/postgresql-schema.prisma

# Build the TypeScript project
RUN npm run build

# ----------------------------
# 2️⃣ Runtime Stage
# ----------------------------
FROM node:20-alpine AS runner

WORKDIR /evolution

# CRITICAL FIX: Install bash in the final image since start.sh uses #!/bin/bash
RUN apk add --no-cache bash

# Copy necessary runtime files from builder
COPY --from=builder /evolution/package*.json ./
COPY --from=builder /evolution/node_modules ./node_modules
COPY --from=builder /evolution/dist ./dist
COPY --from=builder /evolution/prisma ./prisma
COPY --from=builder /evolution/manager ./manager
COPY --from=builder /evolution/start.sh ./start.sh

# Make sure start.sh is executable
RUN chmod +x ./start.sh

# Environment
ENV NODE_ENV=production

# Expose app port (change if your app uses another)
EXPOSE 3000

# Start script: Use absolute path to bypass working directory confusion
CMD ["/evolution/start.sh"]
