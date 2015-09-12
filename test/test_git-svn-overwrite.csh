#!/bin/csh -f

if ($1 == "" ) then
  set test_debug = "off"
else if ($1 == "on") then
  set test_debug = "on"
else
  echo "ERROR: Argument error."
  echo "ERROR: Usage: $0 [on]"
  exit 1
endif

echo "[test/git-svn-overwrite]: start."

set test_datetime = `date +"%Y%m%d%H%M%S"`
echo "[test/dry-run]: start."
./setup.csh
../git-svn-overwrite --dry-run ../repository/git/git-repo.git master svn://localhost trunk
cd repository/git/git-repo-sample
git pull
cd ../../svn/svn-repo-sample
svn update
cd ../../..
diff -q -r --exclude=.git --exclude=.svn repository/git/git-repo-sample repository/svn/svn-repo-sample
if ($? == "0") then
  echo "Assertion Error."
  exit 2
endif
cd repository/svn/svn-repo-sample
svn update
svn log -l 1
cd ../../..
./teardown.csh
echo "[test/dry-run]: end."

set test_datetime = `date +"%Y%m%d%H%M%S"`
echo "[test/commit]: start."
./setup.csh
../git-svn-overwrite ../repository/git/git-repo.git master svn://localhost trunk
cd repository/git/git-repo-sample
git pull
cd ../../svn/svn-repo-sample
svn update
cd ../../..
diff -q -r --exclude=.git --exclude=.svn repository/git/git-repo-sample repository/svn/svn-repo-sample
if ($? != "0") then
  echo "Assertion Error."
  exit 2
endif
cd repository/svn/svn-repo-sample
svn update
svn log -l 1
cd ../../..
./teardown.csh
echo "[test/commit]: end."

set test_datetime = `date +"%Y%m%d%H%M%S"`
echo "[test/commit_hash_file_commit]: start."
./setup.csh
../git-svn-overwrite --commit-hash-file ./.commit_hash_file ../repository/git/git-repo.git master svn://localhost trunk
cd repository/git/git-repo-sample
git pull
cd ../../svn/svn-repo-sample
svn update
cd ../../..
diff -q -r --exclude=.git --exclude=.svn repository/git/git-repo-sample repository/svn/svn-repo-sample
if ($? != "0") then
  echo "Assertion Error."
  exit 2
endif
cd repository/svn/svn-repo-sample
svn update
svn log -l 1
cd ../../..
cat ./.commit_hash_file
rm -f ./.commit_hash_file
./teardown.csh
echo "[test/commit_hash_file_commit]: end."

echo "[test/git-svn-overwrite]: end."
