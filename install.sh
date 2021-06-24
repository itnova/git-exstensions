#!/usr/bin/env bash

declare -r output_file="$(mktemp -t git-extensions-XXXXX)" || exit $?
declare -r scratch="$(mktemp -d -t git-extensions-XXXXX)" || exit $?
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

echo -e "Installing git basic settings"
git config --global branch.autosetuprebase remote
git config --global branch.autosetupmerge true
git config --global merge.log true
git config --global merge.ff false

git config --global push.default current

git config --global core.editor vim
git config --global core.eol lf
git config --global core.ignorecase false
git config --global core.autocrlf input

git config --global color.diff auto
git config --global color.status auto
git config --global color.branch auto
git config --global color.interactive auto
git config --global color.ui auto
git config --global color.grep always

echo -e "Installing git aliases"
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.cop '!sh -c "git checkout $@ && git pull"'
git config --global alias.br branch
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git config --global alias.new '!sh -c "git cop ${2-production} && git checkout -b $1"'

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

cleanup || exit $?

echo -e "Run \`git init\` in every project to use the newest config and triggers"
