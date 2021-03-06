<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/2000/svg" version="2.0">
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:variable name="xvii" as="document-node()" select="document('xvii.xml')"/>
    <xsl:variable name="xviiCount" as="xs:integer" select="count($xvii//anchor)"/>
    <xsl:variable name="xiv" as="document-node()" select="document('xiv.xml')"/>
    <xsl:variable name="xivCount" as="xs:integer" select="count($xiv//anchor)"/>
    <xsl:variable name="coreValues" as="xs:string+"
        select="
            'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j',
            for $i in 1 to 75
            return
                string($i)"/>
    <xsl:variable name="coreCount" as="xs:integer" select="count($coreValues)"/>
    <xsl:key name="xviiByRef" match="anchor" use="replace(@ref, '=.*', '')"/>
    <xsl:key name="xivByRef" match="anchor" use="replace(@ref, '=.*', '')"/>
    <xsl:template match="/">
        <svg width="100%" height="230px">
            <g transform="translate(0,-10)">
                <g id="svg_xvii">
                    <text x="0.5%" y="20" font-weight="700">xvii</text>
                    <xsl:for-each select="$xvii//anchor">
                        <xsl:variable name="render" as="xs:string" select="replace(@ref, '=.*', '')"/>
                        <xsl:variable name="xPos" as="xs:string"
                            select="concat(((position() + 1) div $xivCount) * 97, '%')"/>
                        <text id="{concat('svgxvii_',$render)}" class="{$render}"
                            text-anchor="middle" x="{$xPos}" y="20">
                            <tspan>
                                <xsl:choose>
                                    <xsl:when test="contains($render, 'bis')">
                                        <tspan>
                                            <xsl:value-of select="substring-before($render, 'bis')"
                                            />
                                        </tspan>
                                        <tspan dy="-6" font-size="60%">2</tspan>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tspan>
                                            <xsl:value-of select="$render"/>
                                        </tspan>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </tspan>
                        </text>
                    </xsl:for-each>
                </g>
                <g id="svg_xiv">
                    <text x="0.5%" y="120" font-weight="700">xiv</text>
                    <xsl:for-each select="$xiv//anchor">
                        <xsl:variable name="render" as="xs:string" select="replace(@ref, '=.*', '')"/>
                        <xsl:variable name="xPos" as="xs:string"
                            select="concat(((position() + 1) div $xivCount) * 97, '%')"/>
                        <text id="{concat('svgxiv_',$render)}" class="{$render}"
                            text-anchor="middle" x="{$xPos}" y="120">
                            <tspan>
                                <xsl:choose>
                                    <xsl:when test="contains($render, 'bis')">
                                        <tspan>
                                            <xsl:value-of select="substring-before($render, 'bis')"
                                            />
                                        </tspan>
                                        <tspan dy="-6" font-size="60%">2</tspan>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <tspan>
                                            <xsl:value-of select="$render"/>
                                        </tspan>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </tspan>
                        </text>
                    </xsl:for-each>
                </g>
                <g id="svg_xvii_lines">
                    <xsl:for-each select="$xiv//anchor">
                        <xsl:variable name="render" as="xs:string" select="replace(@ref, '=.*', '')"/>
                        <xsl:variable name="xPos" as="xs:string"
                            select="concat(((position() + 1) div $xivCount) * 97, '%')"/>
                        <xsl:if test="key('xviiByRef', $render, $xvii)">
                            <xsl:variable name="xviiMatch" as="element(anchor)"
                                select="key('xviiByRef', $render, $xvii)"/>
                            <xsl:variable name="xviiXPos" as="xs:string"
                                select="concat(((count($xviiMatch/preceding-sibling::anchor) + 2) div $xviiCount) * 97, '%')"/>
                            <line class="{$render}" x1="{$xPos}" y1="108" x2="{$xviiXPos}" y2="23"
                                stroke="black" stroke-width="1"/>
                        </xsl:if>
                    </xsl:for-each>
                </g>
                <g id="svg_core_lines">
                    <!-- Draw lines and circles before text so that circles won't mask text for clicking-->
                    <xsl:for-each select="$coreValues">
                        <xsl:variable name="siglum" as="xs:string" select="."/>
                        <xsl:variable name="xPos" as="xs:string"
                            select="concat(((position() + 1.5) div $coreCount) * 97, '%')"/>
                        <xsl:variable name="xivMatch" as="element(anchor)*"
                            select="key('xivByRef', ., $xiv) | key('xivByRef', concat(., 'bis'), $xiv)"/>
                        <xsl:choose>
                            <xsl:when test="count($xivMatch) gt 0">
                                <xsl:for-each select="$xivMatch">
                                    <xsl:variable name="xivXPos" as="xs:string"
                                        select="concat(((count(preceding-sibling::anchor) + 2) div $xivCount) * 97, '%')"/>
                                    <line class="{$siglum}" x1="{$xPos}" y1="208" x2="{$xivXPos}"
                                        y2="123" stroke="black" stroke-width="1"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <circle class="{$siglum}" cx="{$xPos}" cy="217" r="8" stroke="black"
                                    stroke-width="1" fill-opacity="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </g>
                <g id="svg_core">
                    <text x="0.5%" y="220" font-weight="700">core</text>
                    <xsl:for-each select="$coreValues">
                        <xsl:variable name="xPos" as="xs:string"
                            select="concat(((position() + 1.5) div $coreCount) * 97, '%')"/>
                        <text id="{concat('svgcore_',.)}" class="{.}" text-anchor="middle"
                            x="{$xPos}" y="220">
                            <tspan>
                                <xsl:value-of select="."/>
                            </tspan>
                        </text>
                    </xsl:for-each>
                </g>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
