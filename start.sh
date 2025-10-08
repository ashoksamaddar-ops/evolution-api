#!/bin/sh

# Wait for PostgreSQL to be ready
echo "Waiting for database..."
until npx prisma db pull; do
  echo "DB not ready yet. Waiting 3 seconds..."
  sleep 3
done

# Deploy Prisma migrations
echo "Deploying migrations..."
npx prisma migrate deploy --schema ./prisma/postgresql-schema.prisma

# Start the Evolution API
echo "Starting Evolution API..."
npm run start:prod
