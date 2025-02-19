![DEBBIE](Debbie_banner.png)

# DEBBIE Pipeline 

The DEBBIE Pipeline retrieves biomaterials abstracts from PubMed, annotates them using multiple lexical assets (and in particular DEB (The Device, Experimental scaffolds and medical Device ontology) and MESH, and deposits the annotated abstracts in a NoSQL database. DEBBIE is available at https://debbie.bsc.es/search/.  For more information about DEBBIE please visit the documantetion site at https://projectdebbie.github.io/.

## Description 

The pipeline orchestrates the execution of the following components (some of them are in separate GitHub repositories):
1. Periodic retrieval of abstracts from PubMed.
2. Standardization of abstract text.
3. Multiclass classification of abstracts using the DEBBIE_BioBERT model to determine their relevance to the biomaterials domain.
4. Ontology-based concept annotation of biomaterials-related text using the Biomaterials Annotator.
5. Deposition of annotated data in the DEBBIE Database.

## Actual Version: 2.0.0, 2022-12-12

## Pipeline overview 
![DEBBIE](Pipeline_overview.png)

## To run the pipeline.  

Open the run.sh file and configure the corresponding parameters when needed.
Then to run the pipeline simple execute **bash run.sh**

## Built With

* [Docker](https://www.docker.com/) - Docker Containers
* [Maven](https://maven.apache.org/) - Dependency Management

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ProjectDebbie/DEBBIE_pipeline/tags). 

## Authors

* **Javier Corvi** - **Austin McKitrick** - **Osnat Hakimi**

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE Version 3 - see the [LICENSE](LICENSE) file for details

## Citing
 * Corvi, J. O., McKitrick, A., Fernández, J. M., Fuenteslópez, C. V., Gelpí, J. L., Ginebra, M. P., Capella-Gutierrez, S., & Hakimi, O. (2023). DEBBIE: The Open Access Database of Experimental Scaffolds and Biomaterials Built Using an Automated Text Mining Pipeline. Advanced healthcare materials, 12(25), e2300150. https://doi.org/10.1002/adhm.202300150

* Corvi, J., Fuenteslópez, C., Fernández, J., Gelpi, J., Ginebra, M.-P., Capella-Guitierrez, S., Hakimi, O. The biomaterials annotator: a systemfor ontology-based concept annotation of biomaterials text. In:Proceedings of the Second Workshop on Scholarly DocumentProcessing, pp. 36–48. Association for Computational Linguistics,Online (2021). https://www.aclweb.org/anthology/2021.sdp-1.5

* Hakimi, O., Gelpi, J., Krallinger, M., Curi, F., Repchevsky, D., Ginebra, M.-P. The devices, experimental scaffolds, and biomaterials ontology (deb): A tool for mapping, annotation, and analysis of biomaterials’ data. Adv. Funct. Mater. (2020)


## Funding
<img align="left" width="75" height="50" src="eu_emblem.png"> This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Sklodowska-Curie grant agreement No 751277


	
		
