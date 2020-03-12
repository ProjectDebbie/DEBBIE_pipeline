work_folder="work"
if [ ! -d $work_folder ]; then
	mkdir $work_folder
fi

#own ontology
docker build -t own-ontology-annotator:1.0 own-ontology-annotator

cd $work_folder

#umls-tagger
if [ ! -d "umls-tagger" ]; then
  git clone https://gitlab.bsc.es/inb/text-mining/bio-tools/umls-tagger.git
  docker build -t umls-tagger:1.0 umls-tagger
  rm -f umls-tagger -R
fi

#gate-to-json
if [ ! -d "gate_to_json" ]; then
  git clone https://github.com/ProjectDebbie/gate_to_json.git
  docker build -t gate_to_json:1.0 gate_to_json	 
  rm -f gate_to_json -R
fi

#In the future download mongo and put inside annotated relevant abstracts
#docker pull mongo:4.0.4
#docker run -d -p 27017-27019:27017-27019 -v ~/mongo-data:/data/db --name mongodb mongo:4.0.4
cd ..

<<<<<<< HEAD
/home/jcorvi/nextflow_installation/nextflow run /home/jcorvi/projects/debbie/debbie-pipeline/pipeline.nf --inputDir /home/jcorvi/DEBBIE_DATA/pipeline_complete/relevant_with_year --baseDir /home/jcorvi/DEBBIE_DATA/pipeline_complete/results_12_03_2020/ --umls_config umls-annotation/config.properties
=======
/home/jcorvi/nextflow_installation/nextflow run /home/jcorvi/projects/debbie/debbie-pipeline/pipeline.nf --inputDir /home/jcorvi/DEBBIE_DATA/pipeline_test/relevant_with_year --baseDir /home/jcorvi/DEBBIE_DATA/pipeline_test/results_12_03_2020/ --umls_config umls-annotation/config.properties
>>>>>>> branch 'master' of https://github.com/ProjectDebbie/DEBBIE_pipeline.git

