<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Sample Digenis reading file</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <link rel="stylesheet" type="text/css" href="reading-view.css"/>
            </head>
            <body>
                <xsl:apply-templates select="title, principles"/>
                <main>
                    <xsl:apply-templates/>
                </main>
                <div id="labels">
                    <xsl:for-each select="1 to 100"><br/>Ms<br/>Rec<br/></xsl:for-each>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="title">
        <h1>
            <xsl:value-of select="string-join(descendant::pldr, ' ')"/>
        </h1>
    </xsl:template>
    <xsl:template match="p">
        <div class="p">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="w">
        <div>
            <xsl:attribute name="class" select="
                    concat('w', if (pldr ne rec) then
                        ' diff'
                    else
                        ())"/>
            <span class="n">
                <xsl:value-of select="count(preceding::w) + 1"/>
            </span>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="pldr">
        <span class="pldr">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="rec">
        <span class="rec">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="principles">
        <hr/>
        <h2>Normalization principles</h2>
        <ul id="principles">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="item">
        <li>
            <xsl:apply-templates/>
            <xsl:text> </xsl:text>
            <xsl:if test="@hgl">
                <xsl:text>(Lunt #</xsl:text>
                <xsl:value-of select="@hgl"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </li>
    </xsl:template>
    <xsl:template match="os">
        <span class="os">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
</xsl:stylesheet>
