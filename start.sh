#!/bin/sh

# This script is designed to run inside the node:20-alpine Docker container.

# --- Set Working Directory (Safety check) ---
# Ensure we are in the application root, though the absolute path below makes this less critical.
cd /evolution

# --- 1. Database Migration ---
echo "Applying Prisma database migrations..."
# CRITICAL FIX: Use the ABSOLUTE path from the root of the container.
# This eliminates ambiguity and reliably finds the schema file.
npx prisma migrate deploy --schema=/evolution/prisma/postgresql-schema.prisma

# Check if the migration command was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Prisma migration failed! Exiting application."
    exit 1
fi

# --- 2. Start Application ---
echo "Starting evolution-api server..."
node dist/main.js
