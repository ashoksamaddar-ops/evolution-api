#!/bin/bash
set -e

# --- 0. CRITICAL: Validate Environment Variable Presence ---
if [ -z "$DATABASE_CONNECTION_URI" ]; then
    echo "❌ ERROR: DATABASE_CONNECTION_URI environment variable is NOT SET."
    echo "Please set this variable in your hosting platform's environment settings (e.g., Render Dashboard)."
    exit 1 
fi
echo "✅ DATABASE_CONNECTION_URI is present."

# --- 1. Generate Prisma Client from schema ---
echo "Running prisma generate..."
# FIX: Explicitly specify the PostgreSQL schema file path
npx prisma generate --schema=./prisma/postgresql-schema.prisma

# --- 2. Apply Schema to Database (db push is used for simple deployments) ---
echo "Applying Prisma schema (db push)..."
# FIX: Explicitly specify the PostgreSQL schema file path for db push
npx prisma db push --schema=./prisma/postgresql-schema.prisma --accept-data-loss

# --- 3. Launch the Server ---
echo "🚀 Starting application..."
exec node dist/main.js
