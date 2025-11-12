#!/bin/sh
set -e

cd /evolution

PORT=${PORT:-8080}
export EVOLUTION_PORT=$PORT

echo "--------------------------------------"
echo "🕓 $(date) | Starting Evolution API (Free Render Auto-Setup)"
echo "--------------------------------------"

# --- 1️⃣ Generate Prisma client ---
npx prisma generate --schema=/evolution/prisma/postgresql-schema.prisma

# --- 2️⃣ Try migrations, fall back to db push for brand-new DBs ---
echo "Applying Prisma migrations..."
if ! npx prisma migrate deploy --schema=/evolution/prisma/postgresql-schema.prisma; then
  echo "⚠️ No migrations found — creating tables with db push..."
  npx prisma db push --schema=/evolution/prisma/postgresql-schema.prisma
fi

# --- 3️⃣ Launch server ---
echo "🚀 Launching Evolution API on port $PORT"
exec node dist/main.js
