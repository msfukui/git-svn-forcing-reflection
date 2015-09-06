# git-svn-forcing-reflection

## What's this?

git の特定のブランチのコードセットを subversion の特定のブランチに強制的に上書きしてコミットするための簡易なスクリプトです。

svn から git ベースにコード・レポジトリの移行を進めるにあたって、git 側で更新した内容を svn 側にも常に最新の情報を反映しておきたいニーズがあって作りました。

移行期間中は svn は更新せずに常に git のみを使う、という前提で、常に git 側の情報で svn の内容を上書きします。

最初は git-svn をうまく使うことを考えたのですが、merge の際の conflict の解消が厳しかったので、個別にスクリプトを作りました。

自分でもかなり筋悪な対応だとは思います。もっと良い方法があればぜひご指摘いただけると嬉しいです。

## Requirement

* スクリプトは csh で書いているため、実行には csh が必要です。

* 内部で git, svn, diff, awk を使っているため、それぞれの事前のセットアップが必要です。

* 実行時ディレクトリ配下に作業ディレクトリを作成するため、実行時ディレクトリには書き込み権限が必要です。

## Note

* 前回のコミットログからの差分を元に svn の commit メッセージを生成するため、*初回実行時*には、前回の commit のSHA-1ハッシュ値を、実行時ディレクトリ直下の .reflection-prev\_git\_commit に書き込んでおく必要があります。（次回以降は .reflection-prev\_git\_commit に前回分が記録されますので以後の作成は不要です。）

* svn のコミットログには author などの情報は反映しないことになるため、svn のログは捨てる覚悟でお願いします。

## Usage

### Preparation

```sh
$ mkdir bin; cd bin
$ wget https://raw.githubusercontent.com/msfukui/git-svn-forcing-reflection/master/git-svn-forcing-reflection.csh
$ wget https://raw.githubusercontent.com/msfukui/git-svn-forcing-reflection/master/git-first.csh
$ chmod 750 git-svn-forcing-reflection.csh git-first.csh
$ cd ..
$ ./bin/git-first.csh git@github.com:msfukui/git-repo-sample.git master
Cloning into 'git'...
remote: Counting objects: 176, done.
remote: Total 176 (delta 0), reused 0 (delta 0), pack-reused 176
Receiving objects: 100% (176/176), 25.50 KiB | 0 bytes/s, done.
Resolving deltas: 100% (80/80), done.
Checking connectivity... done.

git-repository: [git@github.com:msfukui/git-repo-sample.git/master]
  Created [.reflection-prev_git_commit].
  Last commit SHA-1 hash value [16b67fa41447a5b6b882dd867f795bea20b560e7].
OK.
$
```

### Reflection

#### dry running

```sh
$ ./bin/git-svn-forcing-reflection.csh --dry-run git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
```

#### commit

```sh
$ ./bin/git-svn-forcing-reflection.csh git@github.com:msfukui/git-repo-sample.git master svn://localhost/svn-repo-sample trunk
```

## TODO

* svn への commit 時のコミットログメッセージをもう少しわかりやすくしたい。

* svn の内容と git の内容がずれた時が怖いので、定期的に compare する仕組みを追加したい。

* 標準出力メッセージをちゃんと表示できるようにしたい。

## License

本プログラムの提供ライセンスは MIT License です。

詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
