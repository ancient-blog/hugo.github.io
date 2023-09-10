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

    # wavファイルの作成
    curl -s \
        -H "Content-Type: application/json" \
        -X POST \
        -d @query.json \
        "localhost:50021/synthesis?speaker=1" \
        > audio.wav

    echo "Created audio.wav for $filename"

    # wavファイルのリネーム
    mv audio.wav "${filename.replace(".txt", "")}.wav"

    echo "Renamed audio.wav to ${filename.replace(".txt", "")}.wav"

    echo "Finished processing $filename"
done
