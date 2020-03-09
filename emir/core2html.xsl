<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- 
        Lines in Roman, sense in italics
        @e and @g values only if present
    -->
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:template match="p">
        <div id="core_{@n}">
            <p>
                <span class="anchor_label">
                    <xsl:value-of select="concat('(', @n, ') ')"/>
                </span>
                <span>
                    <xsl:attribute name="class">
                        <xsl:choose>
                            <xsl:when test="@type eq 'lines'">lines</xsl:when>
                            <xsl:otherwise>sense</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </span>
                <xsl:if test="string-length(concat(@e, @g)) ne 0">
                    <span class="anchor_label">
                        <xsl:text> [</xsl:text>
                        <xsl:variable name="mss" as="xs:string*">
                            <xsl:if test="@e ne ''">
                                <xsl:value-of select="concat('E', @e)"/>
                            </xsl:if>
                            <xsl:if test="@g ne ''">
                                <xsl:value-of select="concat('G', @g)"/>
                            </xsl:if>
                        </xsl:variable>
                        <xsl:value-of select="string-join($mss, '; ')"/>
                        <xsl:text>]</xsl:text>
                    </span>
                </xsl:if>
            </p>
        </div>
    </xsl:template>
</xsl:stylesheet>
