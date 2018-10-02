all: \
	draft-iab-xml2rfc-v3-bis.redxml \
	draft-iab-xml2rfc-v3-bis.txt

TOOLS=tools

include xml2rfcvoc.mk

%.redxml:	%.xml $(TOOLS)/clean-for-DTD.xslt
	saxon -l $< $(TOOLS)/clean-for-DTD.xslt > $@

%.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@
