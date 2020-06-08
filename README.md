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

## To Run the pipeline.  

Open the run.sh file and configure the corresponding parameters when needed.

#set pipeline name, by default it indicates the data and time
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/user/nextflow_installation/nextflow"
#set the pipeline file
pipeline_path="/home/user/projects/debbie/DEBBIE_pipeline/pipeline_with_retrieval.nf"
#set the pubmed abstracts home folder
pubmed_base_dir="/home/user/pubmed/pubmed_abstracts/"
#set the home/work dir of the pipeline
base_dir="/home/user/DEBBIE_DATA/pipeline_complete/production/"`date '+%d-%m-%Y'`

#Database connection details
#set server and port
db_server=xxxxxx
db_port=xxxxxx
#set user and password
db_user=xxxxxx
db_password=xxxxxx
#set the database name
db_name=xxxxxx
#set the collection
db_collection=xxxxxx
#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"


Then to run the pipeline simple execute:
bash run.sh

## Built With

* [Docker](https://www.docker.com/) - Docker Containers
* [Maven](https://maven.apache.org/) - Dependency Management

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ProjectDebbie/DEBBIE_pipeline/tags). 

## Authors

* **Javier Corvi** - **Austin McKitrick** - **Osnat Hakimi**

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE Version 3 - see the [LICENSE](LICENSE) file for details


	
		
