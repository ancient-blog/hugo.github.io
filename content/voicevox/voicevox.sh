#!/bin/bash

for filename in $(ls ./content/voicevox/*.txt)
do

#jsonファイルの作成
curl -s \
    -X POST \
    "localhost:50021/audio_query?speaker=1"\
    --get --data-urlencode text@$filename \
    > query.json

#wavファイルの作成
curl -s \
    -H "Content-Type: application/json" \
    -X POST \
    -d @query.json \
    "localhost:50021/synthesis?speaker=1" \
    > audio.wav
    
#wavファイルのリネーム
mv audio.wav "${filename}.wav"

done