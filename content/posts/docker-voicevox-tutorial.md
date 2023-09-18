+++
title = "VOICEVOX（音声合成）+ docker + Github actionsで音声合成環境構築"
date = 2023-09-17T23:31:46+09:00
tags = ["docker","docker-compose","voicevox"]
draft = false
toc = false
backtotop = false
+++

# VOICEVOX（音声合成）+ docker + Github actionsで音声合成環境構築

<!-- toc -->

## はじめに

1. VOICEVOX（音声合成）の環境構築
    1. docker-compose.ymlの作成
    1. github actionsのworkflowからdocker imageを起動する
    1. VOICEVOXのdocker imageが起動するまで待つ方法
1. 音声合成を試してみる
    1. 変更したファイルだけ音声合成
    1. JSONファイル作成
    1. WAVファイル作成

以下で説明するGitlab actions のworkflowは[ここ](https://github.com/ancient-blog/hugo.github.io/blob/topic/%2317/.github/workflows/voicevosx.yml)を参照してください。


### ディレクトリ構成

```directory
├── content
│   ├── posts
│   |    └── docker-voicevox-tutorial.md
│   └── voicevox
│         │── test.txt (テキストファイル)
│         │── test1.txt (↑)
│         │── test2.txt (↑)
│         │── test.wav (音声ファイルをartifactからDownloadして配置する)
│         │── test1.wav (↑)
│         └── test2.wav (↑)
│             
├── artifact 
│   │── test.wav (合成した音声ファイルをartifactにUpload)
│   │── test1.wav (↑)
│   └── test2.wav (↑)
```

## VOICEVOX（音声合成）の環境構築

### docker-compose.ymlの作成

Github actionsではGUPを使えないので、CPU版を利用する。

``` yaml:docker-compose.yml
version: '3'
services:
  my-container-1:
    container_name: voicevox-cpu-latest
    image: voicevox/voicevox_engine:cpu-ubuntu20.04-latest
    ports:
      - 50021:50021
    networks:
      mynetwork:
        ipv4_address: 172.81.0.3 ※ voicevoxの起動確認の為に静的IPアドレスを指定する

networks:
  mynetwork:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 172.81.0.0/16
```

### github actionsのworkflowからdocker imageを起動する

1. 'docker-compose up -d --build' は、Docker Composeを使用して複数のコンテナからなるアプリケーションを起動し、そのアプリケーションのコンテナをビルドするためのコマンドです。
1. 'docker ps -a', 'docker-compose ps' は、Dockerコンテナの一覧を表示するコマンドです。
1. 'ping -c 3 172.81.0.3' は、ネットワーク通信のテストを行うためのコマンドです。具体的には、指定したIPアドレス（この場合、172.81.0.3）への通信性能を確認するために使用されます。

``` yaml
      - name: Docker Set Up
        run: |
          docker-compose up -d --build
          docker ps -a
          docker-compose ps
          ping -c 3 172.81.0.3
```

### VOICEVOXのdocker imageが起動するまで待つ方法

上記のPing処理を外すと下記のエラーが発生します。
ping応答を待つ処理にすることで、回避できました。より良い方法が別にあるかもしれません。

■エラー詳細

```
Error: Process completed with exit code 56.
```

エラーコード 56 は、通常、Curlがネットワーク関連の問題に遭遇したことを示しています。
ホストが正しく動作していることを確認する必要がある。


## 音声合成を試してみる

### 変更したファイルだけ音声合成

fetch-depth は、Gitリポジトリからコミットを取得する深さ（depth）を指定するための設定です。
ひとつ前の差分を取るために"2"を設定します。

``` yaml
      - name: Checkout
        uses: actions/checkout@v3
        with:
          fetch-depth: 2
```

content/voicevox/フォルダ内で差分のあるテキストファイルを音声合成処理します。

``` yaml
          changed_files=$(git log --stat -1 --pretty=format:"" | grep -o -E 'content/voicevox/[^/]+\.txt')

          for filename in $changed_files
          do
            # 音声合成処理
          done
```

### JSONファイル作成

``` yaml
            curl -s \
              -X POST \
              "localhost:50021/audio_query?speaker=3" \
              --get --data-urlencode text@"$filename" \
              -o query.json
```

### WAVファイル作成

``` yaml
            curl -s \
              -H "Content-Type: application/json" \
              -X POST \
              -d @query.json \
              "localhost:50021/synthesis?speaker=3" \
              -o audio.wav  
```

## 結果

### test.wav

{{< audio src="https://ancient-blog.github.io/hugo.github.io/voicevox/test.wav" >}}

### test1.wav

{{< audio src="https://ancient-blog.github.io/hugo.github.io/voicevox/test1.wav" >}}

### test2.wav

{{< audio src="https://ancient-blog.github.io/hugo.github.io/voicevox/test2.wav" >}}