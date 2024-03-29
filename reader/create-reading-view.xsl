<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <!-- 
        Creates reading view of section of Digenis reader
        input is reading-xx-annotated.xml, output is reading-xx.xhtml
    -->
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>
    <xsl:strip-space elements="p w s"/>
    <xsl:variable name="part-number" as="xs:string"
        select="base-uri() ! tokenize(., '/')[last()] => substring-before('-annotated') => substring-after('-') => replace('^0+', '')"/>
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="concat('Digenis part ', $part-number)"/>
                </title>
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
                        <span class="rec">Rv</span>
                    </div>
                </xsl:for-each>
            </div>
        </main>
        <hr/>
        <footer class="note">Reconstruction and annotations by Robert Romanchuk and David J.
            Birnbaum.</footer>
    </xsl:template>
    <xsl:template match="section/title">
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
            <xsl:apply-templates select="* except ms"/>
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
    <xsl:template match="title">
        <cite>
            <xsl:apply-templates/>
        </cite>
    </xsl:template>
    <xsl:template match="q">
        <q>
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    <xsl:template match="em">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="gk">
        <span class="gk">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="text()">
        <!-- 
            XHTML will wrap after prime by default
            insert word joiner (&#x2060;) to override
        -->
        <xsl:analyze-string select="." regex="′">
            <xsl:matching-substring>
                <xsl:value-of select=". || '&#x2060;'"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>
