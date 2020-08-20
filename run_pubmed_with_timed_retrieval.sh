#!/bin/bash
#set pipeline name
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/jcorvi/nextflow_installation/nextflow"
#set the pipeline file
pipeline_path="/home/jcorvi/projects/debbie/DEBBIE_pipeline/pipeline_with_timed_retrieval.nf"
#set the home/work dir of the pipeline
base_dir="/home/jcorvi/DEBBIE_DATA/pipeline_complete/production_with_search/"`date '+%d-%m-%Y'`
#quert to search in pubmed
searchQuery=silk



#Database connection details
#set server and port
db_server=xxxx
db_port=xxxx
#set user and password
db_user=xxxxx
db_password=xxxxx
#set the database name
db_name=xxxxx
#set the collection prefix
db_collection_prefix=xxxx

#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"

#command
$nextflow_path run $pipeline_path --baseDir $base_dir --db_uri $db_uri --db_name $db_name --db_collection_prefix $db_collection_prefix --searchQuery $searchQuery -with-report $base_dir/report.html -with-trace -with-timeline $base_dir/timeline.html -name $pipeline_name
