backup:
	@echo "Backing up databases..."
	./scripts/db/backup.sh

restore:
	@echo "Restoring databases..."
	./scripts/db/restore.sh

start:
	@echo "Starting application (production)..."
	./scripts/app/start.sh
