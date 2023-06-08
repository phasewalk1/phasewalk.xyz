cd "$(dirname "$0")"
cd phasewalk1.me
trunk build
cd ..
cp phasewalk1.me/dist/index.html content/card/index.html
cp phasewalk1.me/dist/*.js static/scripts/
cp phasewalk1.me/dist/*.wasm static/wasm/

exact_js=$(find static/scripts -maxdepth 1 -name '*.js' -type f -printf '%f\n')
exact_wasm=$(find static/wasm -maxdepth 1 -name '*.wasm' -type f -printf '%f\n')

# Open the content/card/index.html file and replace the script and wasm file paths
# with the exact file names

CARD="<!DOCTYPE html><html><head>
        <meta charset='utf-8'>
        <title>Card</title>
    
<link rel='preload' href='/wasm/$exact_wasm' as='fetch' type='application/wasm' crossorigin=''>
<link rel='modulepreload' href='/scripts/$exact_js'></head>
<body>
<script type='module'>import init from '/scripts/$exact_js';init('/wasm/$exact_wasm');</script></body></html>"

echo "$CARD" > content/card/index.html

