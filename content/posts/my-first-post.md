+++
title = "Windows10で公開鍵認証の鍵ペアを生成"
date = 2023-08-24T14:35:04+09:00
tags = ["github","gitlab"]
draft = false
toc = false
backtotop = false
+++

# Windows10で公開鍵認証の鍵ペアを生成

Windows10にて公開鍵認証の鍵ペアを生成し、GitHubに公開鍵を登録する手順をまとめます。

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


# Gitの設定

## git 全体のユーザー名・メールアドレスの設定です
```git
git config --global user.name "GitHubのユーザー名"
git config --global user.email "GitHubのメールアドレス"
```

## 確認方法

```git
git config --global --list
```

```git
user.email="GitHubのメールアドレス"
user.name="GitHubのユーザー名"
```

* ![user-name][2]GitHubのユーザ名は、GitHubで確認する。



## Gitに秘密鍵を指定する
~/.ssh/configを作成
```config
Host github.com
    IdentityFile ~/.ssh/id_ed25519_github.com_key #ここに作成した秘密鍵を指定する
    TCPKeepAlive yes
    IdentitiesOnly yes
    User git
```

# 公開鍵の登録

1. GiHubにログイン
1. GitHubのRepositoriesを選択する
1. [Settings]-[Deploy keys]をクリックする。[Add Deploy key]をクリックする
1. ![add-new-key][3]　<br>"Allow write access"にチェックを必ず入れる


# 確認方法

Powershellを起動して下記コマンドを実行する。
```powershell
ssh -T git@github.com
```

"You've successfully authenticated" と表示されることを確認する。

```powershell
Hi ancient-blog/hugo.github.io! You've successfully authenticated, but GitHub does not provide shell access.
```

[1]: https://ancient-blog.github.io/hugo.github.io/images/generate-key-pair-for-public-key-authentication-in-windows10-and-connect-to-server-with-ssh-01.png
[2]: https://ancient-blog.github.io/hugo.github.io/images/github-user-name.PNG
[3]: https://ancient-blog.github.io/hugo.github.io/images/add-new-deploy-key.PNG