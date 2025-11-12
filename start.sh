# ... (your existing code)

# --- 2️⃣ Try migrations, fall back to db push for brand-new DBs ---
echo "Applying Prisma migrations..."
# Attempt 1: Deploy migrations (for existing projects)
if ! npx prisma migrate deploy --schema=/evolution/prisma/postgresql-schema.prisma; then
  echo "⚠️ Migration deployment failed or no migrations found. Attempting to create tables with db push..."
  # Attempt 2: Push schema (for brand-new DBs/initial setup)
  npx prisma db push --schema=/evolution/prisma/postgresql-schema.prisma
  if [ $? -eq 0 ]; then
    echo "✅ Database schema pushed successfully."
  else
    echo "❌ ERROR: Prisma db push failed. Check DATABASE_CONNECTION_URI and permissions."
    exit 1 # Stop execution if db push fails
  fi
fi
# --- Schema sync complete ---

# Add a small delay for good measure, just in case.
echo "Waiting 5 seconds for database readiness..."
sleep 5

# --- 3️⃣ Launch server ---
echo "🚀 Launching Evolution API on port $PORT"
exec node dist/main.js
