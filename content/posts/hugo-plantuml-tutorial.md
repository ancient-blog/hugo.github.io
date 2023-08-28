+++
title = "Hugo + PlantUML + GitHub/Actionsで画像に変更して表示する"
date = 2023-08-27T13:30:39+09:00
tags = ["hugo","github","actions","plantuml"]
draft = false
toc = false
backtotop = false
+++

# Title



<!-- toc -->

## Contents
GitHub Actionsを使用してPlantUMLを画像に変換し、生成された成果物をアップロードするための手順を示します。

1. GitHub Actionsワークフローファイルの設定:
    * GitHub Actionsを使用してPlantUMLの画像を生成するためのワークフローファイル（例: .github/workflows/plantuml.yml）を作成します。以下はワークフローファイルの例です。`content`以下の*.pumlを`public/images/plantuml`に*.pngに変換して出力する。

```yaml:plantuml.yml
jobs:
  # Build job
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.114.0
      PLANTUML_VERSION: 1.2023.10
    steps:
      # [省略]Hugoのインストール設定など
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'adopt'
          java-version: '17' 
      # [省略]チェックアウト+Hugoのビルド
      - name: Download PlantUML JAR
        run: |
          wget -O ${{ runner.temp }}/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml.jar           
      - name: Generate PlantUML Diagrams
        run: |
          java -jar ${{ runner.temp }}/plantuml.jar -o ./public/images/plantuml/ content/**/*.puml
        working-directory: ${{ github.workspace }}
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v2
        with:
          path: ./public

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

上記のワークフローファイルは、PlantUMLを画像に変換し、diagrams/ ディレクトリに生成された画像を保存します。その後、actions/upload-artifact@v2 アクションを使用して diagrams/ ディレクトリ内の成果物をアップロードします。

2. Hugoサイトの設定:
    * Hugoサイトのコンテンツディレクトリ内に、アップロードされた画像を表示するためのコードを含む記事ファイルを作成します。。
1. PlantUMLの画像をHugoで表示:
    * HugoのコンテンツフォルダにPlantUMLの画像を配置し、Hugoのテンプレートを使用して画像を表示します。生成された画像はアップロードされた成果物から取得できるようになります。<br><br>
    この設定に従うことで、GitHub Actionsを使用してPlantUMLを画像に変換し、生成された画像をHugoサイトで表示し、アップロードされた成果物としても利用することができます。再度注意しますが、具体的なファイルパスやディレクトリ構造はプロジェクトの要件に合わせて調整してください。
