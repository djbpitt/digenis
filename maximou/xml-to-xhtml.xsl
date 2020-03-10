<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="3.0">
    <!-- ================================================================ -->
    <!-- Title: xml-to-xhtml.xsl                                          -->
    <!-- Author: djbpitt@gmail.com                                        -->
    <!-- License: CC-BY                                                   -->
    <!--                                                                  -->
    <!-- Synopsis: Convert Maximou XML files to HTML .inc files for SSI   -->
    <!--   inclusion into main Maximou page. Converts anchor references   -->
    <!--   to actionable HTML links                                       -->
    <!--                                                                  -->
    <!-- Run with: saxon -x:xxx.xml -xsl:xml-to-xhtml.xsl -o:xxx.inc      -->
    <!--   replacing "xxx" with abduction, alexander, emperor, maximou,   -->
    <!--   maximouG                                                       -->
    <!-- ================================================================ -->
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

    <!-- ================================================================ -->
    <!-- Functions                                                        -->
    <!-- ================================================================ -->
    <xsl:function name="djb:process_pointer" as="xs:string">
        <!-- ============================================================ -->
        <!-- djb:process_pointer                                          -->
        <!-- Synopsis: Construct pointer for linking                      -->
        <!--                                                              -->
        <!-- Parameters                                                   -->
        <!--   input as attribute(): contains string basis for pointer    -->
        <!--                                                              -->
        <!-- Returns                                                      -->
        <!--   xs:string with semicolon-delimited pointers strings .      -->
        <!-- ============================================================ -->
        <xsl:param name="input" as="attribute()*"/>
        <!--
            @E and @G should have the letter prepended to the number; @c should drop the letter
        -->
        <xsl:sequence
            select="
                string-join(
                for $item in $input
                return
                    (concat(if ($item/name() ne 'c') then
                        $item/name()
                    else
                        '', $item)), '; ')"
        />
    </xsl:function>
    <!-- ================================================================ -->

    <!-- ================================================================ -->
    <!-- Main                                                             -->
    <!-- ================================================================ -->
    <xsl:template match="title">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="title/text()">
        <cite>
            <xsl:value-of select="."/>
        </cite>
    </xsl:template>
    
    <xsl:template match="anchor">
        <div id="{@ref}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="section_title">
        <p class="section_title">
            <xsl:apply-templates/>
            <xsl:if test="p/@E or p/@G">
                <span class="anchor_label">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="djb:process_pointer((p/@E, p/@G))"/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="anchor/p">
        <p>
            <span class="anchor_label">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="substring(../@ref, 2)"/>
                <xsl:text>) </xsl:text>
            </span>
            <xsl:if test="@pageref">
                <span class="page">
                    <xsl:text>[</xsl:text>
                    <xsl:value-of select="@pageref"/>
                    <xsl:text>] </xsl:text>
                </span>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="@E or @G or @c">
                <span class="anchor_label">
                    <xsl:text> [</xsl:text>
                    <xsl:value-of select="djb:process_pointer((@E, @G, @c))"/>
                    <xsl:text>]</xsl:text>
                </span>
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="page">
        <span class="page">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>] </xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="g"/>
    <!--<xsl:template match="g">
        <strong>[Grottaferrata text will be inserted here]</strong>
    </xsl:template>-->
</xsl:stylesheet>
