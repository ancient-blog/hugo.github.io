#!/bin/bash
git log -n 3
changed_files=$(git log --stat -1 --pretty=format:"" | grep -E '^\s+\w+\s+\|\s+(.*\.[a-zA-Z0-9]+)\s+\|')
echo "変更されたファイル:"
echo "$changed_files"

for filename in ./content/voicevox/*.txt
do


    # jsonファイルの作成
    curl -s \
        -X POST \
        "localhost:50021/audio_query?speaker=3" \
        --get --data-urlencode text@"$filename" \
        > query.json

    echo "Created query.json for $filename"
    
    cat query.json | grep -o -E "\"kana\":\".*\"" | xargs -I {} echo {}
    
    # wavファイルの作成
    curl -s \
        -H "Content-Type: application/json" \
        -X POST \
        -d @query.json \
        "localhost:50021/synthesis?speaker=3" \
        > audio.wav

    echo "Created audio.wav for $filename"
    
    rm query.json

    # 拡張子.txtを削除して新しい変数に格納
    filename_without_extension=$(echo "$filename" | sed 's/\.txt$//')

    # wavファイルのリネーム
    mv audio.wav "${filename_without_extension}.wav"

    echo "Renamed audio.wav to ${filename_without_extension}.wav"

    echo "Finished processing $filename"
    
done

