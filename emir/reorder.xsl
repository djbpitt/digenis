<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="root">
        <xsl:copy>
            <!-- alpha, then letters, then numbers, omega -->
            <xsl:apply-templates select="title, p, anchor[@ref eq 'α']"/>
            <xsl:apply-templates select="anchor[matches(@ref, '^[a-j]')]">
                <xsl:sort select="@ref"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="anchor[matches(@ref, '^[0-9]')]">
                <!-- Replace 'bis' with '.5',
                    then strip everything after digits plus dot,
                    then convert to double for numerical sort -->
                <xsl:sort select="number(replace(replace(@ref, 'bis', '.5'), '(^[\.\d]+).*', '$1'))"
                />
            </xsl:apply-templates>
            <xsl:apply-templates select="anchor[@ref eq 'ω']"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
