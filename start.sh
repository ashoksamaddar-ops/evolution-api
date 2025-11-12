#!/bin/bash
set -e

# --- 0. CRITICAL: Validate Environment Variable Presence ---
if [ -z "$DATABASE_CONNECTION_URI" ]; then
    echo "❌ ERROR: DATABASE_CONNECTION_URI environment variable is NOT SET."
    echo "Please set this variable in your hosting platform's environment settings."
    exit 1 
fi
echo "✅ DATABASE_CONNECTION_URI is present."

# --- 1. Generate Prisma Client from schema ---
echo "Running prisma generate..."
npx prisma generate

# --- 2. Apply Schema to Database (This command uses the environment variable) ---
echo "Applying Prisma schema (db push)..."
npx prisma db push --accept-data-loss

# --- 3. Launch the Server ---
echo "🚀 Starting application..."
exec node dist/main.js
