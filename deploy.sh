bash build.sh
hugo
git add -A
git commit -m "Publishing build to cloudflare"
git push origin master
