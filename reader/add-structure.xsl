<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="p">
        <xsl:copy>
            <xsl:variable name="sentences" as="xs:string+" select="tokenize(., '[\.\?]\s+')"/>
            <xsl:for-each select="$sentences">
                <s>
                    <xsl:variable name="words" as="xs:string+" select="tokenize(., '\s+')"/>
                    <xsl:for-each select="$words">
                        <w>
                            <pldr>
                                <xsl:value-of select="."/>
                            </pldr>
                            <rec>
                                <xsl:value-of select="."/>
                            </rec>
                        </w>
                    </xsl:for-each>
                </s>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="title">
        <xsl:copy>
            <xsl:variable name="words" as="xs:string+" select="tokenize(., '\s+')"/>
            <xsl:for-each select="$words">
                <w>
                    <pldr>
                        <xsl:value-of select="."/>
                    </pldr>
                    <rec>
                        <xsl:value-of select="."/>
                    </rec>
                </w>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
