<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
  xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
  <sch:pattern>
    <sch:rule context="@paradigm[. = ('o', 'jo')]">
      <sch:report test="../@gender eq 'f'">Nouns of class <sch:value-of select="@paradigm"/> are all
        either masculine or neuter"/></sch:report>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('a', 'ja')]">
      <sch:report test="../@gender eq 'n'">Nouns of class <sch:value-of select="@paradigm"/> are all
        either feminine or masculine"/></sch:report>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('i')]">
      <sch:report test="../@gender eq 'n'">Nouns of class <sch:value-of select="@paradigm"/> are all
        either masculine or feminine"/></sch:report>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('t', 'u')]">
      <sch:assert test="../@gender eq 'm'">Nouns of class <sch:value-of select="@paradigm"/> are all
        masculine"/></sch:assert>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('n')]">
      <sch:report test="../@gender eq 'f'">Nouns of class <sch:value-of select="@paradigm"/> are all
        either masculine or neuter"/></sch:report>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('s', 'nt')]">
      <sch:assert test="../@gender eq 'n'">Nouns of class <sch:value-of select="@paradigm"/> are all
        neuter"/></sch:assert>
    </sch:rule>
    <sch:rule context="@paradigm[. = ('r', 'u-long')]">
      <sch:assert test="../@gender eq 'f'">Nouns of class <sch:value-of select="@paradigm"/> are all
        feminine"/></sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
