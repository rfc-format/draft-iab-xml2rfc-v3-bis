all: \
	draft-iab-rfc7991bis.redxml \
	draft-iab-rfc7991bis.unpg.txt \
	draft-iab-rfc7991bis.txt

xml2rfc.all: \
	draft-iab-rfc7991bis.xml xml2rfcv3-annotated.rng

xml2rfcv3.rnc: xml2rfcv3.rng
	java -jar tools/trang.jar -o lineLength=69 $< $@

#xml2rfcv3.dtd: xml2rfcv3.rng
#	java -jar tools/trang.jar $< $@

xml2rfcv3-annotated.rng: xml2rfcv3.rng annotate-rng.xslt draft-iab-rfc7991bis.xml
	saxon $< annotate-rng.xslt doc=draft-iab-rfc7991bis.xml > $@

xml2rfcv3-spec.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	saxon $< rng2xml2rfc.xslt voc=v3 specsrc=draft-iab-rfc7991bis.xml > $@

xml2rfcv3-spec-deprecated.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	saxon $< rng2xml2rfc.xslt specsrc=draft-iab-rfc7991bis.xml deprecated=yes > $@

xml2rfcv3.rnc.folded: xml2rfcv3.rnc
	./fold-rnc.sh $< > $@

draft-iab-rfc7991bis.xml: xml2rfcv3-spec.xml xml2rfcv3-spec-deprecated.xml xml2rfcv3.rnc.folded differences-from-v2.txt
	cp -v $@ $@.bak
	./refresh-inclusions.sh $@

xml2rfcv2 = xml2rfcv2.rnc

differences-from-v2.txt:	xml2rfcv3.rnc $(xml2rfcv2)
	fold -w66 -s $(xml2rfcv2) > $@.v2
	fold -w66 -s $<  > $@.v3
	diff -w --old-line-format='- %L' --new-line-format='+ %L' \
	--unchanged-line-format='  %L' -d $@.v2 $@.v3 \
	| sed "s/\&/\&amp;/g" > $@
	rm -f $@.v2 $@.v3

xml2rfcv3-full.rng: xml2rfcv3.rng
	./postprocess-rng.py

%.redxml:	%.xml tools/clean-for-DTD.xslt
	saxon -l $< tools/clean-for-DTD.xslt > $@

%.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@

%.unpg.txt:	%.redxml
	tclsh xml2rfc.tcl xml2rfc $< $@.unpg
	mv $@.unpg $@
