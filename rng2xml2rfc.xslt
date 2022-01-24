<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:x="http://purl.org/net/xml2rfc/ext"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               version="1.0"
               exclude-result-prefixes="rng a"
>

<xsl:output encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />

<xsl:strip-space elements="figure"/>

<xsl:param name="voc">v2</xsl:param>

<xsl:template match="/">
  <xsl:comment>THIS IS AN AUTOGENERATED FILE. DO NOT EDIT!</xsl:comment>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates select="rng:grammar"/>
</xsl:template>

<!-- generate deprecated section? -->
<xsl:param name="deprecated" select="'no'"/>

<!-- source of spec -->
<xsl:param name="specsrc" select="'draft-reschke-xml2rfc-latest.xml'"/>
<xsl:variable name="spec" select="document($specsrc)"/>

<xsl:template match="rng:grammar">
  <xsl:apply-templates select="rng:define/rng:element[@name]">
    <xsl:sort select="@ns"/>
    <xsl:sort select="@name"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="rng:element">

<xsl:variable name="anchor" select="concat('element.',@name)"/>
<xsl:variable name="sec" select="$spec/rfc//section/section[@anchor=$anchor]"/>
<xsl:variable name="indeprecated" select="contains($sec/../@title,'Deprecated')"/>

<xsl:choose>
  <xsl:when test="$deprecated='yes' and not($indeprecated)">
    <!-- skip -->
  </xsl:when>
  <xsl:when test="$deprecated='no' and $indeprecated">
    <!-- skip -->
  </xsl:when>
  <xsl:otherwise>
<xsl:text>&#10;&#10;</xsl:text>
<xsl:comment><xsl:if test="@ns">{<xsl:value-of select="@ns"/>}</xsl:if><xsl:value-of select="@name"/></xsl:comment>
<section anchor="{$anchor}">
<xsl:choose>
  <xsl:when test="$voc='v3'">
    <name><tt>&lt;<xsl:value-of select="@name"/>&gt;</tt><xsl:if test="@ns"> (in namespace <tt><xsl:value-of select="@ns"/></tt>)</xsl:if></name>
  </xsl:when>
  <xsl:otherwise>
    <xsl:attribute name="title">
      <xsl:value-of select="concat('&lt;',@name,'&gt;')"/>
      <xsl:if test="@ns">(in namespace <xsl:value-of select="@ns"/>)</xsl:if>
    </xsl:attribute>
  </xsl:otherwise>
</xsl:choose>
<x:anchor-alias value="{@name}"/>
<iref item="Elements" subitem="{@name}" primary="true"/>
<iref item="{@name} element" primary="true"/>

<xsl:variable name="attributecontents" select="descendant-or-self::rng:attribute[@name and not(processing-instruction('hidden-in-prose'))]"/>
<xsl:variable name="elementcontents" select="*[not(descendant-or-self::rng:attribute) and not(self::rng:empty)]"/>

<xsl:variable name="appearsin" select="//rng:element[.//rng:ref/@name=current()/@name]"/>
<xsl:variable name="t" select="$spec/rfc/middle/section/section[@anchor=$anchor]"/>
<xsl:variable name="elemdoc" select="$t/t[not(comment()='AG')] | $t/figure[not(comment()='AG')] | $t/artwork[not(comment()='AG')] | $t/sourcecode[not(comment()='AG')] | $t/texttable[not(comment()='AG')] | $t/dl[not(comment()='AG')] | $t/ul[not(comment()='AG')] | $t/ol[not(comment()='AG')]"/>
<xsl:if test="not($elemdoc)">
  <t>
    <xsl:comment>AG</xsl:comment>
    <cref anchor="{$anchor}.missing">element description missing</cref>
  </t>
  <xsl:message>Missing prose in <xsl:value-of select="$anchor"/></xsl:message>
</xsl:if>

<xsl:apply-templates select="$elemdoc" mode="copy"/>

