all: \
	draft-iab-xml2rfc-v3-bis.redxml \
	draft-iab-xml2rfc-v3-bis.txt

TOOLS=tools

xml2rfc.all: \
	draft-iab-xml2rfc-v3-bis.xml xml2rfcv3-annotated.rng

xml2rfcv3.rnc: xml2rfcv3.rng
	java -jar $(TOOLS)/trang.jar -o lineLength=69 $< $@

#xml2rfcv3.dtd: xml2rfcv3.rng
#	java -jar $(TOOLS)/trang.jar $< $@

xml2rfcv3-annotated.rng: xml2rfcv3.rng annotate-rng.xslt draft-iab-xml2rfc-v3-bis.xml
	saxon $< annotate-rng.xslt doc=draft-iab-xml2rfc-v3-bis.xml > $@

xml2rfcv3-spec.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	saxon $< rng2xml2rfc.xslt voc=v3 specsrc=draft-iab-xml2rfc-v3-bis.xml > $@

xml2rfcv3-spec-deprecated.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	saxon $< rng2xml2rfc.xslt specsrc=draft-iab-xml2rfc-v3-bis.xml deprecated=yes > $@

xml2rfcv3.rnc.folded: xml2rfcv3.rnc
	./fold-rnc.sh $< > $@

draft-iab-xml2rfc-v3-bis.xml: xml2rfcv3-spec.xml xml2rfcv3-spec-deprecated.xml xml2rfcv3.rnc.folded
	cp -v $@ $@.bak
	./refresh-inclusions.sh $@

xml2rfcv3-full.rng: xml2rfcv3.rng
	./postprocess-rng.py

%.redxml:	%.xml $(TOOLS)/clean-for-DTD.xslt
	saxon -l $< $(TOOLS)/clean-for-DTD.xslt > $@

%.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@
