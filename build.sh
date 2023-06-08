cd "$(dirname "$0")"
git submodule sync
git submodule update --init --recursive
cd phasewalk1.me
trunk build
cd ..
cp phasewalk1.me/dist/index.html content/card/index.html
cp phasewalk1.me/dist/*.js static/scripts/
cp phasewalk1.me/dist/*.wasm static/wasm/

__artifacts_then_clean__() {
    local directory=$1
    local extension=$2

    readarray -t files < <(find "$directory" -maxdepth 1 -name "*.${extension}" -type f -printf '%T@ %P\n' | sort -nr)

    if [ ${#files[@]} -gt 0 ]; then
        most_recent_file=$(echo "${files[0]}" | cut -d' ' -f 2-)
        echo "$most_recent_file"
    else
        echo "No files found."
        return
    fi

    for (( i = 1; i < ${#files[@]}; i++ )); do
        file_to_delete=$(echo "${files[$i]}" | cut -d' ' -f 2-)
        rm "${directory}/${file_to_delete}"
    done
}

exact_js=$( __artifacts_then_clean__ "static/scripts" "js")
exact_wasm=$( __artifacts_then_clean__ "static/wasm" "wasm")

__embed_artifacts__() {
    js=$1
    wasm=$2

    head="<!DOCTYPE html><html><head><meta charset='utf-8'><title>Card</title>"
    preload="<link rel='preload' href=\"/wasm/${wasm}\" as='fetch' type='application/wasm' crossorigin=''>"
    modulepreload="<link rel='modulepreload' href=\"/scripts/${js}\"></head><body>"
    scrip="<script type='module'>import init from \"/scripts/${js}\";init(\"/wasm/${wasm}\");</script>"
    closing="</body></html>"

    echo "${head}${preload}${modulepreload}${scrip}${closing}"
}

CARD=$( __embed_artifacts__ "${exact_js}" "${exact_wasm}" )
echo "$CARD" > content/card/index.html