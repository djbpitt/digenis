#!/usr/bin/env bash
echo "Processing abduction"
java -jar /opt/saxon/saxon9he.jar -o:abduction.inc -s:abduction.xml -xsl:xml-to-xhtml.xsl
echo "Processing maximou"
java -jar /opt/saxon/saxon9he.jar -o:maximou.inc -s:maximou.xml -xsl:xml-to-xhtml.xsl
echo "Processing emperor"
java -jar /opt/saxon/saxon9he.jar -o:emperor.inc -s:emperor.xml -xsl:xml-to-xhtml.xsl
echo "Processing alexander"
java -jar /opt/saxon/saxon9he.jar -o:alexander.inc -s:alexander.xml -xsl:xml-to-xhtml.xsl
echo "Processing maximouG"
java -jar /opt/saxon/saxon9he.jar -o:maximouG.inc -s:maximouG.xml -xsl:xml-to-xhtml.xsl
echo "Processing plectograms"
java -jar /opt/saxon/saxon9he.jar -s:harmony.xml -xsl:create_plectogram.xsl
