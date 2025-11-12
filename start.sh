#!/bin/bash
set -e

# --- 0. CRITICAL: Validate Environment Variable Presence ---
# This check ensures that the DATABASE_CONNECTION_URI is set by your hosting platform.
if [ -z "$DATABASE_CONNECTION_URI" ]; then
    echo "❌ ERROR: DATABASE_CONNECTION_URI environment variable is NOT SET."
    echo "Please set this variable in your hosting platform's environment settings (e.g., Render Dashboard)."
    exit 1 
fi
echo "✅ DATABASE_CONNECTION_URI is present."

# --- 1. Generate Prisma Client from schema ---
# Although generated during build, we run it again here in case of dynamic needs (best practice).
echo "Running prisma generate..."
npx prisma generate

# --- 2. Apply Schema to Database (db push is used for simple deployments) ---
echo "Applying Prisma schema (db push)..."
# The db push command uses the DATABASE_CONNECTION_URI environment variable.
npx prisma db push --accept-data-loss

# --- 3. Launch the Server ---
echo "🚀 Starting application..."
exec node dist/main.js
