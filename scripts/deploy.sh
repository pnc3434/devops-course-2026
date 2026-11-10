#!/usr/bin/env bash
set -euo pipefail

REMOTE="devops"
REMOTE_DIR="/var/www/devops-site"
SITE_URL="https://devops.local"
CA_CERT="${HOME}/devops.crt"
LOCAL_DIR="$(git rev-parse --show-toplevel)/site/"

DRY_RUN=""
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN="--dry-run"
elif [[ -n "${1:-}" ]]; then
    echo "Неизвестный аргумент: $1" >&2
    exit 1
fi

# Проверка наличия index.html
if [[ ! -f "${LOCAL_DIR}index.html" ]]; then
    echo "Ошибка: файл site/index.html отсутствует." >&2
    exit 1
fi

# Проверка незафиксированных изменений
if [[ -n "$(git status --porcelain)" ]]; then
    echo "Ошибка: в репозитории есть незафиксированные изменения." >&2
    exit 1
fi

# Синхронизация
rsync -avz --delete --chmod=D755,F644 ${DRY_RUN} "${LOCAL_DIR}" "${REMOTE}:${REMOTE_DIR}/"

if [[ -n "${DRY_RUN}" ]]; then
    exit 0
fi

# Проверка доступности
if ! curl -sf --cacert "${CA_CERT}" "${SITE_URL}" > /dev/null; then
    echo "Ошибка: ресурс ${SITE_URL} недоступен." >&2
    exit 1
fi

COMMIT_HASH=$(git rev-parse --short HEAD)
echo "Успешный деплой. Коммит: ${COMMIT_HASH}"
exit 0