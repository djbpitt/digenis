<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="#all" version="3.0">
    <!-- ================================================================= -->
    <!-- Creates reading view of section of Digenis reader                 -->
    <!-- Run with EE and -config:ee-package-config.xml                     -->
    <!-- Input: reading-xx-annotated.xml                                   -->
    <!-- Output: reading-xx.xhtml                                          -->
    <!--                                                                   -->
    <!-- TODO: Tab title assumes filename digenis-\d+-features.xml         -->
    <!-- ================================================================= -->

    <!-- ================================================================= -->
    <!-- Housekeeping                                                      -->
    <!-- ================================================================= -->
    <xsl:use-package name="http://www.obdurodon.org/digenis-functions" version="1.0"/>
    <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
        indent="yes"/>
    <xsl:strip-space elements="p w s rec"/>

    <!-- ================================================================= -->
    <!-- Stylesheet variables                                              -->
    <!-- ================================================================= -->
    <xsl:variable name="part-number" as="xs:string"
        select="base-uri() ! tokenize(., '/')[last()] => substring-before('-features') => substring-after('-') => replace('^0+', '')"/>
    <xsl:variable name="all-words" as="document-node()">
        <xsl:document>
            <!-- ========================================================= -->
            <!-- Merge into one document for key                           -->
            <!-- ========================================================= -->
            <xsl:sequence select="collection('lexemes?select=*.xml')"/>
        </xsl:document>
    </xsl:variable>
    <xsl:variable name="abbreviate" as="map(xs:string, xs:string)">
        <!-- ============================================================= -->
        <!-- Part of speech, number type, pronoun type                     -->
        <!-- ============================================================= -->
        <xsl:sequence select="
                map {
                    'adjective': 'adj',
                    'adverb': 'adv',
                    'conjunction': 'conj',
                    'noun': 'noun',
                    'number': 'num',
                    'participle': 'ppl',
                    'particle': 'part',
                    'preposition': 'prep',
                    'pronoun': 'pron',
                    'verb': 'verb',
                    'cardinal': 'card',
                    'ordinal': 'ord',
                    'collective': 'coll',
                    'personal': 'pers',
                    'possessive': 'poss',
                    'relative': 'rel',
                    'demonstrative': 'dem'
                }"/>
    </xsl:variable>

    <!-- ================================================================= -->
    <!-- Keys                                                              -->
    <!-- ================================================================= -->
    <xsl:key name="lexemeByLemmaAndName" match="*" use="@lemma, name()" composite="yes"/>

    <!-- ================================================================= -->
    <!-- Main                                                              -->
    <!-- ================================================================= -->
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
    <xsl:template match="section/title">
        <header>
            <h1 class="os">
                <xsl:apply-templates/>
            </h1>
            <p><span class="note">Pink</span> = mouse over for annotation; <span class="diff"
                    >blue</span> = reconstruction differs from manuscript</p>
        </header>
    </xsl:template>
    <xsl:template match="body">
        <main>
            <div id="scrollable">
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
            </div>
        </main>
        <footer>
            <p id="grammar">
                <span id="grammar-initial" class="grammar">Grammatical information</span>
                <xsl:apply-templates select="//rec" mode="grammar"/>
            </p>
            <!-- Running out of space; can we omit this? -->
            <!--<p class="note">Reconstruction and annotations by Robert Romanchuk and David J.
                Birnbaum.</p>-->
        </footer>
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
        <!-- ============================================================= -->
        <!-- Add 'diff' to @class if different after normalization         -->
        <!-- ============================================================= -->
        <span>
            <xsl:attribute name="class" select="
                    concat('rec', if (not(djb:norm-diff(., preceding-sibling::pldr))) then
                        ' diff'
                    else
                        ())"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="note">
        <div class="annotation">
            <!--  ======================================================== -->
            <!-- Repeat reading, since otherwise popup might hide it       -->
            <!--  ======================================================== -->
            <span class="os">
                <xsl:value-of select="exactly-one(preceding-sibling::rec) ! replace(., '\P{L}', '')"
                />
            </span>
            <xsl:text>: </xsl:text>
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

    <!-- ================================================================= -->
    <!-- Mode: grammar                                                     -->
    <!-- Retroversion with regular grammatical information and gloss       -->
    <!-- ================================================================= -->
    <xsl:template match="rec" mode="grammar">
        <xsl:variable name="adjusted-name" as="xs:string" select="
                if (participle) then
                    'verb'
                else
                    */name()"/>
        <span id="grammar-{position()}" class="grammar" style="display: none;">
            <xsl:apply-templates
                select="key('lexemeByLemmaAndName', (*/@lemma, $adjusted-name), $all-words)"
                mode="grammar">
                <xsl:with-param name="local-categories" as="element()" select="*" tunnel="yes"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="* except rec" mode="grammar" priority="10">
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <!-- ============================================================= -->
        <!-- Match first for all parts of speech                           -->
        <!-- ============================================================= -->
        <xsl:value-of select="$abbreviate($local-categories/name())"/>
        <xsl:text> </xsl:text>
        <xsl:next-match>
            <!-- ========================================================= -->
            <!-- Insert specific information between cite and lemma/gloss  -->
            <!-- None for adv, conj, part, prep; ppl included in verb      -->
            <!-- ========================================================= -->
        </xsl:next-match>
        <xsl:text> </xsl:text>
        <span class="os">
            <xsl:value-of select="@lemma"/>
        </span>
        <xsl:text> </xsl:text>
        <span class="gloss">
            <xsl:value-of select="@gloss"/>
        </span>
    </xsl:template>
    <xsl:template match="adjective" mode="grammar">
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <!-- ============================================================= -->
        <!-- adj | sh mGsg | младъ young                                   -->
        <!-- Attributes must be specified with parent to maintain order==  -->
        <!-- ============================================================= -->
        <xsl:value-of select="
                $local-categories/@length,
                concat($local-categories/@gender, $local-categories/@case, $local-categories/@number)"
        />
    </xsl:template>
    <xsl:template match="noun" mode="grammar">
        <!-- ============================================================ -->
        <!-- noun s-stem nAsg слово word -->
        <!-- Attributes must be specified with parent to maintain order== -->
        <!-- ============================================================ -->
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <xsl:value-of select="
                concat(@paradigm, '-stem'),
                concat(@gender,
                $local-categories/@case,
                $local-categories/@number)"/>
    </xsl:template>
    <xsl:template match="number" mode="grammar">
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <xsl:value-of select="$abbreviate(@type)"/>
    </xsl:template>
    <xsl:template match="pronoun" mode="grammar">
        <!-- ============================================================ -->
        <!-- pronoun | mApl | вьсь all -->
        <!-- add type after part of speech except for 'all' -->
        <!-- ============================================================ -->
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <xsl:if test="@type ne 'all'">
            <xsl:value-of select="$abbreviate(@type)"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="verb" mode="grammar">
        <!-- ============================================================ -->
        <!-- Both <verb> and <participle>                                 -->
        <!-- ============================================================ -->
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <xsl:choose>
            <xsl:when test="$local-categories/self::participle">
                <!-- ===================================================== -->
                <!-- ppl } mNpl sh pt act | выити go                       -->
                <!-- Attributes with parent to maintain order              -->
                <!-- ===================================================== -->
                <xsl:value-of select="
                        concat(
                        $local-categories/@gender,
                        $local-categories/@case,
                        $local-categories/@number),
                        $local-categories/@length,
                        $local-categories/@tense,
                        $local-categories/@voice
                        "/>
            </xsl:when>
            <xsl:otherwise>
                <!-- ===================================================== -->
                <!-- ppl } mNpl sh pt act | выити go                       -->
                <!-- Attributes with parent to maintain order              -->
                <!-- ===================================================== -->
                <xsl:value-of
                select="concat($local-categories/@person, 
                $local-categories/@number), 
                $local-categories/@tense"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
