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
git config --global alias.br branch

git config --global alias.notinlive 'branch -r --no-merged origin/live'
git config --global alias.notinrelease 'branch -r --no-merged origin/release'
git config --global alias.inlive 'branch -r --merged origin/live'
git config --global alias.inrelease 'branch -r --merged origin/release'

git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"

git config --global alias.new '!sh -c "git checkout start && git pull --rebase origin live && git checkout -b $1"'

git config --global alias.oneline '!_() { $(test $# -eq 0 && echo xargs -L1) git log --no-walk --decorate --oneline "$@"; }; _'
git config --global alias.tips '!_() { t=$(git rev-list --no-merges --max-count=1 "$@"); if test -n "$t"; then echo $t; _ "$@" ^$t; fi; }; _'
git config --global alias.view '!git tips origin/preview ^origin/live | git oneline'
git config --global alias.rebuild-preview '!git checkout preview && git reset --hard origin/live && git merge --no-ff `git tips origin/preview ^origin/live | tr "\n" " "`'

git config --global alias.release '!sh -c "git checkout release && git pull && git merge origin/$@ && git push"'
git config --global alias.hotfix '!sh -c "git push origin $@ && git checkout live && git pull && git merge origin/$@ && git push"'
git config --global --unset alias.preview

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
