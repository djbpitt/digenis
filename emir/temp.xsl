<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- alpha, a-j, 1-75, omega; only to left of equal sign; bis and ter follow base -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="root">
        <root>
            <xsl:apply-templates select="title | p"/>
            <xsl:apply-templates select="anchor[@ref eq 'α']"/>
            <xsl:apply-templates select="anchor[matches(@ref, '^[a-j]')]">
                <xsl:sort select="@ref"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="anchor[matches(@ref, '^[0-9]')]">
                <xsl:sort select="number(tokenize(@ref, '\D+')[1])"/>
                <xsl:sort select="tokenize(@ref, '\d+')[2]"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="anchor[@ref eq 'ω']"/>
        </root>
    </xsl:template>
</xsl:stylesheet>
