rm -rf .git
git init
rm -rf wordpress
git submodule add git://core.git.wordpress.org/ wordpress
cd wordpress
git checkout $(git tag -l --sort -version:refname | head -n 1)
cd ..
git remote rm origin
git add -A
git commit -m "Inital commit"
