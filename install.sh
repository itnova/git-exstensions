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

wget "https://raw.githubusercontent.com/itnova/git-exstensions/master/git-preview?token=ABa46fJq10CEazHz3E1Rx-vb9pC8ki5Dks5WoPVBwA%3D%3D" -O git-preview || exit $?
cp git-preview /usr/local/bin/ || exit $?
chmod 777 /usr/local/bin/git-preview || exit $?

echo -e "You can now use\n- git support\n"
echo -e "Done"