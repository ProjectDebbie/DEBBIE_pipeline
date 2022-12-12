#!/bin/bash

# Show env vars
grep -v '^#' /home/ubuntu/debbie/DEBBIE_pipeline/.env

# Export env vars
export $(grep -v '^#' /home/ubuntu/debbie/DEBBIE_pipeline/.env | xargs)

echo $PWD > /home/ubuntu/debbie/file.txt

#set pipeline name
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/ubuntu/nextflow"
#set the pipeline file
#pipeline_path="/home/ubuntu/debbie/DEBBIE_pipeline/pipeline_pro.nf"
pipeline_path="/home/ubuntu/debbie/DEBBIE_pipeline/pipeline_with_timed_retrieval.nf"

#set the home/work dir of the pipeline
base_dir="/home/ubuntu/debbie/execution-data/production/"`date '+%d-%m-%Y'`
#Registry file for processed abstracts. To avoid duplication of downloads during the update of the database.
pubmedRegistryFile="/home/ubuntu/debbie/execution-data/production/debbie_standardization_list_files_processed.dat"
pubmedRelDate=60
#quert to search in pubmed
searchQuery="((((((((Biomedical and dental materials[MeSH Terms]) OR (Prostheses and implants[MeSH Terms])) OR (Materials testing[MeSH Terms])) OR (Tissue engineering[MeSH Terms])) OR (Tissue scaffolds[MeSH Terms])) OR (Equipment safety[MeSH Terms])) OR (Medical device recalls[MeSH Terms])) OR (Biomaterials)) OR (Cell scaffolds)"



#Database connection details
#set server and port
db_server="${DB_SERVER}"
db_port="${DB_PORT}"
#set user and password
db_user="${DB_USER}"
db_password="${DB_PASSWORD}"
#set the database name
db_name="${DB_NAME}"
#set the collection prefix
db_collection_prefix="${DB_COLLECTION_PREFIX}"

#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"

#command
#remove searchQuery
$nextflow_path run $pipeline_path --baseDir $base_dir --db_uri $db_uri --db_name $db_name --db_collection_prefix $db_collection_prefix --pubmedRelDate $pubmedRelDate --pubmedRegistryFile $pubmedRegistryFile -with-report $base_dir/report.html -with-trace -with-timeline $base_dir/timeline.html -name $pipeline_name
