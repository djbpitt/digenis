for f in *-annotated.xml
do
    outfile=$(echo $f | sed -e 's/-annotated.xml/.xhtml/')
    echo "Processing $f"
    java -jar /opt/saxon/he/saxon-he-10.5.jar -s:$f -xsl:create-reading-view.xsl -o:$outfile
done
