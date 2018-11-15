# Run this script the first time you clone from the wp-deploy repo
# It will be deleted and removed from your project once it has completed
rm -rf .git
git init
git submodule add git://core.git.wordpress.org/ wordpress
cd wordpress
git checkout $(git tag -l --sort -version:refname | head -n 1)
cd ..
rm config/prepare.sh
git add -A
git commit -m "Inital commit"
./setup.sh
