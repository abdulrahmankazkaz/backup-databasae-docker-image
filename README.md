
# Database Backup Service (Docker + Yacron)

This Docker service allows you to perform scheduled MySQL/MariaDB backups and upload them directly to an S3-compatible storage (e.g., Cloudflare R2) without creating extra folders.

## Features
- Backup a specific database table.
- Compress backups (`.sql.gz`).
- Upload backups directly to S3/R2 with clear, timestamped filenames.
- Schedule backups using Yacron cron jobs.
- Fully containerized, zero dependencies on host.

## Requirements
- Docker & Docker Compose
- `.env` file with environment variables:

```bash
DB_HOST=your_mysql_host
DB_USER=your_db_user
DB_PASSWORD=your_db_password
S3_ENDPOINT=https://your-s3-endpoint
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
```

- Yacron configuration file (`yacron.yml`) for scheduled jobs.

## Docker Compose Example
```yaml
services:
  backup:
    image: ghcr.io/abdulrahmankazkaz/db-backup:latest
    restart: unless-stopped
    environment:
      DB_HOST: ${DB_HOST}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      DIR_NAME: backups  # Name for backup files (used in filenames)
      S3_ENDPOINT: ${S3_ENDPOINT}
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
    env_file: .env
    volumes:
      - ./yacron.yml:/etc/yacron/yacron.yml:ro
```

## Yacron Job Configuration (`yacron.yml`)
```yaml
jobs:
  - name: backup_defaultdb
    schedule: "0 3 * * *"   # Every day at 03:00 AM
    command: "backup --table defaultdb"
    shell: /bin/bash
    captureStdout: true
    captureStderr: true
```

**Notes:**
- `schedule` uses standard cron format: `minute hour day month weekday`.
- `command` points to the backup script inside the container.
- Output (stdout and stderr) will be captured and logged by Yacron.

## Backup File Naming
Backups are uploaded directly to the S3 bucket with a clear timestamped filename:

```
<DIR_NAME>_<TABLE_NAME>_<YYYYMMDD_HHMMSS>.sql.gz
```

**Example:**
```
backups_defaultdb_20251208_030000.sql.gz
```

✅ No additional folders are created in the S3 bucket.

## How to Run
1. Create `.env` with database and S3 credentials.
2. Place `yacron.yml` in the same directory as `docker-compose.yml`.
3. Start the service:

```bash
docker-compose up -d
```

4. Check logs:

```bash
docker-compose logs -f backup
```

## Notes
- Make sure the S3 bucket exists and credentials have write permissions.
- You can add more jobs in `yacron.yml` for multiple tables or databases.
- Use `docker-compose restart backup` after modifying `yacron.yml` to apply changes.
