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



echo -e "You can now use\ngit support"
echo -e "Done"