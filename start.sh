#!/bin/bash

# --- 1. Database Migration ---
# This command ensures any pending database changes (migrations) are 
# applied to the connected PostgreSQL database before the server starts.
echo "Applying Prisma database migrations..."
npx prisma migrate deploy

# Check if the migration command was successful
if [ $? -ne 0 ]; then
    echo "ERROR: Prisma migration failed! Exiting application."
    exit 1
fi

# --- 2. Start Application ---
# This command starts your compiled Node.js application. 
# We assume 'dist/main.js' is the entry file created by 'npm run build'.
echo "Starting evolution-api server..."
node dist/main.js

# Note: The 'chmod +x ./start.sh' command in your build log means this 
# script is already marked as executable, which is correct.
