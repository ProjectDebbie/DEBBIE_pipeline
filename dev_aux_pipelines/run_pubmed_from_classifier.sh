#!/bin/bash
#pipeline used to run againts the gold standard
#set pipeline name
pipeline_name=debbie_pipeline_`date '+%d-%m-%Y_%H_%M_%S'`
#set the nextflow instalation
nextflow_path="/home/jcorvi/nextflow_installation/nextflow"
#set the pipeline file
pipeline_path="/home/jcorvi/projects/debbie/DEBBIE_pipeline/pipeline_from_classifier.nf"
#input folder with abstracts
inputDir="/home/jcorvi/DEBBIE_DATA/gold_standard/"
#set the home/work dir of the pipeline
base_dir="/home/jcorvi/DEBBIE_DATA/gold_standard_executions/"`date '+%d-%m-%Y'`


#Database connection details
#set server and port
db_server=xxxxx
db_port=xxxxx
#set user and password
db_user=xxxxx
db_password=xxxxx
#set the database name
db_name=xxxxx
#set the collection prefix
db_collection_prefix=xxxxxx

#The complete mongo uri
db_uri="mongodb://"$db_user":"$db_password"@"$db_server":"$db_port"/?authSource="$db_name"&authMechanism=SCRAM-SHA-1"

#command
$nextflow_path run $pipeline_path --baseDir $base_dir --db_uri $db_uri --db_name $db_name --db_collection_prefix $db_collection_prefix --inputDir $inputDir -with-report $base_dir/report.html -with-trace -with-timeline $base_dir/timeline.html -name $pipeline_name