<xsl:if test="$appearsin">
  <t>
    <xsl:comment>AG</xsl:comment>
    <xsl:text>This element appears as a child element of </xsl:text>
    <xsl:variable name="name" select="@name"/>
    <xsl:for-each select="$appearsin">
      <xsl:sort select="@name"/>
      <xsl:text>&lt;</xsl:text>
      <x:ref><xsl:value-of select="@name"/></x:ref>
      <xsl:text>&gt; (</xsl:text>
      <xref target="element.{@name}"/>
      <xsl:if test=".//rng:ref[@name=$name]/processing-instruction('deprecated')">; deprecated in this context</xsl:if>
      <xsl:text>)</xsl:text>
      <xsl:if test="position() != last()">
        <xsl:if test="count($appearsin) > 2">,</xsl:if>
        <xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="position() = last() -1">and </xsl:if>
    </xsl:for-each>
    <xsl:text>.</xsl:text>
  </t>
</xsl:if>

<xsl:choose>
  <xsl:when test="not($elementcontents)">
    <t anchor="{$anchor}.contents">
      <xsl:comment>AG</xsl:comment>
      <xref format="none" target="grammar.{@name}">Content model</xref><xsl:text>: this element does not have any contents.</xsl:text>
    </t>
  </xsl:when>
  <xsl:when test="count($elementcontents)=1 and $elementcontents[1]/self::rng:text">
    <t anchor="{$anchor}.contents">
      <xsl:comment>AG</xsl:comment>
      <xref format="none" target="grammar.{@name}">Content model</xref><xsl:text>: only text content.</xsl:text>
    </t>
  </xsl:when>
  <xsl:when test="count($elementcontents)=1 and $elementcontents[1]/self::rng:ref and //rng:define[@name=$elementcontents[1]/@name]/rng:element/rng:anyName">
    <!-- HACK: special case "any" elements-->
    <t anchor="{$anchor}.contents">
      <xsl:comment>AG</xsl:comment>
      <xref format="none" target="grammar.{@name}">Content model</xref><xsl:text>: any elements.</xsl:text>
    </t>
  </xsl:when>
  <xsl:when test="count($elementcontents)=1">
    <t anchor="{$anchor}.contents">
      <xsl:comment>AG</xsl:comment>
      <xref format="none" target="grammar.{@name}">Content model</xref>:
    </t>
    <xsl:apply-templates select="$elementcontents"/>
  </xsl:when>
  <xsl:otherwise>
    <t anchor="{$anchor}.contents">
      <xsl:comment>AG</xsl:comment>
      <xref format="none" target="grammar.{@name}">Content model</xref><xsl:text>:</xsl:text>
    </t>
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>In this order:</xsl:text>
    </t>
    <ol>
      <xsl:comment>AG</xsl:comment>
      <xsl:apply-templates select="$elementcontents">
        <xsl:with-param name="in-list" select="true()"/>
      </xsl:apply-templates>
    </ol>
  </xsl:otherwise>
</xsl:choose>

<xsl:apply-templates select="$attributecontents">
  <xsl:sort select="concat(@name,*/@name)"/>
</xsl:apply-templates>

<!--<section title="Grammar" toc="exclude" anchor="{$anchor}.grammar">
  <t/>
  <figure><artwork type="application/relax-ng-compact-syntax">&#10;<xsl:apply-templates select="." mode="rnc"/></artwork></figure>
</section>-->
    </section>
  </xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="rng:*">
  <t>
    <xsl:comment>AG</xsl:comment>
    <cref>
      Missing template for <xsl:value-of select="local-name(.)"/>.
    </cref>
  </t>
</xsl:template>

<xsl:template match="rng:oneOrMore[count(rng:ref)=1]">
  <xsl:param name="in-list" select="false()"/>
  <xsl:apply-templates>
    <xsl:with-param name="in-list" select="$in-list"/>
  </xsl:apply-templates>  
</xsl:template>

<xsl:template match="rng:group">
  <xsl:param name="in-list" select="false()"/>
  <li>
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>In this order:</xsl:text>
    </t>
    <ol>
      <xsl:apply-templates>
        <xsl:with-param name="in-list" select="$in-list"/>
      </xsl:apply-templates>
    </ol>
  </li>
</xsl:template>

<xsl:template match="rng:oneOrMore[count(rng:ref) &gt; 1]">
  <t>
    <xsl:comment>AG</xsl:comment>
    One or more sequences of:
  </t>
  <ol>
    <xsl:comment>AG</xsl:comment>
    <xsl:apply-templates mode="simple"/>
  </ol>
</xsl:template>

<xsl:template match="rng:optional[rng:attribute]">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="rng:optional[count(rng:ref)=1]">
  <xsl:param name="in-list" select="false()"/>
  <xsl:apply-templates>
    <xsl:with-param name="in-list" select="$in-list"/>
  </xsl:apply-templates>  
