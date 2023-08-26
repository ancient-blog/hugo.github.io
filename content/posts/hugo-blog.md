+++
title = "HugoとGitHub ActionsでGitHub Pagesを自動デプロイ"
date = 2023-08-25T14:39:32+09:00
tags = ["hugo.github"]
draft = false
toc = true
backtotop = false
+++

# Title

HugoとGitHub ActionsでGitHub Pagesを自動デプロイする。
GitHub Pagesを使用するには、Hugoでビルドした成果物をPushする必要があったが
github actions betaでは、リポジトリにPushする必要がなくなった。


<!-- toc -->

## Contents

### 手順

1. Githubにログイン
1. GitHubのRepositoriesを選択する
1. [Settings]-[Pages]-[Build and deployment]
1. github actions betaを選択する。<br>![actions-beta][1]
1. Hugoのworkflowの[Configure]を選択する<br>![hugo-workflow][2]
1. Workflowの内容を確認して[Commit changes...]をクリックする


### Hugo Wrokflowが表示されない場合
1. 上記手順で、推奨WorkflowにHugoが表示されない場合<br>![suggested-workflow][3]
1. [Use a suggested workflow, browse all workflows, or create your own. ]の[browse all workflows]をクリック
1. [Search workflows]にHugoを入力する
1. 表示されたHugo Workflowの[Configure]を選択する


#### Hugo Wrokflowテンプレート

```yml:hugo.yml
# Sample workflow for building and deploying a Hugo site to GitHub Pages
name: Deploy Hugo site to Pages

on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["main"] #mainブランチにPushした契機で動作する

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

# Sets permissions of the GITHUB_TOKEN to allow deployment to GitHub Pages
permissions:
  contents: read
  pages: write
  id-token: write

# Allow only one concurrent deployment, skipping runs queued between the run in-progress and latest queued.
# However, do NOT cancel in-progress runs as we want to allow these production deployments to complete.
concurrency:
  group: "pages"
  cancel-in-progress: false

# Default to bash
defaults:
  run:
    shell: bash

jobs:
  # Build job
  build:
    runs-on: ubuntu-latest # ubuntu最新のDockerイメージを使用する
    env:
      HUGO_VERSION: 0.114.0
    steps:
      - name: Install Hugo CLI #Hugoをインストールする
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb
      - name: Install Dart Sass
        run: sudo snap install dart-sass
      - name: Checkout #チェックアウト
        uses: actions/checkout@v3
        with:
          submodules: recursive #submoduleで管理しているリポジトリ(themes)をCloneする
      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v3
      - name: Install Node.js dependencies
        run: "[[ -f package-lock.json || -f npm-shrinkwrap.json ]] && npm ci || true"
      - name: Build with Hugo #Hugoをビルドする
        env:
          # For maximum backward compatibility with Hugo modules
          HUGO_ENVIRONMENT: production
          HUGO_ENV: production
        run: |
          hugo \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/" #ビルド
      - name: Upload artifact #成果物をUploadする
        uses: actions/upload-pages-artifact@v2
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest # ubuntu最新のDockerイメージを使用する
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```


|ジョブ名|ステップ名|説明|
|:------|:-----|:------|
|build   |Install Hugo CLI   | HugoのWebサイトからv0.114.0をダウンロードしてインストールする  |
|   |Install Dart Sass      |Dart Sassのインストール。Sassとは、Webページのレイアウトや修飾情報の指定に用いられるCSS（Cascading Style Sheet）を生成するための言語（メタ言語）の一つです。      |
|   |Checkout|actions/checkout@v3アクションを利用してリポジトリをチェックアウトします。サブモジュールも含むオプションを指定しています|
|   |Setup Pages      |actions/configure-pages@v3アクションを利用してpagesの設定が行われます。|
|   |Install Node.js dependencies      |Node.jsの依存関係をインストールします      |
|   |Build with Hugo      |Hugoをビルドします      |
|   |Upload artifact      |actions/upload-pages-artifact@v2アクションを利用して成果物をUploadするように設定されています。このアクションは、ビルドされたウェブぺージや制的なコンテンツをアーティファクトとしてプうロードするために使用します。      |
|deploy   |Deploy to GitHub Pages   |actions/deploy-pages@v2アクションを利用してデプロイが行われるように設定されています。 GitHub Pagesに自動的にデプロイするために使用します。     |


[1]: https://ancient-blog.github.io/hugo.github.io/images/github-actions-beta.PNG
[2]: https://ancient-blog.github.io/hugo.github.io/images/github-hugo-workflow.PNG
[3]: https://ancient-blog.github.io/hugo.github.io/images/github-use-a-suggested-workflow.PNG