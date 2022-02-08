#!/bin/bash
#set pipeline name
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/jcorvi/nextflow/nextflow"
#set the pipeline file
pipeline_path="./pipeline_with_timed_retrieval.nf"
#set the home/work dir of the pipeline
base_dir="/home/jcorvi/DEBBIE_DATA/pipeline_complete/production_with_mesh_search/"`date '+%d-%m-%Y'`
#Registry file for processed abstracts. To avoid duplication of downloads during the update of the database.
pubmedRegistryFile="/home/jcorvi/DEBBIE_DATA/pipeline_complete/production_with_mesh_search/debbie_standardization_list_files_processed.dat"
pubmedRelDate=10
#quert to search in pubmed
searchQuery="((((((((Biomedical and dental materials[MeSH Terms]) OR (Prostheses and implants[MeSH Terms])) OR (Materials testing[MeSH Terms])) OR (Tissue engineering[MeSH Terms])) OR (Tissue scaffolds[MeSH Terms])) OR (Equipment safety[MeSH Terms])) OR (Medical device recalls[MeSH Terms])) OR (Biomaterials)) OR (Cell scaffolds)"



#Database connection details
#set server and port
db_server=xxxxx
db_port=xxxxx
#set user and password
db_user=xxxxx
db_password=xxxx
#set the database name
db_name=xxxxx
#set the collection prefix
db_collection_prefix=xxxxxx

#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"

#command
#remove searchQuery
$nextflow_path run $pipeline_path --baseDir $base_dir --db_uri $db_uri --db_name $db_name --db_collection_prefix $db_collection_prefix --pubmedRelDate $pubmedRelDate --pubmedRegistryFile $pubmedRegistryFile -with-report $base_dir/report.html -with-trace -with-timeline $base_dir/timeline.html -name $pipeline_name
