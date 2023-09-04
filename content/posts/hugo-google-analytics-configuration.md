+++
title = "HugoウェブサイトのにGoogle Analyticsのトラッキングコードを設定"
date = 2023-09-04T16:31:17+09:00
tags = ["hugo","Github","actions"]
draft = false
toc = false
backtotop = false
+++

# Hugo WebサイトにGoogle Analyticsのトラッキングコード追加

## はじめに
Webサイトへのアクセス状況を解析するためのツールにGoogleアナリティクスを設定する

## 前提条件

1. Googleアカウントを事前に作成しておく
1. GitHubのアカウントを事前に作成しておく
1. Hugoの自動デプロイワークフローを作成している

## 手順
1. Google Analyticsのトラッキングコードを取得する。
1. Hugoプロジェクトのconfig.tomlファイルを編集する。
1. Githubの"Secrets and variables"を設定する。
1. G-XXXXXXXXXXを置換をワークフローに追加する
1. Hugoウェブサイトをビルドしてください。
1. Google Analyticsのトラッキングが正しく設定されているか確認


### Google Analyticsのトラッキングコードを取得

[こちら](https://analytics.google.com/analytics/web/provision/#/provision)からアクセスする。

### Hugoプロジェクトのconfig.tomlファイルを編集

config.toml
``` toml:config.toml
googleAnalytics = "G-XXXXXXXXXX"
```

にトラッキングコードを追加する

### **Githubの"Secrets and variables"を設定**

[settings]-[Secrets and variables]-[Actions]-[Variables]-[New repository variable]

GOOGLE_ANALYTICS_TRACKING_CODEを作成してGoogle Analyticsのトラッキングコードを入力する。

### **G-XXXXXXXXXXを置換する**

G-XXXXXXXXXXを${{ vars.GOOGLE_ANALYTICS_TRACKING_CODE }}に置換する

``` yaml
      - name: To set up Google Analytics tracking code in a Hugo website's config.toml file.
        run: |
          sed -i s/G-XXXXXXXXXX/${{ vars.GOOGLE_ANALYTICS_TRACKING_CODE }}/ config.toml
```

### **Google Analyticsのトラッキングの確認方法**

```
> hugo
```
上記コマンドでビルドするとpublicフォルダが作成される。
index.htmlに下記が含まれていることを確認する。

``` html:index.html
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
    <script>
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', 'G-XXXXXXXXXX');
  </script>
```

