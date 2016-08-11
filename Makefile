all: \
	draft-iab-xml2rfc-v3-bis.html \
	draft-iab-xml2rfc-v3-bis.redxml \
	draft-iab-xml2rfc-v3-bis.unpg.txt \
	draft-iab-xml2rfc-v3-bis.txt

TOOLS=tools

include xml2rfcvoc.mk

%.html:	%.xml $(TOOLS)/rfc2629.xslt myxml2rfc.xslt
	saxon -l $< myxml2rfc.xslt > $@

%.redxml:	%.xml $(TOOLS)/clean-for-DTD.xslt
	saxon -l $< $(TOOLS)/clean-for-DTD.xslt > $@

%.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@

%.unpg.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@.unpg
	mv $@.unpg $@
