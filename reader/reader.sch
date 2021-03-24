<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:pattern>
        <sch:rule context="gloss">
            <sch:assert test="preceding-sibling::node()[1][self::text()][matches(., ';\s')]">Gloss
                should be preceded by semicolon inside note</sch:assert>
        </sch:rule>
        <sch:rule context="note[preceding-sibling::reg eq 'сѧ']">
            <sch:assert test=". eq parent::w/preceding-sibling::w/note">Notes on сѧ verbs must be
                repeated on the verb and on the сѧ.</sch:assert>
        </sch:rule>
        <sch:rule context="rec">
            <sch:report test="contains(., 'й')">The reconstructed form must not contain the
                letterform й (write и instead).</sch:report>
            <sch:report test="contains(., 'я')">The reconstructed form must not contain the
                letterform я (replace with ꙗ or ѧ).</sch:report>
            <sch:report test="matches(., '^е')">The reconstructed form must not contain initial е
                (replace with ѥ).</sch:report>
            <sch:report test="matches(., '[аеыоуꙋꙗѧѥию]е')">The reconstructed form must not contain
                е after a vowel letter (replace with ѥ).</sch:report>
            <sch:report test="matches(., '^[уꙋ]')">The reconstructed form must not contain initial у
                or ꙋ (replace with оу or ю).</sch:report>
            <sch:report test="matches(., '.[^о]у')">The reconstructed form must not contain the
                letterform у internally (write ꙋ or ю).</sch:report>
            <sch:report test="matches(., '[шжчщц][ꙗ]')">The reconstructed form must not contain the
                letterform ꙗ after palatals (write а instead).</sch:report>
            <sch:report test="matches(., '[шжчщц]ѥ')">The reconstructed form must not contain the
                letterform ѥ after palatals (write е instead).</sch:report>
            <sch:report test="matches(., '[шжчщц]ю')">The reconstructed form must not contain the
                letterform ю after palatals (write ꙋ instead).</sch:report>
            <sch:report test="matches(., '[шжчщц]ы')">The reconstructed form must not contain the
                letterform ы after palatals (write и instead).</sch:report>
            <sch:report test="matches(., '[a-zA-Z]')">The reconstructed form must not contain
                Latin-alphabet letters.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>
