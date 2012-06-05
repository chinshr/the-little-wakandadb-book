## About ##
The Little WakandaDB Book is a free book introducing the object-relational NoSQL store of [Wakanda](http://wakanda.org).

The book is about a subset of Wakanda, a full-stack JavaScript development and deployment environment.

The book was written by [Juergen Fesslmeier](http://example.com).

## Translations ##
Please feel free to translate the book into other languages, fork the project and send us a pull request.

## License ##
The book is freely distributed under the  [Attribution-NonCommercial 3.0 Unported license](<http://creativecommons.org/licenses/by-nc/3.0/legalcode>).

## Formats ##
The book is written in [markdown](http://daringfireball.net/projects/markdown/) and converted to PDF using [PanDoc](http://johnmacfarlane.net/pandoc/). A few LaTex specific commands have been placed in the markdown file to help with PDF generation (namely for the title page and to create page breaks between chapters).

The LaTex template makes use of [Lena Herrmann's JavaScript highlighter](http://lenaherrmann.net/2010/05/20/javascript-syntax-highlighting-in-the-latex-listings-package).

Kindle and ePub format provided using [PanDoc](http://johnmacfarlane.net/pandoc/). Run make en/wakandadb.mobi to generate.

## Generating the PDF ##
I use a variation of <https://github.com/claes/pandoc-templates> to generate the pdf:

	#!/bin/sh
	paper=a4paper
	hmargin=3cm
	vmargin=3cm
	fontsize=11pt

	mainfont=Verdana
	sansfont=Tahoma
	monofont="Courier New"
	columns=onecolumn
	geometry=portrait
	nohyphenation=true


	markdown2pdf --xetex --template=template/xetex.template \
	-V paper=$paper -V hmargin=$hmargin -V vmargin=$vmargin \
	-V mainfont="$mainfont" -V sansfont="$sansfont" -V monofont="$monofont" \
	-V geometry=$geometry -V columns=$columns -V fontsize=$fontsize \
	-V nohyphenation=$nohyphenation --listings en/mongodb.markdown -o mongodb.pdf 

## Title Image ##
A PSD of the title image is included. The font used is [Comfortaa](http://www.dafont.com/comfortaa.font).
