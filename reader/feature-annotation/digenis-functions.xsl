<?xml version="1.0" encoding="UTF-8"?>
<xsl:package name="http://www.obdurodon.org/digenis-functions" package-version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:djb="http://www.obdurodon.org" xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math" version="3.0">
  <!-- ================================================================== -->
  <!-- Public (final):                                                    -->
  <!--                                                                    -->
  <!-- norm-for-diff: helper function, normalizes for diff                -->
  <!-- norm-diff : compares Cyrillic stricts with normalization           -->
  <!-- sort-os : remaps Cyrillic for use in sort key                      -->
  <!-- ================================================================== -->

  <xsl:variable name="os-norm" as="map(xs:string, xs:integer)" visibility="private">
    <xsl:map>
      <!-- оу is initial only; у never appears except in оу -->
      <!-- Preprocess оу to convert to ꙋ so that /u/ sorts together -->
      <!-- Order from Cejtlin 55–56; omit ѕ, ꙁ ꙇ, ї, ѡ, ѫ, ѭ, ѯ, ѱ, ѳ, у  -->
      <!-- а б в г д е ж з и к л м н о п р с т (оу) ꙋ ф х щ ц ч ш ъ ы ь ѣ ю ꙗ ѥ ѧ ѩ -->
      <xsl:map-entry key="' '" select="0"/>
      <xsl:map-entry key="'а'" select="1"/>
      <xsl:map-entry key="'б'" select="2"/>
      <xsl:map-entry key="'в'" select="3"/>
      <xsl:map-entry key="'г'" select="4"/>
      <xsl:map-entry key="'д'" select="5"/>
      <xsl:map-entry key="'е'" select="6"/>
      <xsl:map-entry key="'ж'" select="7"/>
      <xsl:map-entry key="'з'" select="8"/>
      <xsl:map-entry key="'и'" select="9"/>
      <xsl:map-entry key="'к'" select="10"/>
      <xsl:map-entry key="'л'" select="11"/>
      <xsl:map-entry key="'м'" select="12"/>
      <xsl:map-entry key="'н'" select="13"/>
      <xsl:map-entry key="'о'" select="14"/>
      <xsl:map-entry key="'п'" select="15"/>
      <xsl:map-entry key="'р'" select="16"/>
      <xsl:map-entry key="'с'" select="17"/>
      <xsl:map-entry key="'т'" select="18"/>
      <xsl:map-entry key="'ꙋ'" select="19"/>
      <xsl:map-entry key="'ф'" select="22"/>
      <xsl:map-entry key="'х'" select="23"/>
      <xsl:map-entry key="'щ'" select="24"/>
      <xsl:map-entry key="'ц'" select="25"/>
      <xsl:map-entry key="'ч'" select="26"/>
      <xsl:map-entry key="'ш'" select="27"/>
      <xsl:map-entry key="'ъ'" select="28"/>
      <xsl:map-entry key="'ы'" select="29"/>
      <xsl:map-entry key="'ь'" select="30"/>
      <xsl:map-entry key="'ѣ'" select="31"/>
      <xsl:map-entry key="'ю'" select="32"/>
      <xsl:map-entry key="'ꙗ'" select="33"/>
      <xsl:map-entry key="'ѥ'" select="34"/>
      <xsl:map-entry key="'ѧ'" select="35"/>
      <xsl:map-entry key="'ѩ'" select="36"/>
    </xsl:map>
  </xsl:variable>
  <xsl:function name="djb:norm-for-diff" as="xs:string" visibility="private">
    <!-- ================================================================ -->
    <!-- Normalize pldr and rec for diff                                  -->
    <!-- я ѧ ꙗ, е ѥ, й и, у оу  ꙋ, final ъ                                -->
    <!-- ================================================================ -->
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="replace($input, 'оу', 'ꙋ') ! 
      translate(., 'ѧꙗѩѥйу', 'яяяеиꙋ') ! 
      replace(.,'\P{L}','') !
      replace(., 'ъ$', '')"/>
  </xsl:function>
  <xsl:function name="djb:norm-diff" as="xs:boolean" visibility="final">
    <!-- ================================================================ -->
    <!-- Compare normalized pldr and rec after normalization              -->
    <!-- Uses djb:norm-for-diff() to normalize                            -->
    <!-- ================================================================ -->
    <xsl:param name="pldr" as="xs:string"/>
    <xsl:param name="rec" as="xs:string"/>
    <xsl:sequence select="djb:norm-for-diff($pldr) eq djb:norm-for-diff($rec)"/>
  </xsl:function>
  <xsl:function name="djb:sort-os" as="xs:string" visibility="final">
    <!-- ================================================================ -->
    <!-- Remap early Cyrillic input to sort correctly                     -->
    <!-- Arbitrarily add 100 to avoid prohibited control characters       -->
    <!-- ================================================================ -->
    <xsl:param name="input" as="xs:string"/>
    <xsl:sequence select="
        ((replace($input, 'оу', 'ꙋ') =>
        analyze-string('.'))/* !
        $os-norm(.)) !
        codepoints-to-string(. + 100) =>
        string-join(',')"/>
  </xsl:function>
</xsl:package>
