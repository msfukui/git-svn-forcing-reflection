#!/bin/csh -f

#
# setup svn repository sample.
#
cd repository/svn
svnadmin create svn-repo
make start

svn checkout --username=svn-repo --password=svn-repo svn://localhost svn-repo-sample
cd svn-repo-sample
mkdir trunk
svn add trunk
svn commit --username=svn-repo --password=svn-repo -m "svn の初回コミット。（trunk 作成）"
svn update --username=svn-repo --password=svn-repo
cd ..
rm -fr svn-repo-sample

svn checkout --username=svn-repo --password=svn-repo svn://localhost/trunk svn-repo-sample
cd svn-repo-sample
cp -pr ../../../data/svn/* .
svn add *
svn commit --username=svn-repo --password=svn-repo -m "svn の二回目コミット。（trunk にテストファイルを追加。）"
svn update --username=svn-repo --password=svn-repo
cd ..

cd ../..

#
# setup git repository sample.
#
cd repository/git
git init --bare git-repo.git

git init git-repo-sample
cd git-repo-sample
git remote add origin ../git-repo.git
cp -pr ../../../data/git/* .
git add .
git commit -m "git の初回コミット。（master にテストファイルを追加。）"
git push -u origin master
cd ..

cd ../..
