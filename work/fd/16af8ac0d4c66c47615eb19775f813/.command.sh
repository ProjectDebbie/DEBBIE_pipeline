#!/bin/bash -ue
umls-tagger -u /home/jcorvi/umls-2018AB-full/2018AB-full/MEDICAL_MATERIALS/2018AB/META -i nlp_standard_preprocessing_output -o /home/jcorvi/DEBBIE_DATA/pipeline_complete/results_12_03_2020/umls_output -a BSC -c /home/jcorvi/projects/debbie/debbie-pipeline/umls-annotator/config.properties