</xsl:template>

<xsl:template match="rng:attribute">
  <xsl:variable name="elem" select="ancestor::rng:element"/>
  <xsl:variable name="anchor" select="concat('element.',$elem/@name,'.attribute.',translate(@name,':','-'))"/>
  <xsl:variable name="pf">
    <xsl:if test="not(parent::rng:optional)"> (Mandatory)</xsl:if>
  </xsl:variable>
  
  <xsl:text>&#10;&#10;</xsl:text>
  <xsl:text>   </xsl:text>
  <xsl:comment><xsl:value-of select="$elem/@name"/>/@<xsl:value-of select="@name"/></xsl:comment>
  <section anchor="{$anchor}" toc="exclude">
    <xsl:choose>
      <xsl:when test="$voc='v3'">
        <name>"<xsl:value-of select="@name"/>" Attribute<xsl:if test="$pf!=''"><xsl:text> </xsl:text><em><xsl:value-of select="$pf"/></em></xsl:if></name>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="title">
          <xsl:value-of select="concat('&quot;', @name,'&quot; attribute',$pf)"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <iref item="Attributes" subitem="{@name}"/>
    <iref item="{$elem/@name} element" subitem="{@name} attribute"/>
    <iref item="{@name} attribute" subitem="in {$elem/@name} element"/>

    <xsl:variable name="t" select="$spec/rfc/middle/section/section/section[@anchor=$anchor]"/>
    <xsl:variable name="attrdoc" select="$t/t[not(comment()='AG')] | $t/figure[not(comment()='AG')] | $t/texttable[not(comment()='AG')] | $t/dl[not(comment()='AG')] | $t/ul[not(comment()='AG')] | $t/ol[not(comment()='AG')]"/>
    <xsl:if test="not($attrdoc)">
      <t>
        <xsl:comment>AG</xsl:comment>
        <cref anchor="{$anchor}.missing">attribute description missing</cref>
      </t>
      <xsl:message>Missing prose in <xsl:value-of select="$anchor"/></xsl:message>
    </xsl:if>
    <xsl:apply-templates select="$attrdoc" mode="copy"/>

    <xsl:if test="rng:choice">
      <t>
        <xsl:comment>AG</xsl:comment>
        <xsl:text>Allowed values:</xsl:text>
      </t>
      <ul>
        <xsl:comment>AG</xsl:comment>
        <xsl:for-each select="rng:choice/rng:value">
          <li>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>"</xsl:text>
            <xsl:if test=". = ../../@a:defaultValue"> (default)</xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>    
  </section>
</xsl:template>

<xsl:template match="rng:ref">
  <xsl:param name="in-list" select="false()"/>
  <xsl:variable name="c">
    <xsl:choose>
      <xsl:when test="$in-list">li</xsl:when>
      <xsl:otherwise>t</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:element name="{$c}">
    <xsl:comment>AG</xsl:comment>
    <xsl:variable name="lookup" select="current()/@name"/>
    <xsl:variable name="elem">
      <xsl:choose>
        <xsl:when test="//rng:define[@name=$lookup]/rng:element/@name">
          <xsl:value-of select="//rng:define[@name=$lookup]/rng:element/@name"/>
        </xsl:when>
        <xsl:when test="$spec//section[@anchor=concat('element.',$lookup)]">
          <xsl:message>INFO: no RNG definition found for <xsl:value-of select="@name"/>, using prose link instead</xsl:message>
          <xsl:value-of select="$lookup"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>ERROR: nothing found for element <xsl:value-of select="@name"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <iref item="Elements" subitem="{$elem}"/>
    <xsl:variable name="container" select="ancestor::rng:element[1]"/>
    <iref item="{$elem} element" subitem="inside {$container/@name}"/>
    <xsl:choose>
      <xsl:when test="parent::rng:oneOrMore">One or more </xsl:when>
      <xsl:when test="parent::rng:zeroOrMore">Optional </xsl:when>
      <xsl:when test="parent::rng:optional">One optional </xsl:when>
      <xsl:when test="parent::rng:choice"></xsl:when>
      <xsl:otherwise>One </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&lt;</xsl:text>
    <x:ref><xsl:value-of select="$elem"/></x:ref>
    <xsl:text>&gt; element</xsl:text>
    <xsl:if test="parent::rng:zeroOrMore or parent::rng:oneOrMore or parent::rng:choice">s</xsl:if>
    <xsl:text> (</xsl:text>
    <xref target="element.{$elem}"/>
    <xsl:if test="processing-instruction('deprecated')">; deprecated in this context</xsl:if>
    <xsl:text>)</xsl:text>
  </xsl:element>
