#!/bin/bash
changed_files=$(git log --stat -1 --pretty=format:"" | grep -o -E 'content/voicevox/[^/]+\.txt')
echo "変更されたファイル:"
echo "$changed_files"

for filename in $changed_files
do


    # jsonファイルの作成
    curl -s \
        -X POST \
        "localhost:50021/audio_query?speaker=3" \
        --get --data-urlencode text@"$filename" \
        -o query.json

    echo "Created query.json for $filename"
    
    cat query.json | grep -o -E "\"kana\":\".*\"" | xargs -I {} echo {}
    
    # wavファイルの作成
    curl -s \
        -H "Content-Type: application/json" \
        -X POST \
        -d @query.json \
        "localhost:50021/synthesis?speaker=3" \
        -o audio.wav

    echo "Created audio.wav for $filename"
    
    rm query.json

    # 拡張子.txtを削除して新しい変数に格納
    filename_without_extension=$(echo "$filename" | sed 's/\.txt$//')

    # wavファイルのリネーム
    mv audio.wav "${filename_without_extension}.wav"

    echo "Renamed audio.wav to ${filename_without_extension}.wav"

    echo "Finished processing $filename"
    
done

