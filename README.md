# debbie-pipeline 

The debbie automated pipeline retrieves biomaterials abstracts from PubMed, annotates them using multiple lexical assets (and in particular DEB (The Device, Experimental scaffolds and medical Device ontology) and MESH, and deposit the annotated abstracts in a a NoSQL database. The database search page is: debbie.bsc.es/search/. 

## Description 

The pipeline orchestrates the execution of the following components (some of them are in separate repositories of DEBBIE):
1. Periodic abstract retrieval from PubMed
2. Standardization of the abstract text
3. Binary classification (relevant/Non-relevant to biomaterials) using an SVM implementation
4. Gate-based annotation of the relevant abstracts with terms from the DEB ontology, UNLS semantic types and other manually-selected classes from open ontologies (eg. NPO, NCIT, UBERON) 
5. Conversion of the resulting gate files to .json and their deposition in the DEBBIE Mongo database

## Pipeline (Add image in here)

## To Run the pipeline.  Ongoing work 

sh INSTALL.sh

## Built With

* [Docker](https://www.docker.com/) - Docker Containers
* [Maven](https://maven.apache.org/) - Dependency Management

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ProjectDebbie/DEBBIE_pipeline/tags). 

## Authors

* **Javier Corvi** - **Austin McKitrick** - **Osnat Hakimi**

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE Version 3 - see the [LICENSE](LICENSE) file for details


	
		
