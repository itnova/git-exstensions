#!/usr/bin/env bash

declare -r output_file="$(mktemp -t git-extensions)" || exit $?
declare -r scratch="$(mktemp -d -t git-extensions)" || exit $?
declare -r pwd=`pwd` || exit $?

declare -r ignore='.gitignore_global'
declare -r attributes='.gitattributes'
declare -r template='.git_template'

function cleanup {
    rm -rf ${scratch}
    rm -rf ${output_file}
}

trap cleanup EXIT

wget https://github.com/itnova/git-extensions/archive/master.zip -O "$output_file" -q || exit $?
unzip -qq -d ${scratch} ${output_file} || exit $?
rm "$output_file" || exit $?

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

echo -e "Installing binaries"
mkdir -p ~/.git_template/hooks/ || exit $?
cp -f ${scratch}/git-extensions-master/home/.git_template/hooks/prepare-commit-msg ~/${template}/hooks || exit $?
chmod 777 ~/${template}/hooks/prepare-commit-msg || exit $?
git config --global init.templatedir ~/${template}
echo -e "  ~/$template/hooks/prepare-commit-msg"

cp -f ${scratch}/git-extensions-master/home/${attributes} ~/${attributes} || exit $?
git config --global core.attributesfile ~/${attributes}
echo -e "  ~/$attributes"

cp -f ${scratch}/git-extensions-master/home/${ignore} ~/${ignore} || exit $?
git config --global core.excludesfile ~/${ignore}
echo -e "  ~/$ignore"

cp -f ${scratch}/git-extensions-master/bin/git-preview /usr/local/bin/git-preview || exit $?
chmod 777 /usr/local/bin/git-preview || exit $?
echo -e "  git preview"


cleanup || exit $?

echo -e "
You can now use
- git preview support
- git preview feature
- git preview project

Run \`git init\` in every project to use the newest config and triggers"