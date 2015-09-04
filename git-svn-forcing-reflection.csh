#!/bin/csh -f

#
# # 利用可能な前提条件
#
# * 実行時ディレクトリに書き込み権があること。
# * git, svn, awk, diff が使えること。
#

if ($1 == "" || $2 == "" || $3 == "" || $4 == "") then
  echo "argument error: $ $0 [git-repository] [git-branch-name] [svn-repository] [svn-branch-name]"
  exit 1
endif

setenv LANG C

set gitrepo   = "$1"
set gitbranch = "$2"
set svnrepo   = "$3"
set svnbranch = "$4"

set tempdir = "temp.$$"

set prev_git_commit_file = ".reflection-prev_git_commit"
set prev_git_commit      = `cat $prev_git_commit_file`
set comment = ".reflection-comment"

set diff_file = ".reflection-diff_file"

mkdir $tempdir
cd $tempdir

git clone -b $gitbranch $gitrepo git
svn checkout $svnrepo/$svnbranch svn

#
# list differ repository to svn and git.
#
diff -q -r --exclude=.git --exclude=.svn svn git >! $diff_file

#
# create operating files command.
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
$diff_file

#
# create operating svn-repository command.
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
$diff_file

cd ..
rm -fr $tempdir

echo "Reflected the contents of [$gitrepo] on [$svnrepo], OK."
