backup:
	@echo "Backing up databases..."
	./scripts/backup.sh

restore:
	@echo "Restoring databases..."
	./scripts/restore.sh

start:
	@echo "Starting application..."
	./scripts/start.sh
