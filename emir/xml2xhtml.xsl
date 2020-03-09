<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <!-- Setup -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="p"/>
    <!-- Stylesheet variables -->
    <xsl:variable name="uri" as="xs:string"
        select="replace(substring-before(tokenize(base-uri(), '/')[last()], '.xml'), '_slavic', '')"/>
    <!-- Functions -->
    <xsl:function name="djb:formatPage" as="xs:string">
        <xsl:param name="pageRef" as="xs:string" required="yes"/>
        <xsl:variable name="result">
            <xsl:text>[</xsl:text>
            <xsl:if test="starts-with($pageRef, '3')">
                <xsl:text>Pog </xsl:text>
            </xsl:if>
            <xsl:if test="starts-with($pageRef, '1')">
                <xsl:text>Tit </xsl:text>
            </xsl:if>
            <xsl:value-of select="$pageRef"/>
            <xsl:text>] </xsl:text>
        </xsl:variable>
        <xsl:sequence select="$result"/>
    </xsl:function>
    <!-- Templates -->
    <xsl:template match="/">
        <xsl:apply-templates select="root/p" mode="title"/>
        <xsl:apply-templates select="//anchor"/>
    </xsl:template>
    <xsl:template match="anchor">
        <div id="{concat($uri,'_',replace(@ref,'=.*',''))}" data-pageref="{@pageref}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="anchor/p">
        <p>
            <span class="anchor_label">
                <xsl:text>(</xsl:text>
                <xsl:analyze-string select="../@ref" regex="^(.+?)(bis)$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                        <sup>2</sup>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
                <xsl:text>) </xsl:text>
            </span>
            <xsl:if test="node()[1][not(self::page)]">
                <xsl:variable name="pageRef" as="xs:string">
                    <xsl:value-of select="@pageref"/>
                </xsl:variable>
                <span class="page">
                    <xsl:sequence select="djb:formatPage($pageRef)"/>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="p" mode="title">
        <p>
            <xsl:apply-templates mode="title"/>
        </p>
    </xsl:template>
    <xsl:template match="text()" mode="title">
        <cite>
            <xsl:value-of select="."/>
        </cite>
    </xsl:template>
    <xsl:template match="q">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    <xsl:template match="page" mode="#all">
        <span class="page">
            <xsl:sequence select="djb:formatPage(.)"/>
        </span>
    </xsl:template>
    <xsl:template match="title">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    <xsl:template match="add">
        <add>
            <xsl:apply-templates/>
        </add>
    </xsl:template>
    <xsl:template match="change">
        <del>
            <xsl:value-of select="@orig"/>
        </del>
        <add>
            <xsl:apply-templates/>
        </add>
    </xsl:template>
</xsl:stylesheet>
