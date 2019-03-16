#!/usr/bin/env bash
echo "Processing abduction"
saxon -o:abduction.inc -s:abduction.xml -xsl:xml-to-xhtml.xsl
echo "Processing maximou"
saxon -o:maximou.inc -s:maximou.xml -xsl:xml-to-xhtml.xsl
echo "Processing emperor"
saxon -o:emperor.inc -s:emperor.xml -xsl:xml-to-xhtml.xsl
echo "Processing alexander"
saxon -o:alexander.inc -s:alexander.xml -xsl:xml-to-xhtml.xsl
echo "Processing maximouG"
saxon -o:maximouG.inc -s:maximouG.xml -xsl:xml-to-xhtml.xsl
echo "Processing plectograms"
saxon -s:harmony.xml -xsl:create_plectogram.xsl
