<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="filename"/>
    <xsl:variable name="input" as="xs:string+"
        select="
            for $line in tokenize(unparsed-text($filename), '\n+')
            return
                normalize-space($line)"/>
    <xsl:function name="djb:format_quote">
        <xsl:param name="input" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="{'&quot;(.*?)&quot;'}">
            <xsl:matching-substring>
                <q>
                    <xsl:sequence select="djb:format_folio(regex-group(1))"/>
                </q>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:sequence select="djb:format_folio(.)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    <xsl:function name="djb:format_folio">
        <xsl:param name="input" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="{'\((\d+v?)\)'}">
            <xsl:matching-substring>
                <page>
                    <xsl:sequence
                        select="
                            concat(regex-group(1), if (ends-with(regex-group(1), 'v')) then
                                ()
                            else
                                'r')"
                    />
                </page>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:sequence select="djb:formatgrotta(.)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    <xsl:function name="djb:formatgrotta">
        <xsl:param name="input" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="{'\[(.+)\]'}">
            <xsl:matching-substring>
                <G>
                    <xsl:choose>
                        <xsl:when test="contains(regex-group(1), '-')">
                            <xsl:for-each
                                select="xs:integer(substring-before(regex-group(1), '-')) to xs:integer(substring-after(regex-group(1), '-'))">
                                <line n="{.}">Placeholder</line>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <line n="{regex-group(1)}">Placeholder</line>
                        </xsl:otherwise>
                    </xsl:choose>
                </G>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:sequence select="djb:formatsupplied(.)"/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    <xsl:function name="djb:formatsupplied">
        <xsl:param name="input" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="{'\((.+)\)'}">
            <xsl:matching-substring>
                <supplied>
                    <xsl:sequence select="regex-group(1)"/>
                </supplied>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:sequence select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    <xsl:template name="init">
        <xsl:variable name="tmp" as="element(root)">
            <root>
                <xsl:variable name="pageref-a" as="xs:string"
                    select="
                        replace($input[1], '\((\d+v?)\).*', '$1')"/>
                <xsl:variable name="pageref" as="xs:string"
                    select="
                        concat($pageref-a, if (ends-with($pageref-a, 'v')) then
                            ()
                        else
                            'r')"/>
                <title type="supplied" pageref="{$pageref}">
                    <page>
                        <xsl:value-of select="$pageref"/>
                    </page>
                    <xsl:value-of select="substring-after($input[1], ') ')"/>
                </title>
                <xsl:for-each select="$input[position() gt 1 and string-length(.) gt 0]">
                    <xsl:variable name="line_text" as="xs:string"
                        select="replace(., '^(\d+|ω)\. ', '')"/>
                    <xsl:variable name="line_no" as="xs:string"
                        select="substring-before(., $line_text)"/>
                    <anchor ref="{substring-before($line_no,'.')}">
                        <xsl:sequence select="djb:format_quote($line_text)"/>
                    </anchor>
                </xsl:for-each>
            </root>
        </xsl:variable>
        <xsl:apply-templates select="$tmp"/>
    </xsl:template>
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="anchor">
        <xsl:copy>
            <xsl:copy-of select="@ref"/>
            <p>
                <xsl:attribute name="pageref" select="preceding::page[1]"/>
                <xsl:apply-templates select="@* except @ref | node()"/>
            </p>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
