#!/bin/bash

for filename in ./content/voicevox/*.txt
do
    # ファイルが変更されたかどうかを確認
    if git diff --quiet --exit-code "$filename"; then
        echo "No changes in $filename, skipping..."
    else
        echo "Processing $filename..."

        # jsonファイルの作成
        curl -s \
            -X POST \
            "localhost:50021/audio_query?speaker=1" \
            --get --data-urlencode text@"$filename" \
            > query.json

        echo "Created query.json for $filename"

        # wavファイルの作成
        curl -s \
            -H "Content-Type: application/json" \
            -X POST \
            -d @query.json \
            "localhost:50021/synthesis?speaker=1" \
            > audio.wav

        echo "Created audio.wav for $filename"

        # 拡張子.txtを削除して新しい変数に格納
        filename_without_extension=$(echo "$filename" | sed 's/\.txt$//')

        # wavファイルのリネーム
        mv audio.wav "${filename_without_extension}.wav"

        echo "Renamed audio.wav to ${filename_without_extension}.wav"

        echo "Finished processing $filename"
    fi
done

