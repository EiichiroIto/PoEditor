# PoEditor
自作アプリ向けの PO ファイルエディタです。
アプリの翻訳ファイルを作成するために使います。
現状、英語-日本語にしか対応していません。

# 使い方
## テンプレートファイルを生成する

以下のような形式のテキストファイルを用意する。（msgstrは空文字列で良い）
```
msgid "original text"
msgstr ""
```
テキストファイルは foo.pot というファイル名で保存する。

FromScratchアプリの場合、
```smalltalk
ScratchTranslator generatePOTFile.
```
を評価してできた app.pot を使うことができる。

## PoEditor でテンプレートファイルを読み込む
PoEditorを起動して、ファイルメニューから「テンプレートを開く ...」を選ぶ。

上で作成したテンプレートファイルを指定して読み込む。

テンプレートファイルには既存の翻訳ファイルを指定しても構わない。

## 翻訳ファイルを読み込む
既に作成済の翻訳ファイルがあれば、それを読み込む。

ファイルメニューから「翻訳を開く ...」を選び、ファイルを指定して読み込む。
他にも翻訳ファイルがあれば、連続して読み込んでおく。

なお、翻訳ファイル内のエントリのうち、テンプレートファイルで登録されていない msgid を持つエントリは無視される。

## 問題のあるエントリを解決する。
未入力だったり、複数のmsgstrがあるエントリには先頭に ! が表示される。

未入力のものは右側ペインの編集ボタンを押して入力する。

複数のmsgstrがある場合は、右側ペインの候補の中から適切なものを選ぶ。

全てのエントリについて ! が表示されないようにする。

## エントリを検査する
検査ボタンを押して全てのエントリが適切かどうか検査する。

問題あるエントリについては先頭に ! が表示されるので対応する。

なお、msgid や msgstr に％記号が使用されていると引数として解釈されるので注意する。

## プロジェクトを保存する
ファイルメニューから「プロジェクトを保存する」を選んでプロジェクトを保存する。

## 翻訳ファイルを保存する
ファイルメニューから「翻訳を保存する」を選んで翻訳ファイルを保存する。
