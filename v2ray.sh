#!/bin/bash

// 安装可执行文件和 .dat 数据文件
echo "y" | bash <(sudo curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh)

// 只更新 .dat 数据文件
echo "y" | bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-dat-release.sh)

#移除 V2Ray
# sudo bash <(curl -L https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh) --remove##

v2ray_uuid=$(sudo v2ray uuid)

echo $v2ray_uuid

bash -c "cat > /usr/local/etc/v2ray/config.json" << EOF
{
	"log": {
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log",
		"loglevel": "warning"
	},
	"inbounds": [{
		"port": 9001,
		"protocol": "vmess",
		"settings": {
			"clients": [{
				"id": "$v2ray_uuid"
			}]
		}
	}],
	"outbounds": [{
		"protocol": "freedom",
		"settings": {}
	}]
}
EOF

# 加这一行环境变量用于解决invalid user的问题
echo "Environment=\"V2RAY_VMESS_AEAD_FORCED=false\"" >> /etc/systemd/system/v2ray.service
systemctl daemon-reload
systemctl restart v2ray
