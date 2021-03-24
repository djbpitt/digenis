<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>
    <xsl:strip-space elements="p w s"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>Sample Digenis reading file</title>
                <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
                <link rel="stylesheet" type="text/css" href="reading-view.css"/>
                <script type="text/javascript" src="reader.js"/>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="body">
        <main>
            <xsl:apply-templates/>
            <div id="labels">
                <xsl:for-each select="1 to 100">
                    <div class="label_group">
                        <span class="n">&#x00a0;</span>
                        <span class="pldr">Ms</span>
                        <span class="rec">Rec</span>
                    </div>
                </xsl:for-each>
            </div>
        </main>
        <hr/>
        <footer class="note">Reconstruction and annotations by Robert Romanchuk and David J.
            Birnbaum.</footer>
    </xsl:template>
    <xsl:template match="title">
        <h1 class="os">
            <xsl:apply-templates/>
        </h1>
        <p><span class="note">Pink</span> = mouse over for annotation; <span class="diff"
                >blue</span> = reconstruction differs from manuscript</p>
    </xsl:template>
    <xsl:template match="p">
        <div class="p">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="w">
        <div>
            <xsl:attribute name="class" select="
                    concat('w', if (note) then
                        ' note'
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
        <span>
            <xsl:attribute name="class" select="
                    concat('rec', if (. ne preceding-sibling::pldr) then
                        ' diff'
                    else
                        ())"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="note">
        <div class="annotation">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="os">
        <span class="os">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="gloss">
        <span class="gloss">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="link">
        <a href="{.}">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
</xsl:stylesheet>
