<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:djb="http://www.obdurodon.org"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:function name="djb:normalize" as="xs:string">
        <xsl:param name="in" as="xs:string"/>
        <xsl:sequence select="
                translate($in, 'й', 'и')
                => replace('(.)у', '$1ꙋ')
                => replace('^у', 'оу')
                => replace('^е', 'ѥ')
                => replace('([аеыоꙋѧꙗѥию])е', '$1ѥ')
                => replace('([шжчщц])ѥ', '$1е')
                => replace('([шжчщц])ю', '$1ꙋ')
                => replace('([шжчщц])ы', '$1и')
                => replace('([шжчщцц])ъ', '$1ь')
                "/>
    </xsl:function>
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="reader.rnc" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="reader.sch" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:apply-templates select="*"/>
    </xsl:template>
    <xsl:template match="p">
        <xsl:copy>
            <xsl:variable name="words" as="xs:string+" select="tokenize(., '\s+')"/>
            <xsl:for-each select="$words">
                <w>
                    <pldr>
                        <xsl:value-of select="."/>
                    </pldr>
                    <rec>
                        <xsl:value-of select="djb:normalize(.)"/>
                    </rec>
                </w>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="title">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
