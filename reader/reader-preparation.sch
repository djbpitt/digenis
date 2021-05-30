<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="p">
            <sch:assert test="string-length(normalize-space(.)) ne 0">Paragraphs cannot be
                empty</sch:assert>
            <sch:assert test="not(starts-with(., ' '))">Paragraphs cannot start with
                spaces</sch:assert>
            <sch:assert test="not(ends-with(., ' '))">Paragraphs cannot end in spaces</sch:assert>
            <sch:report test="contains(., '[') or contains(., ']')">Paragraphhs cannot contain
                square brackets</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>
