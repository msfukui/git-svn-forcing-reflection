#!/bin/csh -f

#
# # 利用可能な前提条件
#
# * 実行時ディレクトリに書き込み権があること。
#   ** 実行後に temp.* という作業ディレクトリとHEADのコミットSHA-1ハッシュ値を保存します。
# * git, svn, awk, diff が使えること。
#

if (($1 == "--dry-run" && ($2 == "" || $3 == "" || $4 == "" || $5 == "")) || \
    ($1 != "--dry-run" && ($1 == "" || $2 == "" || $3 == "" || $4 == "")) then
  echo "argument error: $ $0 [--dry-run] git-repository git-branch-name svn-repository svn-branch-name"
  exit 1
endif

setenv LANG C

if ($1 != "--dry-run") then
  set dry_run_mode = "off"
  set gitrepo   = "$1"
  set gitbranch = "$2"
  set svnrepo   = "$3"
  set svnbranch = "$4"
else
  set dry_run_mode = "on"
  set gitrepo   = "$2"
  set gitbranch = "$3"
  set svnrepo   = "$4"
  set svnbranch = "$5"
endif

set datetime = `date +"%Y%m%d%H%M%S"`
set tempdir = "temp.$datetime.$$"
set diff_file = ".reflection-diff_file"

set comment_file = ".reflection-comment"
set prev_git_commit_file = ".reflection-prev_git_commit"
touch $prev_git_commit_file
set prev_git_commit = `cat $prev_git_commit_file`

echo "dry-run-mode: $dry_run_mode"

mkdir $tempdir
cd $tempdir

git clone -b $gitbranch $gitrepo git
svn checkout $svnrepo/$svnbranch svn

#
# list differ repository to svn and git.
#
diff -q -r --exclude=.git --exclude=.svn svn git >! $diff_file

#
# create operating files command and execute.
#
awk '\
  /^Only in svn/ \
    { n = substr($3, 1, length($3)-1); \
      print "rm -fr", n "/" $4; } \
  /^Only in git/ \
    { p = substr($3, 1, length($3)-1); \
      n = "svn" substr(p, 4); \
      print "mv -f", p "/" $4, n "/"; } \
  /^Files .* differ$/ \
    { print "mv -f", $4 " " $2; }' \
$diff_file | csh -fx

#
# create operating svn-repository command and execute.
#
awk 'BEGIN{ print "cd svn" ;} \
  /^Only in svn/ \
    { if (length($3) <= 4) { \
        n = ""; \
      } else { \
        n = substr($3, 5, length($3)-5) "/"; \
      } \
      print "svn del", n $4; } \
  /^Only in git/ \
    { if (length($3) <= 4) { \
        n = ""; \
      } else { \
        n = substr($3, 5, length($3)-5) "/"; \
      } \
      print "svn add", n $4; }' \
$diff_file | csh -fx

#
# create commit logs and save current "HEAD" commit value.
#
cd git
git log --graph ^${prev_git_commit} HEAD >! ../$comment_file
if ($dry_run_mode == "off") then
  git log --pretty=format:"%H" HEAD^..HEAD >! ../../$prev_git_commit_file
else
  git log --pretty=format:"%H" HEAD^..HEAD >! ../$prev_git_commit_file
endif
cd ..

#
# commit svn-repository.
#
cd svn
if ($dry_run_mode == "off") then
  svn commit --file ../$comment_file
else
  svn commit --dry-run --file ../$comment_file
endif
cd ..

cd ..
if ($dry_run_mode == "off") then
  rm -fr $tempdir
else
endif

echo "Reflected the contents of [$gitrepo] on [$svnrepo], OK."
