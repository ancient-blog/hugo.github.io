+++
title = "Github/actions カスタムワークフローを再利用できる便利な方法"
date = 2023-09-27T22:11:31+09:00
tags = ["github", "actions", "composit"]
draft = false
toc = false
backtotop = false
+++

#  "GitHub Actionsでコンポジットアクションを作成する手順"

<!-- toc -->

## Contents

この記事では、GitHub Actionsを使用してコンポジットアクションを作成するステップバイステップの手順を紹介します。コンポジットアクションは、複数のステップからなるカスタムワークフローを簡単に再利用できる便利な方法です。記事では、具体的な例として、名前とパーソナルアクセストークンを受け取り、ファイルリストを表示するシンプルなコンポジットアクションを作成します。さらに、GitHub Actionsの基本的なコンセプトや構造についても説明します。GitHubユーザー向けに役立つカスタムワークフローの作成方法を学びましょう。

## 目次

- [ディレクトリ構成](#ディレクトリ構成)
- [action.yml](#actionyml)
- [test.yml](#testyml)

### ディレクトリ構成

| ディレクトリ/ファイル   | 説明                |
|--------------------------|---------------------|
| .github/workflows/       | GitHub Actionsのワークフロー設定ファイルを格納するディレクトリ |
| └── test/                | ワークフロー用のディレクトリ |
|     └── action.yml       | コンポジットアクションの設定ファイル ファイル名をaction.ymlにする必要があります。|
| test.yml                 | ワークフローの設定ファイル |

### action.yml

``` yaml:action.yml
# ここにaction.ymlのコードを挿入
name: "Composite Action"
description: "[Test] Composite Action"

inputs:
  MY_MESSAGE:
    description: "表示したいメッセージ"
    required: true
  YOUR_PAT:
    description: 'A personal access token from the caller workflow'
    required: true

runs:
  using: "composite"
  steps:
    # ディレクトリ内のファイルを表示するステップを追加
    - name: List Files
      shell: bash
      run: |
        ls -lh
        echo "${{ inputs.MY_MESSAGE }}"
        echo "${{ inputs.YOUR_PAT}}"
```

| フィールド                | 説明                               |
|--------------------------|------------------------------------|
| name                     | "Composite Action"                 |
| description              | "[Test] Composite Action"          |
| inputs.MY_MESSAGE        | 表示したいメッセージ              |
| inputs.YOUR_PAT          | ワークフローから受け取る個人用アクセストークン（Personal Access Token） |
| runs.using               | "composite"                        |
| runs.steps               | コンポジットアクションのステップ |
| runs.steps.shell         | bashを設定する。忘れやすいので注意 |

### test.yml

カスタムワークフローを再利用する。

``` yaml:test.yml
# ここにtest.ymlのコードを挿入
on:
  # Runs on pushes targeting the default branch
  push:
    branches: ["main"]

jobs:

  composite_test:
    runs-on: ubuntu-latest
    steps:
      - name: checkout
        uses: actions/checkout@v4
      - name: test
        uses: ./.github/workflows/test
        with:
          MY_MESSAGE: "テスト"
          YOUR_PAT: "${{ secrets.TOKEN }}"
```

| フィールド                  | 説明                              |
|--------------------------|-----------------------------------|
| on.push.branches          | ワークフローがトリガーされる条件  |
| jobs.composite_test       | ワークフローのジョブ              |
| runs-on                  | ジョブが実行される環境           |
| steps                    | ジョブ内のステップ                |
| uses                     | アクションを使用する設定          |
| with.MY_MESSAGE          | アクションの入力パラメータ        |
| with.YOUR_PAT            | アクションの入力パラメータ        |

