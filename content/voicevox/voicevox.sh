#!/bin/bash

for filename in ./content/voicevox/*.txt
do
    echo "Processing $filename..."

    # jsonファイルの作成
    curl -s \
        -X POST \
        "localhost:50021/audio_query?speaker=1" \
        --get --data-urlencode text@"$filename" \
        > query.json

    echo "Created query.json for $filename"

    # JSONファイルの内容を表示
    echo "JSON Response:"
    cat query.json

    # wavファイルの作成
    curl -s \
        -H "Content-Type: application/json" \
        -X POST \
        -d @query.json \
        "localhost:50021/synthesis?speaker=1" \
        > audio.wav

    echo "Created audio.wav for $filename"

    # 音声ファイルの作成結果を表示
    echo "Audio Response:"
    cat audio.wav

    # wavファイルのリネーム
    mv audio.wav "${filename}.wav"

    echo "Renamed audio.wav to ${filename}.wav"

    echo "Finished processing $filename"
done
