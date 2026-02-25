#!/bin/sh

SCRIPT="/data/run.sh"
SESSION="runsh"

install_nezha_agent_if_configured() {
  missing=""
  [ -n "${NZ_SERVER:-}" ] || missing="$missing NZ_SERVER"
  [ -n "${NZ_CLIENT_SECRET:-}" ] || missing="$missing NZ_CLIENT_SECRET"
  [ -n "${NZ_UUID:-}" ] || missing="$missing NZ_UUID"

  if [ -n "$missing" ]; then
    echo "[Nezha] Skip: missing env:$missing"
    return 0
  fi

  NZ_TLS_VAL="${NZ_TLS:-false}"

  echo "[Nezha] Env detected, installing agent (NZ_SERVER=$NZ_SERVER, NZ_TLS=$NZ_TLS_VAL)"

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  curl -fsSL "https://raw.githubusercontent.com/nezhahq/scripts/main/agent/install.sh" -o "$tmpdir/agent.sh"
  chmod +x "$tmpdir/agent.sh"

  env NZ_SERVER="$NZ_SERVER" NZ_TLS="$NZ_TLS_VAL" NZ_CLIENT_SECRET="$NZ_CLIENT_SECRET"  NZ_UUID="$NZ_UUID" "$tmpdir/agent.sh"

  echo "[Nezha] Agent install script executed."
}

config=${APP_CONFIG:-/app/config.json}

echo config=$config
echo config.json 
echo .
cat $config

echo nginx conf
echo .

cat /etc/nginx/nginx.conf
nohup nginx -c /etc/nginx/nginx.conf > /dev/null 2>&1 &

ls -alh /app
ps -ef 

install_nezha_agent_if_configured

if [[ -f "$SCRIPT" ]]; then
  chmod +x "$SCRIPT" || true
  
  if screen -list | grep -q "\.${SESSION}[[:space:]]"; then
    echo "[entrypoint] screen session '${SESSION}' already exists; not starting again."
  else
    echo "[entrypoint] starting '${SCRIPT}' in screen session '${SESSION}'..."
    screen -DmS "$SESSION" bash -lc "$SCRIPT"
  fi
else
  echo "[entrypoint] '$SCRIPT' not found; skipping."
fi

/app/v2ray run -c $config