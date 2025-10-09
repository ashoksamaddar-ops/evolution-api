# ----------------------------
# Builder Stage
# ----------------------------
FROM node:24-alpine AS builder

RUN apk update && \
    apk add --no-cache git ffmpeg wget curl bash openssl dos2unix

LABEL version="2.3.1" description="API to control WhatsApp features through HTTP requests."
LABEL maintainer="Davidson Gomes" git="https://github.com/DavidsonGomes"
LABEL contact="contato@evolution-api.com"

WORKDIR /evolution

# Install dependencies
COPY ./package*.json ./
COPY ./tsconfig.json ./
COPY ./tsup.config.ts ./

RUN npm install

# Copy Prisma schema before generating client
COPY ./prisma ./prisma

# ✅ Generate Prisma client BEFORE build
RUN npx prisma generate --schema=./prisma/postgresql-schema.prisma


# Copy rest of source code
COPY ./src ./src
COPY ./public ./public
COPY ./manager ./manager
COPY ./.env.example ./.env
COPY ./runWithProvider.js ./
COPY ./Docker ./Docker

RUN chmod +x ./Docker/scripts/* && dos2unix ./Docker/scripts/*

# Build the project
RUN npm run build
