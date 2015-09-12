# git-svn-overwrite

## What's this?

git の特定の branch のコードセットを subversion の特定の branch に強制的に上書きして commit するための簡易なスクリプトです。

svn から git ベースにコード・レポジトリの移行を進めるにあたって、git 側で更新した内容を svn 側に常に最新の情報を反映しておきたいニーズがあって作りました。

移行期間中は svn は更新せずに常に git のみを使う、という前提で、常に git 側の情報で svn の内容を上書きします。

最初は git-svn をうまく使うことを考えたのですが、merge の際の conflict の解消が厳しかったので、個別にスクリプトを作りました。

かなり筋悪な対応だと思います。もっと良い方法があればぜひご指摘いただけると嬉しいです。

## Requirement

* スクリプトは csh で書いているため、実行には csh が必要です。

* 内部で git, svn, diff, awk を使っているため、それぞれの事前のセットアップが必要です。

* 実行時ディレクトリ配下に作業ディレクトリを作成するため、実行時ディレクトリには書き込み権限が必要です。

## Note

* 前回の commit ログからの差分を元に svn の commit メッセージを生成するため、__初回実行時__には、前回の commit の SHA-1 ハッシュ値を、指定したファイル（既定値は実行時ディレクトリ直下の .overwrite-prev\_git\_commit です）に書き込んでおく必要があります。次回以降は、指定したファイルに、前回分が記録されますので、以後の作成は不要です。

* svn →git への初期移行直後の SHA-1 ハッシュ値の保存用に git-first.csh を使うことができます。git レポジトリの位置と branch を指定するとその最新の commit の SHA-1 ハッシュ値を 指定したファイル（既定値は実行時ディレクトリ直下の .orerwrite-prev\_git\_commit です）に保存します。

* svn の commit ログには author などの情報は反映しないことになるため、svn のログは捨てる覚悟でお願いします。

## Usage

### Preparation

```sh
$ mkdir bin; cd bin
$ wget https://raw.githubusercontent.com/msfukui/git-svn-overwrite/master/git-svn-overwrite
$ wget https://raw.githubusercontent.com/msfukui/git-svn-overwrite/master/git-commit-hash
$ chmod 750 git-svn-overwrite git-commit-hash
$ cd ..
$ ./bin/git-commit-hash git@github.com:msfukui/git-repo-sample.git master
Cloning into 'git'...
remote: Counting objects: 176, done.
remote: Total 176 (delta 0), reused 0 (delta 0), pack-reused 176
Receiving objects: 100% (176/176), 25.50 KiB | 0 bytes/s, done.
Resolving deltas: 100% (80/80), done.
Checking connectivity... done.

git-repository: [git@github.com:msfukui/git-repo-sample.git/master]
  Created [.overwrite-prev_git_commit].
  Last commit SHA-1 hash value [16b67fa41447a5b6b882dd867f795bea20b560e7].
OK.
$
```

### Overwrite

#### dry running

```sh
$ ./bin/git-svn-overwrite --dry-run --commit-hash-file commit-hash-file.txt git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
```

#### commit

```sh
$ ./bin/git-svn-overwrite --commit-hash-file commit-hash-file.txt git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
```

## License

本プログラムの提供ライセンスは MIT License です。

詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
