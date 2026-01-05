config=${APP_CONFIG:-/app/config.json}
echo config=$config
cat $config
/app/v2ray run -c $config
