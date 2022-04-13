files = README.pdf README.docx consort.pdf consort.png

.PHONY: all clean

all: $(files)

consort.pdf: consort.dot
	dot -Tpdf -o $@ $<

%.png: %.dot
	dot -Tpng -o $@ $<

%.pdf: %.md
	pandoc -o $@ $<

%.docx: %.md
	pandoc -o $@ $<

clean:
	rm -rf $(files)
