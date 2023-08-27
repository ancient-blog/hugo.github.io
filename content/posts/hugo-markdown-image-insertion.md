+++
title = "HugoとGitHub Actionsで画像付きの記事をGitHub Pagesを自動デプロイ"
date = 2023-08-26T17:13:51+09:00
tags = ["hugo","markdown","github","actions"]
draft = false
toc = false
backtotop = false
+++

# Title

<!-- toc -->

## Contents

### 前提条件
* Hugo (静的サイトジェネレータ) + Github Pages/actionsを利用する。
* GitHub actionsで自動デプロイ
* GItHub actionsのactions/upload-pages-artifact@v2アクションを利用して./publicをアーティファクトとしてアップロードする。


#### テスト画像とマークダウンの準備

テスト用の画像を2個用意して、検証する。test.md

* content/posts/test.mdに画像を表示する。
* content/images/test_1.PNG を用意する。
    * ![test_1][1]
* content/posts/images/test_2.PNG を用意する。
    * ![test_2][2]

##### ディレクトリ構成
```directory
├── content
│   ├── posts
│   |    ├── test.md 
│   │    └── images
│   │         └── test_2.PNG
│   ├── images
│   │    └── test_1.PNG
```
### 相対パスで指定する（github pagesで表示できない）

#### マークダウン記載方法
```markdown:test.md
![test_1](/././images/test_1.PNG)
![test_2](images/test_2.PNG)
```
◆結果

ローカルでは表示できるが、github pagesでは表示できない。

### URLで指定する

環境に合わせて、<ユーザ名>、<リポジトリ名>と<content以下のイメージファイルまでのパス>をかきかえてください。

```markdown
![test](https://<ユーザ名>.github.io/<リポジトリ名>/<content以下のイメージファイルまでのパス>)
```
ブラウザで画像を見ることができるか確認する。<br>
[https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG](https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG)


例) test.md
```markdown:test.md
![test](https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG)
```
[https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG](https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG)

◆結果

![test](https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG)

github pagesでも上記画像を表示することができた。


[1]: https://ancient-blog.github.io/hugo.github.io/images/test_1.PNG
[2]: https://ancient-blog.github.io/hugo.github.io/posts/images/test_2.PNG