#!/bin/bash
#set pipeline name
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/jcorvi/nextflow_installation/nextflow"
#set the pipeline file
pipeline_path="/home/jcorvi/projects/debbie/DEBBIE_pipeline/pipeline_with_retrieval.nf"
#set the pubmed abstracts home folder
pubmed_base_dir="/home/jcorvi/pubmed/pubmed_abstracts/"
#set the home/work dir of the pipeline
base_dir="/home/jcorvi/DEBBIE_DATA/pipeline_complete/production/"`date '+%d-%m-%Y'`

#Database connection details
#set server and port
db_server=mdb-login.bsc.es
db_port=27017
#set user and password
db_user=OHakimi
db_password=deb2020..
#set the database name
db_name=DEBBIE
#set the collection
db_collection=22_06_2020
#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"

#command
$nextflow_path run $pipeline_path --pubmedBaseDir $pubmed_base_dir --baseDir $base_dir --db_uri $db_uri --db_name $db_name --db_collection $db_collection -with-report $base_dir/report.html -with-trace -with-timeline $base_dir/timeline.html -name $pipeline_name
