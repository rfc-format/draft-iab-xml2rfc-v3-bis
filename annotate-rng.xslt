<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns="http://relaxng.org/ns/structure/1.0"
               xmlns:x="http://purl.org/net/xml2rfc/ext"
               xmlns:xi="http://www.w3.org/2001/XInclude"
               version="1.0"
>

<xsl:strip-space elements="*"/>

<xsl:output encoding="UTF-8" indent="yes" />

<xsl:param name="doc"/>

<xsl:variable name="d" select="document($doc)"/>

<xsl:template match="rng:grammar">
  <grammar xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0">
    <xsl:apply-templates select="node()|@*" />
  </grammar>
</xsl:template>

<xsl:template match="rng:define/rng:element">
  <xsl:copy>
    <xsl:apply-templates select="@*" />
    <xsl:variable name="a" select="concat('element.',@name)"/>
    <xsl:variable name="section" select="$d//section[@anchor=$a]"/>
    <xsl:if test="$section">
      <xsl:variable name="t" select="$section/t[not(comment()='AG')]"/>
      <xsl:if test="$t">
        <a:annotation>
          <xsl:variable name="o">
            <xsl:apply-templates select="$t[1]" mode="plain"/>
          </xsl:variable>
          <xsl:value-of select="normalize-space($o)"/>
        </a:annotation>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="node()" />
  </xsl:copy>
</xsl:template>

<xsl:template match="rng:define/rng:element//rng:attribute">
  <xsl:copy>
    <xsl:apply-templates select="@*" />
    <xsl:variable name="e" select="ancestor::rng:element/@name"/>
    <xsl:variable name="a" select="concat('element.',$e,'.attribute.',@name)"/>
    <xsl:variable name="section" select="$d//section[@anchor=$a]"/>
    <xsl:if test="$section">
      <xsl:variable name="t" select="$section/t[not(comment()='AG')]"/>
      <xsl:if test="$t">
        <a:annotation>
          <xsl:variable name="o">
            <xsl:apply-templates select="$t[1]" mode="plain"/>
          </xsl:variable>
          <xsl:value-of select="normalize-space($o)"/>
        </a:annotation>
      </xsl:if>
    </xsl:if>
    <xsl:apply-templates select="node()" />
  </xsl:copy>
</xsl:template>

<xsl:template match="text()" mode="plain">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="t" mode="plain">
  <xsl:apply-templates mode="plain"/>
</xsl:template>

<xsl:template match="spanx" mode="plain">
  <xsl:text>*</xsl:text>
  <xsl:value-of select="normalize-space(.)"/>
  <xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="xref" mode="plain">
  <xsl:variable name="t" select="@target"/>
  <xsl:variable name="s" select="$d//*[@anchor=$t]|$includeDirectives//*[@anchor=$t]"/>
  <xsl:choose>
    <xsl:when test="$s/self::section">
      <xsl:choose>
        <xsl:when test="$s/ancestor::back">
          <xsl:text>Appendix</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Section</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text> "</xsl:text>
      <xsl:value-of select="concat($s/@title,$s/name)"/>
      <xsl:text>"</xsl:text>
      <xsl:text> of </xsl:text>
      <xsl:choose>
        <xsl:when test="$d/rfc/@number">
          <xsl:value-of select="concat('RFC ',$d/rfc/@number)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('Internet-Draft ',$d/rfc/@docName)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$s/self::reference">
      <xsl:if test="@x:sec|@section">
        <xsl:value-of select="concat('Section ',@x:sec,@section,' of ')"/>
      </xsl:if>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$t"/>
      <xsl:text>]</xsl:text>
    </xsl:when>
    <xsl:otherwise>???</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="getXIncludes">
  <xsl:param name="nodes"/>
  <xsl:for-each select="$nodes">
    <xsl:choose>
      <xsl:when test="(@parse and @parse!='xml') or @xpointer">
        <xsl:message>Unsupported attributes on x:include element</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="uri">
          <!--<xsl:choose>
            <xsl:when test="starts-with(@href,'https://xml2rfc.ietf.org/public/rfc/')">
              <xsl:call-template name="warning">
                <xsl:with-param name="msg">rewriting URI to /xml2rfc.tools.ietf.org for <xsl:value-of select="@href"/> - see in order to avoid broken server's 403 response (see https://mailarchive.ietf.org/arch/msg/xml2rfc/56sDqFVKF0baqdgEjHQtxOUMf4o).</xsl:with-param>
              </xsl:call-template>
              <xsl:value-of select="concat('https://xml2rfc.tools.ietf.org/public/rfc/',substring-after(@href,'https://xml2rfc.ietf.org/public/rfc/'))"/>
            </xsl:when>
            <xsl:otherwise>-->
              <xsl:value-of select="@href"/>
            <!--</xsl:otherwise>
          </xsl:choose>-->
        </xsl:variable>
        <xsl:variable name="doc">
          <xsl:copy-of select="document($uri)"/>
        </xsl:variable>
        <xsl:if test="count($doc) = 1">
          <xsl:copy-of select="$doc"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:variable name="includeDirectives">
  <xsl:call-template name="getXIncludes">
    <xsl:with-param name="nodes" select="$d//rfc/back//references/xi:include|$d//rfc/back//references/referencegroup/xi:include"/>
  </xsl:call-template>
</xsl:variable>

<!-- rules for identity transformation -->

<xsl:template match="node()|@*"><xsl:copy><xsl:apply-templates select="node()|@*" /></xsl:copy></xsl:template>

<xsl:template match="/">
	<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
</xsl:template>

</xsl:transform>