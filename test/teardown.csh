#!/bin/csh -f

cd repository/svn
make stop
rm -f svnserve.log
rm -fr svn-repo svn-repo-sample
cd ../..

cd repository/git
rm -fr git-repo.git git-repo-sample
cd ../..
