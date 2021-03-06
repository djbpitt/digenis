<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:djb="http://www.obdurodon.org" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" xmlns="http://www.w3.org/2000/svg" version="3.0">
    <!-- 
        create_plectogram.xsl
        Description: creates two plectograms for Maximou chapter, Abduction/Emperor and Alexander/Greek
        Input: harmony.xml 
        Output: no stdout; two plectograms are created as result documents
    -->

    <!-- separate keys for the two plectograms -->
    <xsl:key name="mappingsAbdEmp" match="pair[@n = ('ma', 'me')]/mapping" use="*"/>
    <xsl:key name="mappingsCalGrk" match="pair[@n = ('mc', 'mg')]/mapping" use="*"/>
    <xsl:variable name="root" as="document-node()" select="/"/>

    <!-- functions -->
    <xsl:function name="djb:associates" as="xs:string?">
        <!--
            Parameters
                $keyName = 'mappingsAbdEmp' ~ 'mappingsCalGrk'
                $keyRef = @id of plectogram node being plotted (without leading 'p'), e.g., 'e1'
            Returns
                White-space separated sequence of all associated @id values in the specified plectogramm (only)
                Returns text and plectogram identifiers (e.g., 'e1' and 'pe1') even when the latter does not exist
                Returns empty if there is no association
            Note
                Operates transitively, e.g., a click in Abd hits matches in Max and may both bounce back to Abd
                    and flow through the Emp (and bounce back from there)
        -->
        <xsl:param name="keyName" as="xs:string"/>
        <xsl:param name="keyRef" as="xs:string"/>
        <xsl:sequence
            select="
                distinct-values(($keyRef, key($keyName, $keyRef, $root)/*))
                ! (., concat('p', .))
                => distinct-values()
                => string-join(' ')"
        />
    </xsl:function>

    <xsl:function name="djb:process_row" as="node()+">
        <!--
            Parameters
                $refs = sequence of identifiers in plectogram row
                $label = label of plectogram row
            Returns
                sequence of SVG <text> elements, beginning with label (which has no @id or @class)
                    @id = identifier, with 'p' prepended
                    @class = all associated identifiers in the plectogram (but not the other plectogram)
                        with and without 'p' prepended (and, therefore, sometimes vacuously)
            Note
                key is identified from $label and passed into djb:associates()
        -->
        <xsl:param name="refs"/>
        <xsl:param name="label"/>
        <xsl:variable name="ref_count" as="xs:integer" select="count($refs)"/>
        <xsl:variable name="keyName" as="xs:string"
            select="
                if ($label = ('abd', 'emp')) then
                    'mappingsAbdEmp'
                else
                    'mappingsCalGrk'"/>
        <text x="-10" y="0" font-weight="bold">
            <xsl:sequence select="$label"/>
        </text>
        <xsl:for-each select="$refs">
            <!-- @class is all values paired for @ref in just that plectogram, with and without 'p' -->
            <xsl:variable name="associates" as="xs:string*" select="djb:associates($keyName, .)"/>
            <text id="{concat('p',.)}" class="{$associates}"
                x="{position() div $ref_count * $xScale}%" y="0" text-anchor="middle">
                <xsl:value-of select="substring(., 2)"/>
            </text>
        </xsl:for-each>
    </xsl:function>

    <!--
        five input sources, specified individually
            abduction, maximou, emperor
            alexander, maximou, maximouG
        maximou is in both plectograms 
    -->
    <xsl:variable name="input_abduction" as="document-node()" select="document('abduction.xml')"/>
    <xsl:variable name="input_maximou" as="document-node()" select="document('maximou.xml')"/>
    <xsl:variable name="input_emperor" as="document-node()" select="document('emperor.xml')"/>
    <xsl:variable name="input_alexander" as="document-node()" select="document('alexander.xml')"/>
    <xsl:variable name="input_maximouG" as="document-node()" select="document('maximouG.xml')"/>

    <xsl:variable name="xShift" as="xs:double" select="20"/>
    <xsl:variable name="xScale" as="xs:double" select="97"/>

    <xsl:template match="/">
        <!--
            For each plectogram:
                create result document (SVG) with five inner groups
                    three tiers, two sequences of lines
        -->
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
                            <xsl:for-each select="key('mappingsAbdEmp', .)/abd">
                                <xsl:variable name="abdXPos" as="xs:double"
                                    select="index-of($abd_refs, .) div $abd_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="108" x2="{$abdXPos}%" y2="23"
                                    class="{djb:associates('mappingsAbdEmp', .)}" stroke="black"
                                    stroke-width="1"/>
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
                            <xsl:for-each select="key('mappingsAbdEmp', .)/emp">
                                <xsl:variable name="empXPos" as="xs:double"
                                    select="index-of($emp_refs, .) div $emp_count * $xScale"/>
                                <line x1="{$maxXPos}%" y1="123" x2="{$empXPos}%" y2="210"
                                    class="{djb:associates('mappingsAbdEmp', .)}" stroke="black"
                                    stroke-width="1"/>
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
                            <xsl:for-each select="key('mappingsCalGrk', .)/cal">
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
                            <xsl:for-each select="key('mappingsCalGrk', .)/mag">
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
