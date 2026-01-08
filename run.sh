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

/app/v2ray run -c $config