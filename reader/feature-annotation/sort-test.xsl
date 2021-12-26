<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
  version="3.0">
  <xsl:include href="digenis-functions.xsl"/>
  <xsl:template match="/">
    <results>
      <xsl:apply-templates select="//rec"/>
    </results>
  </xsl:template>
  <xsl:template match="rec">
    <result>
      <orig>
        <xsl:value-of select="normalize-space(.)"/>
      </orig>
      <norm>
        <xsl:value-of select="djb:sort-os(normalize-space(.))"/>
      </norm>
    </result>
  </xsl:template>
</xsl:stylesheet>
