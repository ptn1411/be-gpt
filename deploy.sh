#!/usr/bin/env bash
set -euo pipefail

APP_NAME="${APP_NAME:-chat-backend}"
INSTALL_DIR="${INSTALL_DIR:-/opt/${APP_NAME}}"
SERVICE_FILE="${SERVICE_FILE:-/etc/systemd/system/${APP_NAME}.service}"
BIN_PATH="${BIN_PATH:-target/release/${APP_NAME}}"

if [[ ! -x "$BIN_PATH" ]]; then
  if [[ -x "./${APP_NAME}" ]]; then
    BIN_PATH="./${APP_NAME}"
  else
    echo "Binary not found. Expected at $BIN_PATH or ./${APP_NAME}."
    echo "Giải nén artifact để có sẵn binary rồi chạy lại."
    exit 1
  fi
fi

echo "==> Using prebuilt binary at ${BIN_PATH}"

echo "==> Preparing install dir: ${INSTALL_DIR}"
sudo mkdir -p "${INSTALL_DIR}"

# stop service to avoid overwriting a running binary
sudo systemctl stop "${APP_NAME}.service" >/dev/null 2>&1 || true

# copy to temp then move atomically
sudo cp "${BIN_PATH}" "${INSTALL_DIR}/${APP_NAME}.new"
sudo mv -f "${INSTALL_DIR}/${APP_NAME}.new" "${INSTALL_DIR}/${APP_NAME}"
sudo chmod +x "${INSTALL_DIR}/${APP_NAME}"

echo "==> Copying environment file if present"
if [[ -f .env ]]; then
  sudo cp .env "${INSTALL_DIR}/"
fi

echo "==> Writing systemd service: ${SERVICE_FILE}"
sudo tee "${SERVICE_FILE}" >/dev/null <<EOF
[Unit]
Description=Chat Backend service
After=network.target

[Service]
Type=simple
WorkingDirectory=${INSTALL_DIR}
ExecStart=${INSTALL_DIR}/${APP_NAME}
Restart=on-failure
EnvironmentFile=${INSTALL_DIR}/.env

[Install]
WantedBy=multi-user.target
EOF

echo "==> Reloading and enabling service"
sudo systemctl daemon-reload
sudo systemctl enable --now "${APP_NAME}.service"

echo "==> Done. Check status with: sudo systemctl status ${APP_NAME}"
