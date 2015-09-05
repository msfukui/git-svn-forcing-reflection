#!/bin/csh -f

if ($1 == "" || $2 == "") then
  echo "ERROR: Argument error."
  echo "ERROR: Usage: $ $0 git-repository git-branch-name"
  exit 1
endif

setenv LANG C

set gitrepo   = "$1"
set gitbranch = "$2"

set datetime = `date +"%Y%m%d%H%M%S"`
set tempdir = "temp.$datetime.$$"

set prev_git_commit_file = ".reflection-prev_git_commit"

mkdir $tempdir
cd $tempdir

git clone -b $gitbranch $gitrepo git

cd git
git log --pretty=format:"%H" HEAD^..HEAD | head -1 >! ../../$prev_git_commit_file
cd ..

cd ..
rm -fr $tempdir

set value = `cat $prev_git_commit_file`

echo ""
echo "git-repository: [$gitrepo/$gitbranch]"
echo "  Created [$prev_git_commit_file]."
echo "  Last commit SHA-1 hash value [$value]."
echo "OK."
