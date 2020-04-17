# XSLT processor of choice
XSLT=saxon

all: \
	draft-iab-rfc7991bis.redxml \
	draft-iab-rfc7991bis.unpg.txt \
	draft-iab-rfc7991bis.txt \
	xml2rfcv3-annotated.rng

xml2rfc.all: \
	draft-iab-rfc7991bis.xml xml2rfcv3-annotated.rng

xml2rfcv3.rnc: xml2rfcv3.rng
	java -jar trang.jar -o lineLength=69 $< $@

#xml2rfcv3.dtd: xml2rfcv3.rng
#	java -jar trang.jar $< $@

xml2rfcv3-annotated.rng: xml2rfcv3.rng annotate-rng.xslt draft-iab-rfc7991bis.xml
	$(XSLT) $< annotate-rng.xslt doc=draft-iab-rfc7991bis.xml > $@

xml2rfcv3-spec.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	$(XSLT) $< rng2xml2rfc.xslt voc=v3 specsrc=draft-iab-rfc7991bis.xml > $@

xml2rfcv3-spec-deprecated.xml: xml2rfcv3.rng rng2xml2rfc.xslt
	$(XSLT) $< rng2xml2rfc.xslt specsrc=draft-iab-rfc7991bis.xml deprecated=yes > $@

xml2rfcv3.rnc.folded: xml2rfcv3.rnc
	./fold-rnc.sh $< | tr -d "\\015" > $@

draft-iab-rfc7991bis.xml: xml2rfcv3-spec.xml xml2rfcv3-spec-deprecated.xml xml2rfcv3.rnc.folded differences-from-v2.txt
	cp -v $@ $@.bak
	./refresh-inclusions.sh $@

xml2rfcv2 = xml2rfcv2.rnc

differences-from-v2.txt:	xml2rfcv3.rnc $(xml2rfcv2)
	fold -w66 -s $(xml2rfcv2) > $@.v2
	fold -w66 -s $<  > $@.v3
	diff -w --old-line-format='- %L' --new-line-format='+ %L' \
	--unchanged-line-format='  %L' -d $@.v2 $@.v3 \
	| sed "s/\&/\&amp;/g" | tr -d "\\015" > $@
	rm -f $@.v2 $@.v3

xml2rfcv3-full.rng: xml2rfcv3.rng
	./postprocess-rng.py

%.redxml:	%.xml
	$(XSLT) -l $< clean-for-xml2rfc-v3.xslt > $@

%.txt:	%.redxml
	xml2rfc --v3 --text $< -o $@

%.unpg.txt:	%.redxml
	xml2rfc --v3  --no-pagination $< -o $@