</xsl:template>

<xsl:template match="rng:ref" mode="simple">
  <li>
    <xsl:comment>AG</xsl:comment>
    <xsl:variable name="elem" select="//rng:define[@name=current()/@name]/rng:element/@name"/>
    <iref item="Elements" subitem="{$elem}"/>
    <xsl:variable name="container" select="ancestor::rng:element[1]"/>
    <iref item="{$elem} element" subitem="inside {$container/@name}"/>
    <xsl:text>One &lt;</xsl:text>
    <x:ref><xsl:value-of select="$elem"/></x:ref>
    <xsl:text>&gt; element</xsl:text>
  </li>
</xsl:template>

<xsl:template match="rng:text">
  <xsl:param name="in-list" select="false()"/>
<xsl:choose>
  <xsl:when test="$in-list">
    <li>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>Text</xsl:text>
    </li>
  </xsl:when>
  <xsl:otherwise>
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>Text</xsl:text>
    </t>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="rng:choice">
  <xsl:param name="in-list" select="false()"/>
  <xsl:choose>
    <xsl:when test="$in-list">
      <li>
        <xsl:call-template name="choice"/>
      </li>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="choice"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="choice">
  <xsl:for-each select="*">
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:text>Either:</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Or:</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </t>
    <ul empty="true">
      <xsl:comment>AG</xsl:comment>
      <xsl:apply-templates select=".">
        <xsl:with-param name="in-list" select="true()"/>
      </xsl:apply-templates>
    </ul>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rng:zeroOrMore[rng:ref | rng:text]">
  <xsl:param name="in-list" select="false()"/>
  <xsl:apply-templates>
    <xsl:with-param name="in-list" select="$in-list"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="rng:zeroOrMore[rng:choice]">
  <xsl:param name="in-list" select="false()"/>
<xsl:choose>
  <xsl:when test="$in-list">
    <li>
      <xsl:comment>AG</xsl:comment>
      <t>In any order:</t>
      <ul>
        <xsl:comment>AG</xsl:comment>
        <xsl:apply-templates select="rng:choice/*">
          <xsl:with-param name="in-list" select="true()"/>
        </xsl:apply-templates>
      </ul>
    </li>
  </xsl:when>
  <xsl:otherwise>
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>In any order:</xsl:text>
    </t>
    <ul>
      <xsl:comment>AG</xsl:comment>
      <xsl:apply-templates select="rng:choice/*">
        <xsl:with-param name="in-list" select="true()"/>
      </xsl:apply-templates>
    </ul>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="rng:oneOrMore[rng:choice]">
  <xsl:param name="in-list" select="false()"/>
<xsl:choose>
  <xsl:when test="$in-list">
    <li>
      <xsl:comment>AG</xsl:comment>
      <t>In any order, but at least one of:</t>
      <ul>
        <xsl:comment>AG</xsl:comment>
        <xsl:apply-templates select="rng:choice/*">
          <xsl:with-param name="in-list" select="true()"/>
        </xsl:apply-templates>
      </ul>
    </li>
  </xsl:when>
  <xsl:otherwise>
    <t>
      <xsl:comment>AG</xsl:comment>
      <xsl:text>In any order, but at least one of:</xsl:text>
    </t>
    <ul>
      <xsl:comment>AG</xsl:comment>
      <xsl:apply-templates select="rng:choice/*">
        <xsl:with-param name="in-list" select="true()"/>
      </xsl:apply-templates>
    </ul>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="*" mode="copy">
  <xsl:element name="{local-name()}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="x:*" mode="copy">
  <xsl:element name="x:{local-name()}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates select="node()" mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="text()" mode="copy">
  <xsl:choose>
    <xsl:when test="normalize-space()=''">
      <!-- eat the node -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- experimental RNC conversion -->
<xsl:template match="*" mode="rnc">
  <xsl:message>Missing mode=rnc template for <xsl:value-of select="local-name()"/></xsl:message>
</xsl:template>

