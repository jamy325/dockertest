config=${APP_CONFIG:-/app/config.json}
echo config=$config
echo config.json 
echo .
cat $config

echo nginx conf
echo .

cat /etc/nginx/nginx.conf
nginx -s reload

/app/v2ray run -c $config