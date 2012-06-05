en/wakandadb.epub:	en/title.txt en/wakandadb.md
	pandoc -o $@ $^

en/wakandadb.mobi:	en/wakandadb.epub
	kindleGen $^