#!/usr/bin/env bash

echo -e "Installing git branches"

git config --global branch.support-preview.merge refs/heads/support-preview
git config --global branch.support-preview.remote origin
git config --global branch.support-preview.rebase true
git config --global branch.feature-preview.merge refs/heads/feature-preview
git config --global branch.feature-preview.remote origin
git config --global branch.feature-preview.rebase true
git config --global branch.project-preview.merge refs/heads/project-preview
git config --global branch.project-preview.remote origin
git config --global branch.project-preview.rebase true

wget https://raw.githubusercontent.com/itnova/git-extensions/master/git-preview -O git-preview -quiet || exit $?
rm /usr/local/bin/git-preview || exit $?
mv git-preview /usr/local/bin/ || exit $?
chmod 777 /usr/local/bin/git-preview || exit $?

echo -e "You can now use\n- git support\n"
echo -e "Done"