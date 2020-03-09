<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- increment 12 through 33 -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@ref">
        <xsl:attribute name="ref">
            <xsl:analyze-string select="." regex="\d+">
                <xsl:matching-substring>
                    <xsl:choose>
                        <xsl:when test="number(.) gt 11 and number(.) lt 34">
                            <xsl:value-of select="string(number(.) + 1)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:value-of select="."/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
