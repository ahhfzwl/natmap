# NAT映射
[![状态](https://github.com/heiher/natmap/actions/workflows/build.yaml/badge.svg?branch=main&event=push)](https://github.com/heiher/natmap)
[![聊天](https://github.com/heiher/natmap/raw/main/.github/badges/telegram.svg)](https://t.me/hellonatter)
该项目用于从 ISP NAT 公共建立 TCP/UDP 端口映射
地址到本地私有地址。如果 NAT 的所有层都是全锥体 (NAT-1)，
任何主机都可以通过映射的公网地址访问内部服务。绑定中
模式下，所有流量不经过此程序。
[中文文档](https://github.com/heiher/natmap/wiki)
## 如何构建
````bash
git clone --recursive https://github.com/heiher/natmap.git
光盘自然地图
使
# 静态链接
使 ENABLE_STATIC=1
# 交叉编译
make CROSS_PREFIX=${跨工具链}/bin/x86_64-unknown-linux-
# 安卓
mkdir natmap
光盘自然地图
git clone --recursive https://github.com/heiher/natmap.git jni
ndk构建
# 窗口 (msys2)
导出 MSYS=winsymlinks:native
git clone --recursive https://github.com/heiher/natmap.git
光盘自然地图
使
````
## 如何使用
### 用法
````
用途：
natmap [选项]
选项：
-4 使用 IPv4
-6 使用 IPv6
-u UDP模式
-d 作为守护进程运行
-i <interface> 网络接口或 IP 地址
-k <interval> 每次保持活动之间的秒数
-c <count> UDP STUN 检查周期（每个 <count> 间隔）
-s <addr>[:port] STUN服务器的域名或地址
-h <addr>[:port] HTTP 服务器的域名或地址
-e <path> 通知映射地址的脚本路径
-f <mark> fwmark 值（十六进制：0x1，十进制：1，八进制：01）
绑定选项：
-b 绑定的端口号范围
- <0>：随机分配
- <端口>：指定
- <port>~<port>：范围内随机分配
- <port>-<port>：范围内顺序分配
转发选项：
-C <congestion> TCP拥塞控制算法
-T <timeout> 端口转发超时时间（以秒为单位）
-t <地址> 转发目标的域名或地址
-p <port> 转发目标的端口号（0：使用公共端口）
````
### 绑定模式
````bash
# TCP
natmap -s 转.cloudflare.com -h example.com -b 80
# UDP
natmap -u -s 转.cloudflare.com -b 443
````
在TCP模式下，该程序将分两步建立TCP端口映射：
1. 从指定的绑定端口与HTTP服务器建立连接并
让它活下去。
2.从同一端口与STUN服务器建立连接并获取
公共地址。
然后该程序将调用参数指定的脚本来通知
建立端口映射后的公网地址。脚本可以更新
用于外部访问的 DNS 记录。
Windows TCP 模式下，请确保您的应用服务器绑定了本地
网络 IP，而不是“0.0.0.0”和“::”。
在Windows上的UDP模式下，确保您的应用程序服务器绑定到“0.0.0.0”
或 `::`，而不是本地网络 IP。
请注意，您需要打开防火墙以允许访问绑定端口。
#### OpenWrt
转到网络 -> 防火墙 -> 流量规则
添加交通规则：
* 协议：TCP/UDP
* 来源区域：wan
* 目标区域：设备（输入）
* 目的端口：[绑定端口]
* 行动：接受
* 其他：保持默认值
如果端口绑定由于已在使用中而失败，则该程序将尝试
找出哪个本地服务进程占用了端口并启用端口复用
远程。这适用于 Linux 内核 5.6 及更高版本，并且需要以 root 身份运行。
### 前进模式
````bash
# TCP
natmap -s 转.cloudflare.com -h example.com -b 80 -t 10.0.0.2 -p 80
# UDP
natmap -u -s 转.cloudflare.com -b 443 -t 10.0.0.2 -p 443
````
与绑定模式类似，该程序将监听绑定端口，接受传入的
连接，并将它们转发到目标地址。
另一种方式是使用防火墙的DNAT进行转发，这种方式应该使用bind
模式。
#### OpenWrt
转到网络 -> 防火墙 -> 端口转发
添加端口转发规则：
* 协议：TCP/UDP
* 来源区域：wan
* 外部端口：[绑定端口]
* 目标区域：lan
* 内部IP地址：10.0.0.2
* 内部端口：80
* 其他：保持默认值
### 脚本参数
````
{公共地址} {公共端口} {ip4p} {私有端口} {协议} {私有地址}
````
* argv[0]: 脚本路径
* argv[1]：公共地址（IPv4/IPv6）
* argv[2]: 公共端口
* argv[3]: IP4P
* argv[4]: 绑定端口（私有端口）
* argv[5]：协议（TCP/UDP）
* argv[6]：私有地址（IPv4/IPv6）
### IP4P地址
IP4P地址格式使用IPv6特殊地址对IPv4地址进行编码，
用于通过 DNS AAAA 记录轻松分发的端口。
````
2001::{端口}:{ipv4-hi16}:{ipv4-lo16}
````
### OpenWrt 22.03+
仓库：https://github.com/openwrt/packages/tree/master/net/natmap
````嘘
# 安装包
opkg 安装 natmap luci-app-natmap
````
### 码头工人
* 支持**amd64**、**arm64**、**arm**、**riscv64**、**s390x**。
* 图片标签：最新、[发布标签] 如 20250512
* 将命令更改为您想要的。
* 卷脚本路径，并确保有权限运行。
docker-compose.yml
```docker-compse
服务：
国家地图：
容器名称：natmap
图片：ghcr.io/heiher/natmap:main
命令：-u -s stun.qq.com -b 30101 -t 127.0.0.1 -p 51820 -e /opt/cf_ip4p.sh -k 60
卷：
- ./natmap/cf_ip4p.sh:/opt/cf_ip4p.sh
上限添加：
- NET_管理员
特权：真实
环境：
- TZ=亚洲/上海
网络模式：主机
重新启动：始终
````
### 窗口
#### 独家报道
清单：https://github.com/ScoopInstaller/Main/blob/master/bucket/natmap.json
````pwsh
铲斗添加主
舀安装主/natmap
````
## 贡献者
* **abgelehnt** - https://github.com/abgelehnt
* **goimer** - https://github.com/goimer
* **hev** - https://hev.cc
* **lxeon** - https://github.com/lxeon
* **迈克王** - https://github.com/mikewang000000
* **muink** - https://github.com/muink
* **ragingbulld** - https://github.com/ragingbulld
* **沉天灵** - https://github.com/1715173329
* **无字回声** - https://github.com/wordlessecho
* **xhe** - https://github.com/xhebox
## 许可证
麻省理工学院
