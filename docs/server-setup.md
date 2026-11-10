# Конфигурация виртуальной машины devops-vm

## 1. Параметры машины
- ОЗУ: 2048 МБ
- Ядра: 2
- Диск: 25 ГБ

## 2. Сетевые интерфейсы
- Адаптер 1 (NAT, enp0s3): IP 10.0.2.15, для доступа в интернет.
- Адаптер 2 (Host-only, enp0s8): IP 192.168.56.101, для связи с хостом.

## 3. Проброс портов
- Хост: 2222 -> Гость: 2222 (SSH)

## 4. Учётные записи
- `student` (sudo, пароль)
- `devops` (sudo, вход по SSH-ключу)

## 5. Служба SSH
- Порт: 2222
- Файл конфигурации: `/etc/ssh/sshd_config.d/99-hardening.conf`
- Отключен вход root, отключены пароли, MaxAuthTries 3, AllowUsers devops.

## 6. Правила межсетевого экрана (UFW)
- Status: active
- Default: deny incoming, allow outgoing
- Правила: 2222/tcp LIMIT (SSH), 80/tcp (HTTP), 443/tcp (HTTPS)

## 7. Снимки состояния
- `01-clean-install` — чистая установка.
- `02-keys-configured` — настроен вход по ключу для devops.
- `03-ssh-hardened` — усилена защита SSH.
## 8. Веб-сервер
- Установлен пакет: `nginx`.
- Конфигурация ресурса: `/etc/nginx/sites-available/devops-site`.
- Каталог ресурса: `/var/www/devops-site`, владелец `devops:devops`, права 755 (папка) и 644 (файлы).
- Сертификат: `/etc/ssl/certs/devops.crt` (права 644).
- Приватный ключ: `/etc/ssl/private/devops.key` (владелец root, права 600).
- Срок действия сертификата: 365 дней.