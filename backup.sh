#!/bin/bash
set -euo pipefail

while [[ $# -gt 0 ]]; do
  [[ "$1" == "--table" ]] && TABLE_NAME="$2" && shift 2 || shift
done

if [ -z "${TABLE_NAME:-}" ]; then
  echo "Error: --table argument is required"
  exit 1
fi

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE_NAME=${TABLE_NAME}_${TIMESTAMP}.sql.gz
FILE_PATH="/tmp/${FILE_NAME}"

echo "[$(date)] Starting backup for table $TABLE_NAME..."

mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$TABLE_NAME" | gzip > "$FILE_PATH"

s3md put "$FILE_PATH" "S3://${DIR_NAME}//${FILE_NAME}"

rm -f "$FILE_PATH"

echo "[$(date)] Backup completed successfully for table $TABLE_NAME."