+++
title = "Hugo + PlantUML + GitHub/Actionsで画像に変更して表示する"
date = 2023-08-27T13:30:39+09:00
tags = ["hugo","github","actions","plantuml"]
draft = false
toc = false
backtotop = false
+++

# Hugo + PlantUML + GitHub/ActionsでPlantUML画像を表示する

<!-- toc -->

## はじめに

1. **Hugoのワークフロー（hugo.yml）内でPlantUMLワークフローを呼び出す**:<br>
    Hugoのワークフロー内で、PlantUMLを画像に変換し、成果物を生成するPlantUMLワークフロー（plantuml.yml）を呼び出します。これにより、PlantUMLの実行と成果物の生成がトリガーされます。
1. **PlantUMLワークフロー（plantuml.yml）の実行**:<br>
    PlantUMLワークフロー内で、PlantUMLコードを画像に変換し、生成された画像を成果物としてアップロードします。PlantUMLワークフロー内で実行するステップは次のようになります：
    * PlantUMLコードを画像に変換
    * 生成された画像を成果物として保存
1. **Hugoワークフローで成果物をダウンロード**:<br>
    Hugoのワークフロー内で、PlantUMLワークフローで生成された成果物をダウンロードします。GitHub Actionsの仕様により、同じワークフロー内で生成された成果物は他のステップから利用できます。
1. **アップロードされた成果物の活用**:<br>
    ダウンロードした成果物は、Hugoを使用して構築されたウェブサイトのコンテンツとして活用できます。生成されたPlantUMLの画像は、ウェブページ上に表示されたり、ドキュメントとして利用される可能性があります。

これにより、GitHub Actionsを介してPlantUMLを使用して画像を生成し、それをウェブサイトの成果物として活用する一連の手順が実現されます。

### ディレクトリ構成
```directory
├── content
│   ├── posts
│   |    └── plantuml
│   │         ├── test.puml
│   │         └── test.png ①test.pumlから画像に変換(plantuml.yml)
│   └── images
│         └── plantuml
│             └── test.png ③成果物をダウンロード(hugo.yml)
├── artifact
│   └── test.png ②成果物として保存(plantuml.yml)
```

### ワークフロー図

![GitHub_Actions_PlantUML_Workflow](https://ancient-blog.github.io/hugo.github.io/images/plantuml/GitHub_Actions_PlantUML_Workflow.png)

## 手順

1. **plantuml.yml作成**:
    * PlantUMLの画像を生成しアップロードするためのワークフローファイル（例: .github/workflows/plantuml.yml）を作成します。

```yaml:plantuml.yml
name: PlantUML to Image and Artifact

on:
  workflow_call:

env:
  PLANT_UML_PATH: content/plantuml
  IMGES_PATH: content/images
  ARTIFACT: artifact

# Default to bash
defaults:
  run:
    shell: bash

jobs:

  # Generate plantuml diagrams job
  generate_puml_diagrams:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Generate PlantUML Diagrams
        uses: holowinski/plantuml-github-action@main
        with:
          args: -v -tpng  ${PLANT_UML_PATH}/*.puml
      - name: Create Destination Folder
        run: mkdir -p ${ARTIFACT}  # フォルダを作成  
      - name: Copy Files
        run: cp ${PLANT_UML_PATH}/*.png ${ARTIFACT}/  # ファイルをコピー
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: plant-uml-image
          path: |
            ${{ github.workspace }}/artifact
          if-no-files-found: error # 'warn' or 'ignore' are also available, defaults to `warn`
```

* 上記のワークフローファイルは、holowinski/plantuml-github-action@mainアクションを使用してPlantUMLを画像に変換し、contents/plantuml/ ディレクトリに生成された画像をartifact/にコピーして保存します。その後、actions/upload-artifact@v2 アクションを使用して artifact/ ディレクトリ内の成果物をアップロードします。

2. **hugo.ymlの設定**:
    * Hugoビルド用のワークフローファイル（例: .github/workflows/hugo.yml）にplantuml.ymlを呼び出し、artifactをダウンロードする処理を追加します。

```diff_yaml:hugo.yml
jobs:
+  # Generate images job
+  generate-images:
+    uses: ./.github/workflows/plantuml.yml
  # Build job
  build:
    runs-on: ubuntu-latest
+    needs: generate-images


      - name: Checkout
        uses: actions/checkout@v3
        with:
          submodules: recursive
+      - name: Download artifact
+        uses: actions/download-artifact@v3
+        with:
+          path: ${{ github.workspace }}/content/images/plantuml/
+          name: plant-uml-image 
```

* 上記ワークフローは、Hugoビルドワークフローに追加します。
actions/download-artifact@v3アクションを使用して/content/images/plantuml/に成果物をダウンロードします。
* Hugoサイトのコンテンツディレクトリ内に、アップロードされた画像を表示するためのコードを含む記事ファイルを作成します。