<xsl:template match="rng:element" mode="rnc">
  <xsl:call-template name="escape-name"/>
  <xsl:text> =&#10;</xsl:text>
  <xsl:text>  element </xsl:text>
  <xsl:call-template name="escape-name"/>
  <xsl:text> {&#10;</xsl:text>
  <xsl:for-each select="*">
    <xsl:text>    </xsl:text>
    <xsl:apply-templates select="." mode="rnc">
      <xsl:with-param name="indent" select="'    '"/>
    </xsl:apply-templates>
    <xsl:if test="position()!=last()">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
  <xsl:text>  }&#10;</xsl:text>
</xsl:template>

<xsl:template match="rng:text" mode="rnc">
  <xsl:text>text</xsl:text>
</xsl:template>

<xsl:template match="rng:oneOrMore" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:apply-templates select="*" mode="rnc">
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
  <xsl:text>+</xsl:text>
</xsl:template>

<xsl:template match="rng:zeroOrMore" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:apply-templates select="*" mode="rnc">
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
  <xsl:text>*</xsl:text>
</xsl:template>

<xsl:template match="rng:optional" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:apply-templates select="*" mode="rnc">
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
  <xsl:text>?</xsl:text>
</xsl:template>

<xsl:template match="rng:choice" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:text>(</xsl:text>
  <xsl:for-each select="*">
    <xsl:apply-templates select="." mode="rnc">
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:apply-templates>
    <xsl:if test="position()!=last()">
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:text> | </xsl:text>
    </xsl:if>
  </xsl:for-each>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="rng:attribute/rng:choice" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:variable name="content" select="normalize-space(.)"/>
  <xsl:variable name="len" select="string-length($content) + count(*) * 5 + string-length(../@name)"/>
  <xsl:comment>
    <xsl:value-of select="$len"/>
  </xsl:comment>
  <xsl:choose>
    <xsl:when test="count(*)=1">
      <xsl:text> { </xsl:text>
      <xsl:apply-templates select="*" mode="rnc">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
      <xsl:text> }</xsl:text>
    </xsl:when>
    <xsl:when test="$len > 55">
      <xsl:text> (</xsl:text>
      <xsl:for-each select="*">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>  </xsl:text>
        <xsl:value-of select="$indent"/>
        <xsl:if test="position()!=1">
          <xsl:text>| </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="." mode="rnc">
          <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:text>)</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> ( </xsl:text>
      <xsl:for-each select="*">
        <xsl:apply-templates select="." mode="rnc">
          <xsl:with-param name="indent" select="$indent"/>
        </xsl:apply-templates>
        <xsl:if test="position()!=last()">
          <xsl:text> | </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text> )</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:value" mode="rnc">
  <xsl:text>"</xsl:text>
  <!-- escaping? -->
  <xsl:value-of select="."/>
  <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="rng:data[@type='IDREF']" mode="rnc">
  <xsl:text> { xsd:IDREF }</xsl:text>
</xsl:template>

<xsl:template match="rng:data[@type='ID']" mode="rnc">
  <xsl:text> { xsd:ID }</xsl:text>
</xsl:template>

<xsl:template match="rng:attribute" mode="rnc">
  <xsl:param name="indent"/>
  <xsl:text>attribute </xsl:text>
  <xsl:call-template name="escape-name"/>
  <xsl:choose>
    <xsl:when test="*">
      <xsl:apply-templates select="*" mode="rnc">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> { text }</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rng:attribute/rng:ref" mode="rnc">
  <xsl:text> { </xsl:text>
  <xsl:call-template name="escape-name"/>
  <xsl:text> }</xsl:text>
</xsl:template>

<xsl:template match="rng:ref" mode="rnc">
  <xsl:call-template name="escape-name-xref"/>
</xsl:template>

<xsl:template match="rng:empty" mode="rnc">
  <xsl:text>empty</xsl:text>
</xsl:template>

<xsl:template name="escape-name-xref">
  <xsl:if test="@name='list'">
    <xsl:text>\</xsl:text>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@name='text'">
      <xsl:value-of select="@name"/>
    </xsl:when>
    <xsl:otherwise>
      <xref target="element.{@name}.grammar" format="none"><xsl:value-of select="@name"/></xref>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="escape-name">
  <xsl:if test="@name='list'">
    <xsl:text>\</xsl:text>
  </xsl:if>
  <xsl:value-of select="@name"/>
</xsl:template>

</xsl:transform>