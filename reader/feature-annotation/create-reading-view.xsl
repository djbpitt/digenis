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
                    'demonstrative': 'dem',
                    'a': 'a',
                    'ja': 'jā',
                    'o': 'o',
                    'jo': 'jo',
                    'i': 'ĭ',
                    'u': 'ŭ',
                    's': 's',
                    'r': 'r',
                    'n': 'n',
                    'nt': 'nt',
                    't': 't',
                    'u-long': 'ū'
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
            <div id="controls">
                <p>Menu</p>
                <div>
                    <h2>Highlight forms</h2>
                    <ul>
                        <li>
                            <label><input type="radio" id="adjective" name="highlight"/>Adjectives,
                                all</label>
                            <ul>
                                <li>
                                    <label><input type="radio" id="poss_adj" name="highlight"
                                        />Adjectives, possessive</label>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <label><input type="radio" id="noun" name="highlight"/>Nouns,
                                all</label>
                            <ul>
                                <li>
                                    <label><input type="radio" id="jo-ja" name="highlight"/>Nouns,
                                        jo- and jā-stem</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="minor" name="highlight"/>Nouns:
                                        ĭ-, ŭ-, and consonant-stem</label>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <label><input type="radio" id="verb" name="highlight"/>Verbs,
                                all</label>
                            <ul>
                                <li>
                                    <label><input type="radio" id="pt" name="highlight"/>Verbs,
                                        simple past</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="pf" name="highlight"/>Verbs,
                                        Perfect and subjunctive</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="I" name="highlight"/>Verbs, Class
                                        1</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="IV" name="highlight"/>Verbs,
                                        Class 4</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="V" name="highlight"/>Verbs, Class
                                        5</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="participle" name="highlight"
                                        />Verbs, Participles</label>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <label><input type="radio" id="pronoun" name="highlight"/>Pronouns,
                                all</label>
                            <ul>
                                <li>
                                    <label><input type="radio" id="pers" name="highlight"/>Pronouns,
                                        personal</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="poss_pron" name="highlight"
                                        />Pronouns, possessive</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="dem" name="highlight"/>Pronouns,
                                        demonstrative</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="interrog" name="highlight"
                                        />Pronouns, interrogative</label>
                                </li>
                                <li>
                                    <label><input type="radio" id="rel" name="highlight"/>Pronouns,
                                        relative</label>
                                </li>
                            </ul>
                        </li>
                        <li>
                            <label><input type="radio" id="adverb" name="highlight"/>Adverbs,
                                all</label>
                        </li>
                        <li>
                            <label><input type="radio" id="number" name="highlight"/>Numerals,
                                all</label>
                        </li>
                        <li>
                            <label><input type="radio" id="dual" name="highlight"/>Duals,
                                all</label>
                        </li>
                        <li>
                            <label><input type="radio" id="none" name="highlight" checked="checked"
                                />None</label>
                        </li>
                    </ul>
                </div>
            </div>
            <!--<p><span class="note">Pink</span> = mouse over for annotation; <span class="diff"
                    >blue</span> = reconstruction differs from manuscript</p>-->
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
        </footer>
    </xsl:template>
    <xsl:template match="p">
        <div class="p">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="w">
        <!-- Add class values for the following: 
        adjective: Adjectives, all
        poss and adjective: Adjectives, possessive
        noun: Nouns, all
        jo,jā: Nouns, jo- and jā-stem
        ĭ, ŭ, s, r, n, t, nt, ū: Nouns: ĭ-, ŭ-, and consonant-stem
        verb: Verbs, all
        p: Verbs, simple past
        pf, pf_neg, cond: Verbs, Perfect and subjunctive
        I: Verbs, Class 1
        IVA, IVB: Verbs, Class 4
        V: Verbs, Class 5
        participle: Verbs, Participles
        pronoun: Pronouns, all
        pers: Pronouns, personal
        poss and pronoun: Pronouns, possessive
        dem: Pronouns, demonstrative
        interrog: Pronouns, interrogative
        rel: Pronouns, relative
        adverb: Adverbs, all
        number: Numerals, all
        du: Duals, all
        -->
        <div>
            <xsl:attribute name="class" select="
                    string-join(('w',
                    rec/* ! name(),
                    (if (rec/*/@number eq 'du') then (: dual :)
                        'du'
                    else
                        ()),
                    rec/*[self::pronoun]/@type (: pronoun type :),
                    key('lexemeByLemmaAndName', (rec/*/@lemma, rec/*/name()), $all-words)/@poss (: possessive adjective :),
                    key('lexemeByLemmaAndName', (rec/*/@lemma, rec/*/name()), $all-words)/@paradigm (: noun paradigm :),
                    key('lexemeByLemmaAndName', (rec/*/@lemma,
                    if (rec/*[self::participle]) then
                        'verb'
                    else
                        rec/*/name()), $all-words)/@class (: verb  (including participle)class :),
                    rec/*/@tense ! translate(., ' ', '_') (: verb tense; fix space in 'pf neg', 'impf aor' :),
                    (if (note) then (: is there an annotation for pop-up? :)
                        ' note'
                    else
                        ())), ' ')"/>
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
        <!-- ============================================================= -->
        <xsl:value-of select="
                $local-categories/@length,
                $local-categories ! concat(@gender, @case, @number)"/>
    </xsl:template>
    <xsl:template match="noun" mode="grammar">
        <!-- ============================================================ -->
        <!-- noun s-stem nAsg слово word -->
        <!-- ============================================================ -->
        <xsl:param name="local-categories" required="yes" tunnel="yes"/>
        <xsl:value-of select="
                concat($abbreviate(@paradigm), '-stem'),
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
        <xsl:choose>
            <xsl:when test="@type eq 'poss'">
                <xsl:value-of select="'poss-adj'"/>
            </xsl:when>
            <xsl:when test="@type ne 'all'">
                <xsl:value-of select="$abbreviate(@type)"/>
            </xsl:when>
        </xsl:choose>
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
                <!-- ===================================================== -->
                <xsl:value-of select="
                        $local-categories ! (
                        concat(@gender, @case, @number),
                        @length,
                        @tense,
                        @voice
                        )"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- ===================================================== -->
                <!-- ppl } mNpl sh pt act | выити go                       -->
                <!-- ===================================================== -->
                <xsl:value-of select="
                        $local-categories ! (
                        concat(@person, @number),
                        @tense
                        )"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
