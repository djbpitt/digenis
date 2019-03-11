<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" xmlns="http://www.w3.org/2000/svg" version="2.0">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:key name="mappingByChild" match="mapping" use="*"/>
    <xsl:variable name="root" as="document-node()" select="/"/>
    <!-- Run against harmony.xml -->
    <xsl:function name="djb:associates" as="xs:string?">
        <xsl:param name="ref"/>
        <xsl:sequence
            select="
                string-join(for $i in distinct-values(key('mappingByChild', $ref, $root)/*)
                return
                    ($i, concat('p', $i)), ' ')"
        />
    </xsl:function>
    <xsl:function name="djb:process_row" as="node()+">
        <xsl:param name="refs"/>
        <xsl:param name="label"/>
        <xsl:variable name="ref_count" as="xs:integer" select="count($refs)"/>
        <text x="-10" y="0" font-weight="bold">
            <xsl:sequence select="$label"/>
        </text>
        <xsl:for-each select="$refs">
            <!-- @class is all values paired for @ref in harmony.xml, with and without 'p' -->
            <xsl:variable name="associates" as="xs:string*" select="djb:associates(.)"/>
            <text id="{concat('p',.)}" class="{$associates}"
                x="{position() div $ref_count * $xScale}%" y="0" text-anchor="middle">
                <xsl:value-of select="substring(., 2)"/>
            </text>
        </xsl:for-each>
    </xsl:function>
    <xsl:variable name="input_abduction" as="document-node()" select="document('abduction.xml')"/>
    <xsl:variable name="input_maximou" as="document-node()" select="document('maximou.xml')"/>
    <xsl:variable name="input_emperor" as="document-node()" select="document('emperor.xml')"/>
    <xsl:variable name="input_alexander" as="document-node()" select="document('alexander.xml')"/>
    <xsl:variable name="input_maximouG" as="document-node()" select="document('maximouG.xml')"/>
    <xsl:variable name="xShift" as="xs:double" select="20"/>
    <xsl:variable name="xScale" as="xs:double" select="97"/>
    <xsl:template match="/">
        <xsl:result-document href="maximou_plectogram_ae.svg" method="xml" indent="yes"
            omit-xml-declaration="yes">
            <svg height="230px" width="100%">
                <g transform="translate(0, -10)">
                    <g id="plectogram_abduction" transform="translate({$xShift},20)">
                        <xsl:sequence select="djb:process_row($input_abduction//anchor/@ref, 'abd')"
                        />
                    </g>
                    <g id="plectogram_maximou" transform="translate({$xShift}, 120)">
                        <xsl:sequence select="djb:process_row($input_maximou//anchor/@ref, 'mxs')"/>
                    </g>
                    <g id="plectogram_emperor" transform="translate({$xShift},220)">
                        <xsl:sequence select="djb:process_row($input_emperor//anchor/@ref, 'emp')"/>
                    </g>
                    <g id="lines_maximou-abduction" transform="translate({$xShift},0)">
                        <!-- $max_refs is labels in m plectogram row -->
                        <xsl:variable name="max_refs" as="xs:string+"
                            select="$input_maximou//anchor/@ref"/>
                        <xsl:variable name="max_count" as="xs:integer" select="count($max_refs)"/>
                        <xsl:variable name="abd_refs" as="xs:string+"
                            select="$input_abduction//anchor/@ref"/>
                        <xsl:variable name="abd_count" as="xs:integer" select="count($abd_refs)"/>
                        <xsl:for-each select="//pair[@n = 'ma']//max">
                            <!-- x end is Max; y end is Abd -->
                            <xsl:variable name="maxXPos" as="xs:double"
                                select="index-of($max_refs, .) div $max_count * $xScale"/>
                            <xsl:for-each select="key('mappingByChild', .)/abd">
                                <xsl:variable name="abdXPos" as="xs:double"
                                    select="index-of($abd_refs, .) div $abd_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="108" x2="{$abdXPos}%" y2="23"
                                    class="{djb:associates(.)}" stroke="black" stroke-width="1"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </g>
                    <g id="lines_maximou-emperor" transform="translate({$xShift},0)">
                        <xsl:variable name="max_refs" as="xs:string+"
                            select="$input_maximou//anchor/@ref"/>
                        <xsl:variable name="max_count" as="xs:integer" select="count($max_refs)"/>
                        <xsl:variable name="emp_refs" as="xs:string+"
                            select="$input_emperor//anchor/@ref"/>
                        <xsl:variable name="emp_count" as="xs:integer" select="count($emp_refs)"/>
                        <xsl:for-each select="//pair[@n = 'me']//max">
                            <!-- x end is Max; y end is Emp -->
                            <xsl:variable name="maxXPos" as="xs:double"
                                select="index-of($max_refs, .) div $max_count * $xScale"/>
                            <xsl:for-each select="key('mappingByChild', .)/emp">
                                <xsl:variable name="empXPos" as="xs:double"
                                    select="index-of($emp_refs, .) div $emp_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="123" x2="{$empXPos}%" y2="210"
                                    class="{djb:associates(.)}" stroke="black" stroke-width="1"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </g>
                </g>
            </svg>
        </xsl:result-document>
        <xsl:result-document href="maximou_plectogram_gc.svg" method="xml" indent="yes"
            omit-xml-declaration="yes">
            <svg height="230px" width="100%">
                <g transform="translate(0, -10)">
                    <g id="plectogram_alexander" transform="translate({$xShift},20)">
                        <xsl:sequence select="djb:process_row($input_alexander//anchor/@ref, 'alx')"
                        />
                    </g>
                    <g id="plectogram_maximou" transform="translate({$xShift}, 120)">
                        <xsl:sequence select="djb:process_row($input_maximou//anchor/@ref, 'mxs')"/>
                    </g>
                    <g id="plectogram_maximouG" transform="translate({$xShift},220)">
                        <xsl:sequence select="djb:process_row($input_maximouG//anchor/@ref, 'mxg')"
                        />
                    </g>
                    <g id="lines_maximou-alexander" transform="translate({$xShift},0)">
                        <xsl:variable name="max_refs" as="xs:string+"
                            select="$input_maximou//anchor/@ref"/>
                        <xsl:variable name="max_count" as="xs:integer" select="count($max_refs)"/>
                        <xsl:variable name="cal_refs" as="xs:string+"
                            select="$input_alexander//anchor/@ref"/>
                        <xsl:variable name="cal_count" as="xs:integer" select="count($cal_refs)"/>
                        <xsl:for-each select="//pair[@n = 'mc']//max">
                            <!-- x end is Max; y end is Alx -->
                            <xsl:variable name="maxXPos" as="xs:double"
                                select="index-of($max_refs, .) div $max_count * $xScale"/>
                            <xsl:for-each select="key('mappingByChild', .)/cal">
                                <xsl:variable name="calXPos" as="xs:double"
                                    select="index-of($cal_refs, .) div $cal_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="108" x2="{$calXPos}%" y2="23"
                                    stroke="black" stroke-width="1"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </g>
                    <g id="lines_maximou-maximouG" transform="translate({$xShift},0)">
                        <xsl:variable name="max_refs" as="xs:string+"
                            select="$input_maximou//anchor/@ref"/>
                        <xsl:variable name="max_count" as="xs:integer" select="count($max_refs)"/>
                        <xsl:variable name="mag_refs" as="xs:string+"
                            select="$input_maximouG//anchor/@ref"/>
                        <xsl:variable name="mag_count" as="xs:integer" select="count($mag_refs)"/>
                        <xsl:for-each select="//pair[@n = 'mg']//max">
                            <!-- x end is Max; y end is Mag -->
                            <xsl:variable name="maxXPos" as="xs:double"
                                select="index-of($max_refs, .) div $max_count * $xScale"/>
                            <xsl:for-each select="key('mappingByChild', .)/mag">
                                <xsl:variable name="magXPos" as="xs:double"
                                    select="index-of($mag_refs, .) div $mag_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="123" x2="{$magXPos}%" y2="210"
                                    stroke="black" stroke-width="1"/>
                            </xsl:for-each>
                        </xsl:for-each>
                    </g>
                </g>
            </svg>
        </xsl:result-document>

    </xsl:template>
</xsl:stylesheet>
