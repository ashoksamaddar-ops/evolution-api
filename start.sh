#!/bin/sh

# --- Set Working Directory ---
# Navigate to the /evolution folder where the code and node_modules are located.
# This ensures that 'npx' and 'node' can find the necessary files.
cd /evolution

# --- 1. Database Migration ---
echo "Applying Prisma database migrations..."
# 'npx' uses the local node_modules which should be in the current directory now.
npx prisma migrate deploy

# Check if the migration command was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Prisma migration failed! Exiting application."
    exit 1
fi

# --- 2. Start Application ---
# The application entry file is run relative to the current working directory (/evolution).
echo "Starting evolution-api server..."
node dist/main.js
