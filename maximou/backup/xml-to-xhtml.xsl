<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:template match="/">
        <xsl:variable name="id"
            select="substring-before(tokenize(base-uri(.), '/')[last()], '.xml')"/>
        <section id="{$id}">
            <h2>
                <xsl:value-of select="concat(upper-case(substring($id, 1, 1)), substring($id, 2))"/>
            </h2>
            <div>
                <xsl:apply-templates>
                    <xsl:with-param name="id"/>
                </xsl:apply-templates>
            </div>
        </section>
    </xsl:template>
    <xsl:template match="anchor">
        <xsl:param name="id"/>
        <div id="{concat($id, @ref)}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="title">
        <div>
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>
    <xsl:template match="title/text()">
        <cite>
            <xsl:value-of select="."/>
        </cite>
    </xsl:template>
    <xsl:template match="p">
        <p>
            <span class="anchor_label">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="substring(../@ref, 2)"/>
                <xsl:text>) </xsl:text>
            </span>
            <span>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@pageref"/>
                <xsl:text>] </xsl:text>
            </span>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="page">
        <span class="page">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>] </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="G">
        <strong>[Grottaferrata text will be inserted here]</strong>
    </xsl:template>
</xsl:stylesheet>
