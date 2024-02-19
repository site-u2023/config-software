# OpenWrt For new settings All-in-one script Suitable for beginners

:warning:**Please contact us if you have any problems**

### Script Selector
![selector](https://github.com/site-u2023/config-software/assets/140032047/38302c2c-58a2-48dc-99de-917830c29d24)

<details><summary>Configuration</summary>

:warning:Japanese notation
- [Script Selector](https://qiita.com/site_u/items/c6a50aa6dea965b5a774#%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%82%BB%E3%83%AC%E3%82%AF%E3%82%BF%E3%83%BC%E8%A6%81onu%E7%9B%B4%E7%B5%90)
  - [Initial system setup (host name, password, wifi, etc.)](https://qiita.com/site_u/items/59c641c9dc0eec3b1324)
  - [Internet connection setup in Japan (MAP-e, DS-LITE, PPPoE)](https://qiita.com/site_u/items/4b8076cb8c9b05bc3f9a)
    - OCN Virtual Connect automatic configuration (including Nichiban measures)
      - Only Nichiban countermeasure settings are executed
    - V6 Plus and IPv6 options automatically configured (including Nichiban measures)
      - Only Nichiban countermeasure settings are executed
    - Transix Auto Configuration
    - Xpass Auto Configuration
    - V6connect Auto Configuration
    - PPPoE (iPv4 and IPv6): Authentication ID (user name) and password required
      - Perform PPPoE IPv4 connection setup
      - Perform PPPoE IPv4 and IPv6 connection setup
  - [Recommended Package Installation](https://qiita.com/site_u/items/a23d165201081817cb00)[(USB auto-detection)](https://qiita.com/site_u/items/597199882dc4d56c2385#usb)
    - Automatic full installation (recommended package all-in)
    - Selective Install
    - Confirmation of packages installed after flashing
  - [Access point configuration (Dumb / Bridge)](https://qiita.com/site_u/items/0463c782be0acd6d23d3)
  - [Ad blocker and DNS encryption installation](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc)
    - [AdGuard HOME Setup and Installation](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#adguard-home)
      - Administrative web interface settings (port, username, and password only)
    - [AdBlockd installation and configuration (Japan only)](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#adblock)
      - AdBlock installation and configuration (custom filter add-in)
      - Installation and configuration of AdBlock-fast (custom filter add-in)
    - [DNS over HTTPS (DoH) configuration and installation](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#https-dns-proxy)
    - [DNS over TLS (DoT) configuration and installation](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#stubby)
  - [Home Assistant Installation](https://qiita.com/site_u/items/c33defca3eae1e8c62b8)
  - Other
    - [Button Setup and Installation](https://qiita.com/site_u/items/08764ce9473231482c17)
    - [IPERF3 installation and service addition](https://qiita.com/site_u/items/599124e2904d1374c2c9#iperf3)
    - [Location Based Service (LBS) Stop](https://qiita.com/site_u/items/3cd3fc65a789461262e8#%E4%BD%8D%E7%BD%AE%E6%83%85%E5%A0%B1%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E5%81%9C%E6%AD%A2)
    - [SAMBA4 and WSDD2 installation](https://qiita.com/site_u/items/aa9164859a78cb4e3f8f)
    - [DFS Check](https://qiita.com/site_u/items/f42be7c0953187b9428a#dfs-check)
  - Quit

---

</details>

<details><summary>Scripts</summary>

- [README.md](https://github.com/site-u2023/config-software/blob/main/README.md)
  - [openwrt-config.sh](https://github.com/site-u2023/config-software/blob/main/openwrt-config.sh)
    - [system-config.sh](https://github.com/site-u2023/config-software/blob/main/system-config.sh)
      - [system.sh](https://github.com/site-u2023/config-software/blob/main/system.sh)
    - [internet-config.sh](https://github.com/site-u2023/config-software/blob/main/internet-config.sh)
      - [map-e.sh](https://github.com/site-u2023/config-software/blob/main/map-e.sh)
      - [ds-lite.sh](https://github.com/site-u2023/config-software/blob/main/ds-lite.sh)
    - [package-config.sh](https://github.com/site-u2023/config-software/blob/main/package-config.sh)
      - [package-auto.sh](https://github.com/site-u2023/config-software/blob/main/package-auto.sh)
        - [package-auto-e.sh](https://github.com/site-u2023/config-software/blob/main/package-auto-e.sh)
        - [package-manual-g.sh](https://github.com/site-u2023/config-software/blob/main/package-manual-g.sh)
      - [package-manual.sh](https://github.com/site-u2023/config-software/blob/main/package-manual.sh)
        - [package-manual-e.sh](https://github.com/site-u2023/config-software/blob/main/package-manual-e.sh)
        - [package-manual-g.sh](https://github.com/site-u2023/config-software/blob/main/package-manual-g.sh)
      - [install-config.sh](https://github.com/site-u2023/config-software/blob/main/install-config.sh)
    - [dumb-config.sh](https://github.com/site-u2023/config-software/blob/main/dumb-config.sh)
      - [dumb.sh](https://github.com/site-u2023/config-software/blob/main/dumb.sh)
    - [ad-dns-blocking-config.sh](https://github.com/site-u2023/config-software/blob/main/ad-dns-blocking-config.sh)
      - [adguard-config.sh](https://github.com/site-u2023/config-software/blob/main/adguard-config.sh)
        - [adguardhome.yaml](https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml)
        - [adguardhome.yaml-g](https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml-g)
        - [htpasswd](https://github.com/site-u2023/config-software/blob/main/htpasswd)
        - [htpasswd-x86](https://github.com/site-u2023/config-software/blob/main/htpasswd-x86)
        - [adguard.sh](https://github.com/site-u2023/config-software/blob/main/adguard.sh)
      - [adblock-config.sh](https://github.com/site-u2023/config-software/blob/main/adblock-config.sh)
        - [adblock.sh](https://github.com/site-u2023/config-software/blob/main/adblock.sh)
        - [adblock-fast.sh](https://github.com/site-u2023/config-software/blob/main/adblock-fast.sh)
    - [HomeAssistant](https://github.com/site-u2023/config-software/blob/main/homeassistant.sh)
    - [etc-config.sh](https://github.com/site-u2023/config-software/blob/main/etc-config.sh)
      - [button-config.sh](https://github.com/site-u2023/config-software/blob/main/button-config.sh)
        - [button.sh](https://github.com/site-u2023/config-software/blob/main/button.sh)
      - [iperf3](https://github.com/site-u2023/config-software/blob/main/ad-dns-blocking-config.sh)
      - [dfs_check.sh](https://github.com/site-u2023/config-software/blob/main/dfs_check.sh)
      - [dfs_check](https://github.com/site-u2023/config-software/blob/main/dfs_check)
---

</details>

### Setting
Using SSH with powershell
- powershell > `Win`+`x` > `a` > `yes`
```powershell:powershell
ssh root@192.168.1.1

```
- `yes`

<details><summary>:exclamation:If you cannot SSH login</summary>

`C:\Users\yourusername\.ssh\known_hosts`
※Windows Hidden Files
```powershell:powershell
Clear-Content .ssh\known_hosts -Force

```
---

</details>
 
ttyd installation and configuration
- [ttyd.sh](https://github.com/site-u2023/config-software/blob/main/ttyd.sh)
```sh:SSH
mkdir -p /etc/config-software; wget --no-check-certificate -O /etc/config-software/ttyd.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ttyd.sh; sh /etc/config-software/ttyd.sh

```
:warning:Internet connection setup requires device to be connected directly to ONU (Japan Only)
<details><summary>:exclamation:MAP-e or other IPv4 unconnected</summary>

https://github.com/ can be connected using IPv6
  - Connect client for setup to LAN1
```sh:SSH
# IPv6 Usage Settings
uci add network device
uci set network.@device[-1].name='lan1'
uci set network.@device[-1].mtu='1500'
uci set network.@device[-1].ipv6='1'
uci set network.@device[-1].mtu6='1500'
#
uci commit network
/etc/init.d/network reload

```
---

</details>

### Run Script
- Run from browser

  [192.168.1.1:8888](http://192.168.1.1:8888)
  - Permited only from LAN side
  - No login authentication

:warning: Can be changed from ttyd settings

- Run from command
```sh:SSH
confsoft

```
:warning: forced termination：`Ctrl`+`c`

### Remove
```sh :SSH
rm -rf /etc/config-software
rm -rf /usr/bin/confsoft

```


### [LuCi](https://openwrt.org/jp/doc/howto/firstlogin#login_to_webui)
- Run from LuCi: [192.168.1.1](http://192.168.1.1/cgi-bin/luci/)
  - User Name：`root`
  - Password：`Password you set`
- Run from QR Code: 192.168.1.1

![QR192.168.1.1.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3412833/93eed9ce-7319-9332-99ba-74455b471cdd.png) 


### [TTYD](https://openwrt.org/packages/pkgdata_owrt18_6/ttyd) :warning:[Included in all-in-one script configuration](https://qiita.com/site_u/items/c6a50aa6dea965b5a774#%E8%A8%AD%E5%AE%9A)
- Run from browser: [http://192.168.1.1:7681/](http://192.168.1.1:7681/)
  - User Name：`root`
  - Password：`Password you set`

- Run from LuCi: [http://192.168.1.1/cgi-bin/luci/admin/services/ttyd](http://192.168.1.1/cgi-bin/luci/admin/services/ttyd)

- Run from QR Code: 192.168.1.1:7681

![QR_062248.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3412833/e7929d2e-d9b0-b599-33cf-55413d584b19.png)


### [SFTP](https://openwrt.org/docs/guide-user/services/nas/sftp.server) :warning:Installation required (in recommended package)

- SFTP Download: [WinSCP](https://winscp.net/eng/download.php)
  Filer (used like Explorer with WinSCP)
  Start WinSCP

- Session
  - Host Nmae：`192.168.1.1`
  - User Name：`root`
  - Password：`Password you set`
  - login `Click `




Qiita: [Beginner's memorandum Introduced from Windows](https://qiita.com/site_u/items/39fbac482c06c98b229b)
