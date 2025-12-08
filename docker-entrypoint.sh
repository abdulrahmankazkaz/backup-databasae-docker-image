#!/bin/bash
set -e

# إنشاء مجلد config
mkdir -p /root/.config/rclone

# إنشاء rclone.conf ديناميكيًا
cat > /root/.config/rclone/rclone.conf <<EOF
[r2]
type = s3
provider = Cloudflare
access_key_id = ${AWS_ACCESS_KEY_ID}
secret_access_key = ${AWS_SECRET_ACCESS_KEY}
region = auto
endpoint = ${S3_ENDPOINT}
EOF

exec yacron --config /etc/yacron/yacron.yml
