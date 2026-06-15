git pull --rebase --autostash
git add --all
git commit -m "$(date)" || true  
git push
