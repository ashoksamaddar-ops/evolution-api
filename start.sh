#!/usr/bin/env bash
set -e

# Copy migrations
rm -rf ./prisma/migrations
cp -r ./prisma/postgresql-migrations ./prisma/migrations

# Run Prisma migrations
echo "Running Prisma migrations..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

# Start the app
echo "Starting app..."
node dist/server.js
