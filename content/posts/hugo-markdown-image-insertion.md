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

#### テスト画像

テスト用の画像を2個用意して、検証する。test.md
* content/posts/images/test_1.PNG を用意する。
    * ![test_1][1]
* content/images/test_2.PNG
    * ![test_2][2]
    
##### ディレクトリ構成
```
├── content
│   ├── posts
│   |    ├── test.md 
│   │    └── images
│   │         └── test_1.PNG
│   ├── images
│   │    └── test_2.PNG
```

#### Images - 画像埋め込み

* 
```markdown

![test](https://<ユーザ名>.github.io/<リポジトリ名>/images/<イメージファイル名>)
```

[1]: https://ancient-blog.github.io/hugo.github.io/post/images/test_1.PNG
[2]: https://ancient-blog.github.io/hugo.github.io/images/test_2.PNG