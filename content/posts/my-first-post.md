+++
title = "Windows10で公開鍵認証の鍵ペアを生成"
date = 2023-08-24T14:35:04+09:00
tags = ["gitlab"]
draft = false
toc = false
backtotop = false
+++

# Windows10で公開鍵認証の鍵ペアを生成

Windows10にて公開鍵認証の鍵ペアを生成する手順をまとめます。

<!-- toc -->


## 設定する内容

* 公開鍵認証のデジタル署名アルゴリズムは「ed25519」を利用
* 秘密鍵にはパスフレーズを設定しない　(任意)
* パスワード認証方式を無効化（公開鍵認証以外は全て無効にする。）

## Windows10で公開鍵認証の鍵ペアを生成

```powershell
ssh-keygen -t ed25519 -f .ssh/id_ed25519_github.com_key -C " "
```

パスフレーズを聞いてきますのでパスフレーズなしでエンターを押下します。（2回）

```powershell
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

![ssh-key][1]

[1]: https://ancient-blog.github.io/hugo.github.io/images/generate-key-pair-for-public-key-authentication-in-windows10-and-connect-to-server-with-ssh-01.png