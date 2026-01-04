注意事项 
 - 镜像默认导出的端口为443

 - 启动docker时传递变量APP_CONFIG=/etc/v2flyconfig.json

```sh
docker run --rm -p 443:443 -v "./config.json:/etc/v2flyconfig.json:ro" -e "APP_CONFIG=/etc/config.json"  myapp:1.1
```

一个例子vless + websocket  的 config.json例子
```json
{
    "log": {
        "loglevel": "debug"
    },
    "inbounds": [
        {
            "port": 443,
            "listen": "0.0.0.0",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "0affffe4-3f7e-423f-9192-b75a17b7ec64",
                        "level": 0,
                        "email": "love@v2fly.org"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
					"acceptProxyProtocol": true,//启用nginx反代的话，注释这句话
                    "path": "/data"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
```

客户端连接
```json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": 10800,
            "listen": "127.0.0.1",
            "protocol": "socks",
            "settings": {
                "udp": true
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "vless",
            "settings": {
                "vnext": [
                    {
                        "address": "example.com", // 换成你的域名或服务器 IP（发起请求时无需解析域名了）
                        "port": 443,
                        "users": [
                            {
                                "id": "0affffe4-3f7e-423f-9192-b75a17b7ec64", // 填写你的 UUID
                                "encryption": "none",
                                "level": 0
                            }
                        ]
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "tls",
                "tlsSettings": {
                    "serverName": "example.com" // 换成你的域名
                },
                "wsSettings": {
                    "path": "/data" // 必须换成自定义的 PATH，需要和服务端的一致
                }
            }
        }
    ]
}
```