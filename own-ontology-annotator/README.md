hepatotoxicity-annotation (CDISC and eTOX)
========================

<b>Hepatotoxicity annotator component: Hepatotoxicity, Liver Markers and CYPs genes</b>   

========================

This library annotated text with hepatotoxicity terms related to liver findings, liver markers and CYPs genes that are relevant in hepatotoxicity events.  

It uses data that were obtained in a previous work: The LIMTOX system http://limtox.bioinfo.cnio.es/

<p>Dictionaries used:</p>
<b>Hepatotoxicity keywords:</b> 
<p>Terms related to hepatotoxicity triggers, hepatobiliary triggers  and toxicity/adverse event trigger.</p> 
<b>CYPs protein:</b>
<p>In order to develop a CYPs tagger its necessary to define the search criteria on the Uniprot database to obtain all the CYPs protein family.   For this aim we automatically search the query: “family:cytochrome p450 family taxonomy:eutheria”.  Selecting a taxonomic subset corresponding to Eutheria.  The result is 5,835 proteins.
To increase recall, we applied an automatic expansion of the CYP gene names using manual rules to account for typographical variations: hyphenation, lower and upper case variations, and Roman and Arabic numeric expressions. </p>
 
======================== 

Internally, the hepatotoxicity-annotation library uses the generic nlp-generic-dictionary-annotation https://github.com/inab/docker-textmining-tools/tree/
master/nlp-generic-dictionary-annotation. This library is a generic component that annotate text with parametrices GATE-formatted gazetters/dictionaries. In other words, the hepatotoxicity-annotation library is an instance of the nlp-generic-dictionary-annotation with the hepatotoxicity dictionaries.

========================

Build and run the docker individually

	# To build the docker, just go into the cdisc-etox-annotation folder and execute
	docker build -t cdisc-etox-annotation .
	#To run the docker, just set the input_folder and the output
	mkdir ${PWD}/output_annotation; docker run --rm -u $UID -v ${PWD}/input_folder:/in:ro -v ${PWD}/output_annoation:/out:rw cdisc-etox-annotation cdisc-etox-annotation -i /in -o /out -a MY_SET_NAME	
Parameters:
<p>
-i input folder with the documents to annotated. The documents could be plain txt or xml gate documents.
</p>
<p>
-o output folder with the documents annotated in gate format.
</p>
<p>
-a annotation set output
</p>

		
		
