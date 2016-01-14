#!/usr/bin/env bash

echo -e "Installing git branches"
git config --global branch.support-preview.merge refs/heads/support-preview
git config --global branch.support-preview.remote origin
git config --global branch.support-preview.rebase true
git config --global branch.support-preview.autosetupmerge false

git config --global branch.feature-preview.merge refs/heads/feature-preview
git config --global branch.feature-preview.remote origin
git config --global branch.feature-preview.rebase true
git config --global branch.feature-preview.autosetupmerge false

git config --global branch.project-preview.merge refs/heads/project-preview
git config --global branch.project-preview.remote origin
git config --global branch.project-preview.rebase true
git config --global branch.project-preview.autosetupmerge false

git config --global branch.start.merge refs/heads/live
git config --global branch.start.remote origin
git config --global branch.start.rebase true
git config --global branch.start.autosetupmerge false

git config --global branch.live.remote origin
git config --global branch.live.merge refs/heads/live
git config --global branch.live.rebase true
git config --global branch.live.autosetupmerge false

git config --global branch.preview.merge refs/heads/preview
git config --global branch.preview.remote origin
git config --global branch.preview.rebase true
git config --global branch.preview.autosetupmerge false

git config --global branch.release.remote origin
git config --global branch.release.merge refs/heads/release
git config --global branch.release.rebase true
git config --global branch.release.autosetupmerge false

echo -e "Installing git basic settings"
git config --global branch.autosetuprebase remote
git config --global branch.autosetupmerge true
git config --global merge.log true
git config --global merge.ff false

git config --global push.default current

git config --global init.templatedir ~/.git_template

git config --global core.excludesfile ~/.gitignore_global
git config --global core.attributesfile ~/.gitattributes
git config --global core.editor vim
git config --global core.eol lf
git config --global core.ignorecase false

git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global color.ui auto
git config --global color.grep always

git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch

echo -e "Downloading binaries"
git archive --format tar --remote=git://git.foo.com/project.git HEAD:path/to/directory filename | tar -x

wget https://raw.githubusercontent.com/itnova/git-extensions/master/bin/git-preview -O git-preview -q || exit $?
mv -f git-preview /usr/local/bin/git-preview || exit $?
chmod 777 /usr/local/bin/git-preview || exit $?

echo -e "You can now use\n- git support\n"
echo -e "Done"