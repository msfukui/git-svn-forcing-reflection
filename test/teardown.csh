#!/bin/csh -fe

echo "[test/teardown]: start."

cd repository/svn
make stop
rm -f svnserve.log
rm -fr svn-repo svn-repo-sample
cd ../..

cd repository/git
rm -fr git-repo.git git-repo-sample
cd ../..

if (-f .reflection-prev_git_commit) then
  rm -f .reflection-prev_git_commit
endif

#rm -fr temp.*.*

echo "[test/teardown]: end."
