# OpenWrt For new settings All-in-one script Suitable for beginners

Japanese notation

**不具合あればご連絡下さい**

### スクリプトセレクター※要ONU直結
![config-software.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3412833/57dfcfee-8654-8782-40f9-3da30e69df61.png)

### powershellでSSHを使う
- powershell > `Win`+`x` > `a` > `はい`
```powershell:powershell
ssh root@192.168.1.1

```
- `yes`

<details><summary>SSHログイン出来ない場合</summary>

`C:\Users\yourusername\.ssh\known_hosts`
※Windows隠しファイル
```powershell:powershell
Clear-Content .ssh\known_hosts -Force

```
---

</details>

### ttydのインストールと設定
- [ttyd.sh](https://github.com/site-u2023/config-software/blob/main/ttyd.sh)
```sh:SSH
mkdir -p /etc/config-software; wget --no-check-certificate -O /etc/config-software/ttyd.sh https://raw.githubusercontent.com/site-u2023/config-software/main/ttyd.sh; sh /etc/config-software/ttyd.sh

```

<details><summary>MAP-eなどIPv4未接続の場合</summary>

※https://github.com/ はIPv6利用で接続可
  - 設定用クライアントをLAN1に接続
```sh:SSH
# IPv6利用設定
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

### ttydの実行
- ttyd（ブラウザ）から実行
**[`192.168.1.1:8888`](http://192.168.1.1:8888)**

- コマンドから実行
```sh:SSH
confsoft

```
※強制終了：`Ctrl`+`c`

### 構成
- [スクリプトセレクター](https://qiita.com/site_u/items/c6a50aa6dea965b5a774#%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%97%E3%83%88%E3%82%BB%E3%83%AC%E3%82%AF%E3%82%BF%E3%83%BC%E8%A6%81onu%E7%9B%B4%E7%B5%90)
  - [システム初期設定（ホストネーム・パスワード等）](https://qiita.com/site_u/items/59c641c9dc0eec3b1324)
  - [インターネット（MAP-e・DS-LITE・PPPoE）接続設定](https://qiita.com/site_u/items/4b8076cb8c9b05bc3f9a)
    - OCNバーチャルコネクト自動設定（ニチバン対策含む）
      - ニチバン対策の設定のみ実行 
    - V6プラス・IPv6オプション自動設定（ニチバン対策含む）
      - ニチバン対策の設定のみ実行 
    - トランジックス自動設定
    - クロスパス自動設定
    - v6 コネクト自動設定
    - PPPoE（iPv4・IPv6）: 要認証ID（ユーザー名）・パスワード
      - PPPoEのIPv4接続の設定を実行
      - PPPoEのIPv4及びIPv6接続の設定を実行
    - 終了
  - [推奨パッケージインストール](https://qiita.com/site_u/items/a23d165201081817cb00)[（USB自動判別）](https://qiita.com/site_u/items/597199882dc4d56c2385#usb)
    - 自動フルインストール（推奨パッケージオールイン）
    - 選択インストール
    - フラッシュ後にインストールしたパッケージ確認
  - [アクセスポイント（Dumb / ブリッジ）設定](https://qiita.com/site_u/items/0463c782be0acd6d23d3)
  - [広告ブロッカー・DNS暗号化インストール](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc)
    - [AdGuard HOMEの設定とインストール（カスタムフィルターアドイン）](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#adguard-home)
      - 管理用ウェブインターフェイス設定（ポート・ユーザー名・パスワードのみ）
    - [AdBlockdのインストールと設定（カスタムフィルターアドイン）](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#adblock)
      - AdBlockのインストールと設定（カスタムフィルターアドイン）
      - AdBlock-fastのインストールと設定（カスタムフィルターアドイン）
    - [DNS over HTTPS（DoH）のインストールと設定](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#https-dns-proxy)
    - [DNS over TLS（DoT）Stubbyのインストールと設定](https://qiita.com/site_u/items/cf34ea1ee9a1971272bc#stubby)
  - 他
    - [ボタン設定とインストール](https://qiita.com/site_u/items/08764ce9473231482c17)
    - [IPERF3インストール及びサービス追加](https://qiita.com/site_u/items/599124e2904d1374c2c9#iperf3)
    - [WiFi位置情報サービス停止（LBS）](https://qiita.com/site_u/items/3cd3fc65a789461262e8#%E4%BD%8D%E7%BD%AE%E6%83%85%E5%A0%B1%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E5%81%9C%E6%AD%A2)
    - [SAMBA4](https://qiita.com/site_u/items/aa9164859a78cb4e3f8f)
  - 終了

### スクリプト
- [オールインワンスクリプト](https://github.com/site-u2023/config-software/blob/main/README.md)
  - [openwrt-config.sh](https://github.com/site-u2023/config-software/blob/main/openwrt-config.sh)
    - [system-config.sh](https://github.com/site-u2023/config-software/blob/main/system-config.sh)
      - [system.sh](https://github.com/site-u2023/config-software/blob/main/system.sh)
    - [internet-config.sh](https://github.com/site-u2023/config-software/blob/main/internet-config.sh)
      - [map-e.sh](https://github.com/site-u2023/config-software/blob/main/map-e.sh)
      - [ds-lite.sh](https://github.com/site-u2023/config-software/blob/main/ds-lite.sh)
    - [package-config.sh](https://github.com/site-u2023/config-software/blob/main/package-config.sh)
      - [package-auto.sh](https://github.com/site-u2023/config-software/blob/main/package-auto.sh)
      - [package-manual.sh](https://github.com/site-u2023/config-software/blob/main/package-manual.sh)
      - [install-config.sh](https://github.com/site-u2023/config-software/blob/main/install-config.sh)
    - [dumb-config.sh](https://github.com/site-u2023/config-software/blob/main/dumb-config.sh)
      - [dumb.sh](https://github.com/site-u2023/config-software/blob/main/dumb.sh)
    - [ad-dns-blocking-config.sh](https://github.com/site-u2023/config-software/blob/main/ad-dns-blocking-config.sh)
      - [adguard-config.sh](https://github.com/site-u2023/config-software/blob/main/adguard-config.sh)
        - [adguardhome.yaml](https://raw.githubusercontent.com/site-u2023/config-software/main/adguardhome.yaml)
        - [htpasswd](https://github.com/site-u2023/config-software/blob/main/htpasswd)
        - [adguard.sh](https://github.com/site-u2023/config-software/blob/main/adguard.sh)
      - [adblock-config.sh](https://github.com/site-u2023/config-software/blob/main/adblock-config.sh)
        - [adblock.sh](https://github.com/site-u2023/config-software/blob/main/adblock.sh)
        - [adblock-fast.sh](https://github.com/site-u2023/config-software/blob/main/adblock-fast.sh)
    - [etc-config.sh](https://github.com/site-u2023/config-software/blob/main/etc-config.sh)
      - [button-config.sh](https://github.com/site-u2023/config-software/blob/main/button-config.sh)
        - [button.sh](https://github.com/site-u2023/config-software/blob/main/button.sh)
      - [iperf3](https://github.com/site-u2023/config-software/blob/main/ad-dns-blocking-config.sh)

### 削除
```sh :SSH
rm -rf /usr/bin/confsoft

```

Qiita: [初心者備忘録 Windowsから導入](https://qiita.com/site_u/items/39fbac482c06c98b229b)
