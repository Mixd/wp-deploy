rm -rf .git
git init
rm -rf wordpress
git submodule add git@github.com:WordPress/WordPress.git wordpress
git remote rm origin
git add -A
git commit -m "Inital commit"