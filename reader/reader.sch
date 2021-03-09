<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="gloss">
            <sch:assert test="preceding-sibling::node()[1][self::text()][matches(., ';\s')]">Gloss
                should be preceded by semicolon inside note</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>
