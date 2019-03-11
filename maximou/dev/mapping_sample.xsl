<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="json" indent="yes"/>
    <xsl:variable name="top" select="/"/>
    <xsl:variable name="mapping" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:for-each select="distinct-values(//mapping/*)">
                <xsl:sort select="."/>
                <xsl:message select="."/>
                <xsl:map-entry key="string(.)"
                    select="string-join(sort($top//mapping/*[. eq current()]/(preceding-sibling::* | following-sibling::*)), ' ')"
                />
            </xsl:for-each>
        </xsl:map>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:sequence select="$mapping"/>
    </xsl:template>
</xsl:stylesheet>
