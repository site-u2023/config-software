# OpenWrt For new settings All-in-one script Beginner friendly  Japanese

This README is edited in Japanese.

### 選択型自動初期設定

初心者向けに自動設定
- オールインワンスクリプト
  -  スクリプトリムーブ後終了
     -  復元用ファイル未削除
- システム初期設定
  - デバイス:ホストネーム及びパスワード手動入力
  - WiFiSSID及びパスワード手動入力
  - トライバンド自動判別
  - LED非対応
- パッケージインストール
  - フラッシュ容量自動判別
  - CPU数自動判別irqbalanceインストール（4CPUから）
  - USB自動判別
- アクセスポイント設定
  - IPアドレス手動入力
  - ゲートウェイ手動入力 
- 広告ブロッカー・DNS暗号化インストール
  - AdGuard
    - フラッシュ容量自動判別
    - ユーザー名手動入力
    - パスワード手動入力（bcrypt方式暗号化パスワード）
- その他
  - IPERF3
  - WiFi位置情報サービス停止
 
![openwrt-config](https://github.com/site-u2023/config-software/assets/140032047/ad4e0eef-3e16-4555-9033-ea3912f6a96e)




### ワンコピペ自動スクリプト※要ONU直結

推奨設定順序: システム > インターネット > パッケージ
```
mkdir /etc/config-software; wget --no-check-certificate -O /etc/config-software/openwrt-config.sh https://raw.githubusercontent.com/site-u2023/config-software/main/openwrt-config.sh; sh /etc/config-software/openwrt-config.sh

```
※強制終了：`Ctrl`+`c`


QIITA:
https://qiita.com/site_u/items/c6a50aa6dea965b5a774



