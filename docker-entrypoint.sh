#!/bin/bash
set -e

mkdir -p /root/.config/rclone

cat > /root/.s3cfg <<EOF
[default]
access_key = ${AWS_ACCESS_KEY_ID}
secret_key = ${AWS_SECRET_ACCESS_KEY}
host_base = ${S3_ENDPOINT}
host_bucket = ${S3_ENDPOINT}
use_https = True
EOF

exec yacron --config /etc/yacron/yacron.yml


