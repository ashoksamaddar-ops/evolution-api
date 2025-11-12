#!/bin/sh
set -e

# --- Working Directory ---
cd /evolution

# --- Environment Setup ---
PORT=${PORT:-8080}
export EVOLUTION_PORT=$PORT

echo "--------------------------------------"
echo "🕓 $(date) | Starting Evolution API setup"
echo "--------------------------------------"

# --- 1️⃣ Apply Prisma Database Migrations ---
echo "Applying Prisma migrations..."
if ! npx prisma migrate deploy --schema=/evolution/prisma/postgresql-schema.prisma; then
  echo "⚠️ No migrations found, running db push instead..."
  npx prisma db push --schema=/evolution/prisma/postgresql-schema.prisma
fi

# --- 2️⃣ Start Application ---
echo "🚀 Launching Evolution API on port $PORT"
exec node dist/main.js
