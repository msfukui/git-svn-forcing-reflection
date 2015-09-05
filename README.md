# git-svn-forcing-reflection

## What's this?

git の特定のブランチのコードセットを subversion の特定のブランチに強制的に上書きしてコミットするための簡易なスクリプトです。

svn から git ベースにコード・レポジトリの移行を進めるにあたって、git 側で更新した内容を svn 側にも常に最新の情報を反映しておきたいニーズがあって作りました。

移行期間中は svn は更新せずに常に git のみを使う、という前提で、常に git 側の情報で svn の内容を上書きします。

最初は git-svn をうまく使うことを考えたのですが、merge の際の conflict の解消が厳しかったので、個別にスクリプトを作りました。

自分でもかなり筋悪な対応だとは思いますので、もっと良い方法があればぜひご指摘いただけると嬉しいです。

## Requirement

* スクリプトは csh で書いたため、実行には csh が必要です。

* 内部で git, svn, diff, awk を使っているため、それぞれが必要です。

* 実行時ディレクトリ配下に作業ディレクトリを作成するため、実行時ディレクトリには書き込み権限が必要です。

## Note

* 前回のコミットログからの差分を元にコミットメッセージを生成するため、*初回実行時*には、前回のコミットのSHA-1ハッシュ値を、実行時ディレクトリ直下の .reflection-prev_git_commit に書き込んでおく必要があります。

* svn のコミットログには author などの情報は反映しないことになるため、svn 側のログは捨てる覚悟でお願いします。

## Usage

### Preparation

```sh
$ mkdir bin; cd bin
$ wget https://raw.githubusercontent.com/msfukui/git-svn-forcing-reflection/master/git-svn-forcing-reflection.csh
$ wget https://raw.githubusercontent.com/msfukui/git-svn-forcing-reflection/master/setup.csh
$ chmod 750 git-svn-forcing-reflection.csh setup.csh
$ cd ..
```

### Reflection

```sh
```

## TODO

* 初回実行時のコミットのSHA-1ハッシュ値を準備する必要がある件を忘れないように極力省力化したい。

* svn への commit 時のコミットログメッセージをもう少しわかりやすくしたい。

## License

本プログラムの提供ライセンスは MIT License です。

詳細は [LICENSE.txt](LICENSE.txt) を参照してください。

[EOF]
