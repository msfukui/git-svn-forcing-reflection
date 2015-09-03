#!/bin/csh -f

if ($1 == "" || $2 == "" || $3 == "" || $4 == "") then
  echo "argument error: $ $0 [git-repository] [git-branch-name] [svn-repository] [svn-branch-name]"
  exit 1
endif

set gitrepo   = "$1"
set gitbranch = "$2"
set svnrepo   = "$3"
set svnbranch = "$4"

set prev_git_commit_file = ".reflection-prev_git_commit"
set prev_git_commit      = `cat $prev_git_commit_file`
set comment = ".reflection-comment"

set diff_file = ".reflection-diff_file"

mkdir temp
cd temp

git clone -b $gitbranch $gitrepo git

svn checkout $svnrepo/$svnbranch svn

diff -q -r --exclude=.git --exclude=.svn svn git >! ../$diff_file

# 比較とコピー、svn 側のコミット処理を書く。
# 前提条件: 実行時ディレクトリに書き込み権があること。

echo "Reflected the contents of [$gitrepo] on [$svnrepo], OK."
