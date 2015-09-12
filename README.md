# git-svn-overwrite

## What's this?

git の特定の branch のコードセットを subversion の特定の branch に強制的に上書きして commit するための簡易なスクリプトです。

svn から git ベースにコード・レポジトリの移行を進めるにあたって、git 側で更新した内容を svn 側に常に最新の情報を反映しておきたいニーズがあって作りました。

移行期間中は svn は更新せずに常に git のみを使う、という前提で、常に git 側の情報で svn の内容を上書きします。

最初は git-svn をうまく使うことを考えたのですが、merge の際の conflict の解消が厳しかったので、個別にスクリプトを作りました。

かなり筋悪な対応だと思います。もっと良い方法があればぜひご指摘いただけると嬉しいです。

## Requirement

* スクリプトは csh, awk, diff で記述しているため、実行時にはそれぞれ必要になります。

* 内部で git, svn を使用しているため、それぞれ事前のセットアップが必要です。

* 実行時ディレクトリ配下に作業ディレクトリを作成するため、実行時ディレクトリには書き込み権限が必要です。

## Note

* 前回の commit ログからの差分を元に svn の commit メッセージを生成するため、__初回実行時__には、前回の commit の SHA-1 ハッシュ値を、指定したファイルに書き込んでおく必要があります。次回以降は、指定したファイルに、そのまま前回分が上書きされますので、以後の作成は不要です。

* svn →git への初期移行直後の SHA-1 ハッシュ値の保存用にsave-commit-hash コマンドを使うことができます。git レポジトリの位置と branch 、保存先のファイル名を指定すると、その最新の commit の SHA-1 ハッシュ値を 指定したファイルに保存します。

* commit の SHA-1 ハッシュ値の保存先の既定値は、実行時ディレクトリ直下の .orerwrite-prev\_git\_commit としています。

* svn の commit ログは、実行環境に設定されている Subversion の ID に紐付いている author を使って書き込みます。このため使用にあたっては svn のログは捨てる覚悟でお願いします。

## Usage

### Preparation

```sh
$ mkdir bin; cd bin
$ wget https://raw.githubusercontent.com/msfukui/git-svn-overwrite/master/git-svn-overwrite
$ wget https://raw.githubusercontent.com/msfukui/git-svn-overwrite/master/save-commit-hash
$ chmod 750 git-svn-overwrite save-commit-hash
$ cd ..
$ ./bin/save-commit-hash git@github.com:msfukui/git-repo-sample.git master
Git-repository: [git@github.com:msfukui/git-repo-sample.git/master]

Created [.overwrite-prev_git_commit].
Saved commit SHA-1 hash value [16b67fa41447a5b6b882dd867f795bea20b560e7].
Save, OK.
$
```

### Overwrite

#### dry running

```sh
$ ./bin/git-svn-overwrite --dry-run --commit-hash-file commit-hash-file.txt git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
Dry running...
Git-repository: [git@github.com:msfukui/git-repo-sample.git/master]
Svn-repository: [svn://localhost/trunk]

Created [commit-hash-file.txt].
Saved commit SHA-1 hash value: [017220003bf740d23d750755543e712d821bffa9]
Svn commit message: [
...
]
Overwrite, OK.
```

#### commit

```sh
$ ./bin/git-svn-overwrite --commit-hash-file commit-hash-file.txt git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
Git-repository: [git@github.com:msfukui/git-repo-sample.git/master]
Svn-repository: [svn://localhost/trunk]

Created [commit-hash-file.txt].
Saved commit SHA-1 hash value: [017220003bf740d23d750755543e712d821bffa9]
Svn commit message: [
...
]
Overwrite, OK.
```

## License

本プログラムの提供ライセンスは MIT License です。

詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
