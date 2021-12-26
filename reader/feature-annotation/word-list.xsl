<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns="http://www.w3.org/1999/xhtml" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="#all" version="3.0">
  <!-- ================================================================== -->
  <!-- Create frequency list of all lexemes                               -->
  <!-- Report lemma, frequency, part of speech, gloss                     -->
  <!-- Run from command line with EE and -config:ee-package-config.xml    -->
  <!-- ================================================================== -->

  <!-- ================================================================== -->
  <!-- Housekeeping                                                       -->
  <!-- ================================================================== -->
  <xsl:use-package name="http://www.obdurodon.org/digenis-functions" version="1.0"/>
  <xsl:output method="xhtml" html-version="5" omit-xml-declaration="no" include-content-type="no"
    indent="yes"/>

  <!-- ================================================================== -->
  <!-- Stylesheet variables                                               -->
  <!-- ================================================================== -->
  <xsl:variable name="all-words" as="document-node()">
    <xsl:document>
      <!-- ============================================================== -->
      <!-- Merge into one document for key                                -->
      <!-- ============================================================== -->
      <xsl:sequence select="collection('lexemes?select=*.xml')"/>
    </xsl:document>
  </xsl:variable>

  <!-- ================================================================== -->
  <!-- Keys                                                               -->
  <!-- ================================================================== -->
  <xsl:key name="lexemeByLemmaAndName" match="*" use="@lemma, name()" composite="yes"/>

  <!-- ================================================================== -->
  <!-- Main                                                               -->
  <!-- ================================================================== -->
  <xsl:template match="/">
    <html>
      <head>
        <title>Word list: reading #1</title>
        <link rel="stylesheet" type="text/css" href="http://www.obdurodon.org/css/style.css"/>
        <style type="text/css">
          td:nth-child(2) {
            text-align: right;
          }</style>
      </head>
      <body>
        <h1>Word list: reading #1</h1>
        <table>
          <tr>
            <th>Lemma</th>
            <th>Frequency</th>
            <th>Part of speech</th>
            <th>Class</th>
            <th>Gloss</th>
          </tr>
          <!-- ========================================================== -->
          <!-- Composite key on lemma and part of speech                  -->
          <!-- Key value 1 is lemma, 2 is part of speech (from gi)        -->
          <!-- Participles are <participle> in text, but use <verb> list  -->
          <!-- ========================================================== -->
          <xsl:for-each-group select="//rec/*" group-by="
              @lemma,
              if (name() eq 'participle') then
                'verb'
              else
                name()" composite="yes">
            <!-- ======================================================== -->
            <!-- Descending frequency, then subsort alphabetically        -->
            <!-- TODO: Fix early Cyrillic sort order                      -->
            <!-- ======================================================== -->
            <xsl:sort select="count(current-group())" order="descending"/>
            <xsl:sort select="current-grouping-key()[1] ! djb:sort-os(.)"/>
            <tr>
              <td>
                <xsl:value-of select="current-grouping-key()[1]"/>
                <xsl:if test="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@pl3">
                  <xsl:value-of
                    select="' (' || key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@pl3 || ')'"
                  />
                </xsl:if>
              </td>
              <td>
                <xsl:value-of select="count(current-group())"/>
              </td>
              <td>
                <xsl:value-of select="current-grouping-key()[2]"/>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="current-grouping-key()[2] eq 'noun'">
                    <xsl:value-of
                      select="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/(@gender || ' ' || @paradigm || '-stem')"
                    />
                  </xsl:when>
                  <xsl:when test="current-grouping-key()[2] eq 'verb'">
                    <xsl:value-of
                      select="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@class"/>
                    <xsl:if
                      test="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@irreg">
                      <xsl:value-of select="' (irreg.)'"/>
                    </xsl:if>
                  </xsl:when>
                  <xsl:when test="current-grouping-key()[2] = ('pronoun', 'number')">
                    <xsl:value-of
                      select="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@type"
                    />
                  </xsl:when>
                  <xsl:otherwise>&#xa0;</xsl:otherwise>
                </xsl:choose>
              </td>
              <td>
                <!-- ==================================================== -->
                <!-- Retrieve gloss from composite lexicon                -->
                <!-- ==================================================== -->
                <xsl:value-of
                  select="key('lexemeByLemmaAndName', current-grouping-key(), $all-words)/@gloss"/>
              </td>
            </tr>
          </xsl:for-each-group>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
