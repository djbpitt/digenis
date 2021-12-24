<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <sch:let name="verbs" value="doc('verbs.xml')"/>
    <sch:let name="nouns" value="doc('nouns.xml')"/>
    <sch:let name="particles" value="doc('particles.xml')"/>
    <sch:let name="pronouns" value="doc('pronouns.xml')"/>
    <sch:let name="adverbs" value="doc('adverbs.xml')"/>
    <sch:let name="adjectives" value="doc('adjectives.xml')"/>
    <sch:let name="conjunctions" value="doc('conjunctions.xml')"/>
    <sch:let name="prepositions" value="doc('prepositions.xml')"/>
    <sch:pattern>
        <sch:rule context="verb | ppl">
            <sch:assert test="@lemma = $verbs//@inf">Verb <sch:value-of select="@lemma"/> is not in
                master verb list</sch:assert>
        </sch:rule>
        <sch:rule context="noun">
            <sch:assert test="@lemma = $nouns//@lemma">Noun <sch:value-of select="@lemma"/> is not
                in master noun list</sch:assert>
        </sch:rule>
        <sch:rule context="particle">
            <sch:assert test="@lemma = $particles//@lemma">Particle <sch:value-of select="@lemma"/>
                is not in master list of particles</sch:assert>
        </sch:rule>
        <sch:rule context="pronoun">
            <sch:assert test="@lemma = $pronouns[@lemma]">Pronoun <sch:value-of select="@lemma"/> is
                not in master list of pronouns</sch:assert>
        </sch:rule>
        <sch:rule context="adv">
            <sch:assert test="@lemma = $adverbs//@lemma">Adverb <sch:value-of select="@lemma"/> is
                not in master list of adverbs</sch:assert>
        </sch:rule>
        <sch:rule context="conj">
            <sch:assert test="@lemma = $conjunctions//@lemma">Conjunction <sch:value-of
                    select="@lemma"/> is not in master list of conjunctions</sch:assert>
        </sch:rule>
        <sch:rule context="prep">
            <sch:assert test="@lemma = $prepositions//@lemma">Preposition <sch:value-of
                    select="@lemma"/> is not in master list of prepositions</sch:assert>
        </sch:rule>
        <sch:rule context="adj">
            <sch:assert test="@lemma = $adjectives//@lemma">Adjective <sch:value-of select="@lemma"
                /> is not in master list of adjectives</sch:assert>
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
            <sch:report test="matches(., '^ѧ')">The reconstructed form must not contain initial ѧ
                (replace with ѩ).</sch:report>
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
            <sch:report test="matches(., '[шжчщц]ъ')">The reconstructed form must not contain a back
                jer after a palatal (write ь instead).</sch:report>
            <sch:report test="matches(., '[a-zA-Z]')">The reconstructed form must not contain
                Latin-alphabet letters.</sch:report>
            <sch:report
                test="matches(., '[бвгдзжклмнпрстфхцчшщ]$') and not(. = ('без', 'бес', 'из', 'ис'))"
                >The only words that can end in consonants are без, бес, из, and ис.</sch:report>
            <sch:report test="matches(., '[кгх]и')">Velar consonants cannot be followed by и;
                replace with ы.</sch:report>
            <sch:report role="warning" test="matches(., '[аеыоуѧѩѥꙋиюꙗ][аѧе]')">Plain (non-jotated)
                vowels should not follow vowel letters except at hiatus.</sch:report>
            <sch:report test=". eq 'дабы'">Да бы is two words.</sch:report>
        </sch:rule>
    </sch:pattern>
</sch:schema>
