#!/usr/bin/env nextflow

pipeline_version = 1.0

log.info """
This is the DEBBIE pipeline execution.  
The DEBBIE base directory to use: ${params.baseDir}, This directory is used as a work directory of the pipeline, the output to each component of the pipeline will appear in this directory.
At a first step an specific pubmed retrieval query is executed to download a set of abstracts.
Pubmed Query Search: ${params.searchQuery}.
The output will be located at ${params.baseDir}.
The pubmedRegistryFiler, mantain a registry of the processed file for update the database with the last published documents, is located at ${params.pubmedRegistryFile}. 
The reldate is ${params.pubmedRelDate} days only abstract added in the past days will be returned.
Pipeline execution name: ${workflow.runName}
Pipeline version: ${pipeline_version}
"""
.stripIndent()

//Configuration of the original pdf directory
//params.abstract_input_folder = 'None'

params.general = [
    paramsout:          "${params.baseDir}/execution-results/params_${workflow.runName}.json",
    resultout:          "${params.baseDir}/execution-results/results_${workflow.runName}.txt",
    baseDir:            "${params.baseDir}",
    pubmedRegistryFile: "${params.pubmedRegistryFile}",  
    searchQuery:        "${params.searchQuery}",
    pubmedRelDate:      "${params.pubmedRelDate}"
]

params.database = [
    db_uri:             "${params.db_uri}",
    db_name:            "${params.db_name}",
    db_collection_prefix:      "${params.db_collection_prefix}"
]

log.info """
The text-mining execution results will be stored in the provided database:
Database Url: $params.database.db_uri
Database name: $params.database.db_name
Collection: $params.database.db_collection_prefix
"""
.stripIndent()

steps = [:]

pipeline_log = "${params.baseDir}/pipeline_with_timed_retrieval.log"

params.folders = [
        //Output directory for debbie_classifier step
	pubmed_retrieval_output_folder: "${params.baseDir}/pubmed_retrieval_output_folder/",
        //Output directory for debbie_classifier step
	debbie_classifier_output_folder: "${params.baseDir}/debbie_classifier_output_folder/",
	//Output directory for the nlp-standard preprocessing step
	nlp_standard_preprocessing_output_folder: "${params.baseDir}/nlp_standard_preprocessing_output",
	//Output directory for the umls tagger step
	umls_output_folder: "${params.baseDir}/umls_output",
	//Output directory for the umls tagger step
	medical_materials_output_folder: "${params.baseDir}/medical_materials_output",
	//Output directory for the post processing ades
	gate_export_to_json_output_folder: "${params.baseDir}/gate_export_to_json_output"
]


basedir_input_ch = Channel.fromPath(params.general.baseDir, type: 'dir' )

//files folder declaration for each component output 
pubmed_retrieval_output_folder=file(params.folders.pubmed_retrieval_output_folder)
debbie_classifier_output_folder=file(params.folders.debbie_classifier_output_folder)
nlp_standard_preprocessing_output_folder=file(params.folders.nlp_standard_preprocessing_output_folder)
umls_output_folder=file(params.folders.umls_output_folder)
medical_materials_output_folder=file(params.folders.medical_materials_output_folder)
gate_export_to_json_output_folder=file(params.folders.gate_export_to_json_output_folder)


pubmed_reldate=params.general.pubmedRelDate
pubmed_registry_file=params.general.pubmedRegistryFile

basedir_input_folder = params.general.baseDir

void printSection(section, level = 1){
    println (("  " * level) + "↳ " + section.key)
    if (section.value.class == null)
    {
      for (element in section.value)
        {
           printSection(element, level + 1)
        }
    }
    else {
        if (section.value == "")
            println (("  " * (level + 1) ) + "↳ Empty String")
        else
            println (("  " * (level + 1) ) + "↳ " + section.value)
    }
}

void PrintConfiguration(){
    println ""
    println "=" * 34
    println "DEBBIE text-mining pipeline Configuration"
    println "=" * 34
    for (configSection in params) {
          //println (configSection.getClass())     
          if(configSection.key=="general" || configSection.key=="database" || configSection.key=="folders"){

            printSection(configSection)
            println "=" * 30
          }
       
    }

    println "\n"
}

String parseElement(element){
    if (element instanceof String || element instanceof GString ) 
        return "\"" + element + "\""    

    if (element instanceof Integer)
        return element.toString()

    if (element.value.class == null)
    {
        StringBuilder toReturn = new StringBuilder()
        toReturn.append()
        toReturn.append("\"")
        toReturn.append(element.key)
        toReturn.append("\": {")

        for (child in element.value)
        {
            toReturn.append(parseElement(child))
            toReturn.append(',')
        }
        toReturn.delete(toReturn.size() - 1, toReturn.size() )
        
        toReturn.append('}')
        return toReturn.toString()
    } 
    else 
    {
        if (element.value instanceof String || element.value instanceof GString ) 
            return "\"" + element.key + "\": \"" + element.value +medical_materials_output_folder +"\""            

        else if (element.value instanceof ArrayList)
        {
            // println "\tis a list"
            StringBuilder toReturn = new StringBuilder()
            toReturn.append("\"")
            toReturn.append(element.key)
            toReturn.append("\": [")
            for (child in element.value)
            {gate_to_json
                toReturn.append(parseElement(child)) 
                toReturn.append(",")                
            }
            toReturn.delete(toReturn.size() - 1, toReturn.size() )
            toReturn.append("]")
            return toReturn.toString()
        }

        return "\"" + element.key + "\": " + element.value
    }
}

def SaveParamsToFile() {
    // Check if we want to produce the params-file for this execution
    if (params.paramsout == "")
        return;

    // Replace the strings ${baseDir} and ${workflow.runName} with their values
    //params.general.paramsout = params.general.paramsout
    //    .replace("\${baseDir}".toString(), baseDir.toString())
    //    .replace("\${workflow.runName}".toString(), workflow.runName.toString())

    // Store the provided paramsout value in usedparamsout
    params.general.usedparamsout = params.general.paramsout

    // Compare if provided paramsout is the default value
    if ( params.general.paramsout == "${baseDir}/param-files/${workflow.runName}.json"){
        // And store the default value in paramsout
        params.general.paramsout = "\${baseDir}/param-files/\${workflow.runName}.json"
    }

    // Inform the user we are going to store the params-file and how to use it.
    println "[Config Wrapper] Saving current parameters to " + params.general.usedparamsout + "\n" +
            "                 This file can be used to input parameters providing \n" + 
            "                   '-params-file \"" + params.general.usedparamsout + "\"'\n" + 
            "                   to nextflow when running the workflow."


    // Manual JSONification of the params, to avoid using libraries.
    StringBuilder content = new StringBuilder();
    // Start the dictionary
    content.append("{")

    // As parseElement only accepts key-values or dictionaries,
    //      we iterate here for each 'big-category'
    for (element in params) 
    {
        // We parse the element
        content.append(parseElement(element))
        // And add a comma to separate elements of the list
        content.append(",")
    }

    // Remove the last comma
    content.delete(content.size() - 1, content.size() )
    // And add the final bracket
    content.append("}")

    // Create a file handler for the current usedparamsout
    configJSON = file(params.general.usedparamsout)
    // Make all the dirs of usedparamsout path
    configJSON.getParent().mkdirs()
    // Write the contents to file
    configJSON.write(content.toString())
}


//Execution Begin
PrintConfiguration()
SaveParamsToFile()

//Workflow component Begins

process pubmed_timed_retrieval {
    
    input:
    file pubmed_retrieval_input from basedir_input_ch
    output:
    val pubmed_retrieval_output_folder into pubmed_retrieval_output_folder_ch    
    script:
    
    """
    exec >> $pipeline_log
    echo "********************************************************************************************************************** "
    echo `date`
    echo "Start Pipeline Execution, Pipeline Version $pipeline_version, workflow name: ${workflow.runName} "
    echo "Start pubmed_timed_retrieval"
    python3 /usr/src/app/pubmed_timed_retrieval.py -o $pubmed_retrieval_output_folder -r $pubmed_registry_file -d $pubmed_reldate
    echo "End pubmed_timed_retrieval"
    """
}

process debbie_classifier {
    input:
    file input_debbie_classifier from pubmed_retrieval_output_folder_ch
    
    output:
    val debbie_classifier_output_folder into debbie_classifier_output_folder_ch
    val debbie_classifier_output_folder into debbie_classifier_output_folder_ch_2    
    
    script:
    """
    exec >> $pipeline_log
    echo "Start debbie_classifier"
    python3 /usr/src/app/debbie_trained_classifier.py -i $input_debbie_classifier -o $debbie_classifier_output_folder -w /usr/src/app
    echo "Start debbie_classifier"
    """
}

process nlp_standard_preprocessing {
    input:
    file input_nlp_standard_preprocessing from debbie_classifier_output_folder_ch

    output:
    val nlp_standard_preprocessing_output_folder into nlp_standard_preprocessing_output_folder_ch


    script:
    """
    exec >> $pipeline_log
    echo "Start nlp_standard_preprocessing"
    nlp-standard-preprocessing -i $input_nlp_standard_preprocessing -o $nlp_standard_preprocessing_output_folder -a BSC -t 8
    echo "End nlp_standard_preprocessing"
    """
}


process debbie_umls_annotation {
    input:
    file input_umls from nlp_standard_preprocessing_output_folder_ch

    output:
    val umls_output_folder into umls_output_folder_ch

    """
    exec >> $pipeline_log
    echo "Start debbie_umls_annotation"
    debbie-umls-annotator -i $input_umls -o $umls_output_folder -a BSC -gt flexible -t 1
    echo "End debbie_umls_annotation"
    """
}

process debbie_dictionary_annotation {
    input:
    file input_medical_materials from umls_output_folder_ch
    output:
    val medical_materials_output_folder into medical_materials_output_folder_ch

    """
    exec >> $pipeline_log
    echo "Start debbie_onlology_annotation"
    biomaterials-annotator -i $input_medical_materials -o $medical_materials_output_folder -a BSC -gt flexible -t 1
    echo "End debbie_onlology_annotation"
    """
}

process gate_to_json {
    input:
    file input_gate_to_json from medical_materials_output_folder_ch
    file input_metadata from debbie_classifier_output_folder_ch_2 
   
    output:
    val gate_export_to_json_output_folder into gate_export_to_json_output_ch

    """
    exec >> $pipeline_log
    echo "Start gate_to_json"
    gate_to_json -i $input_gate_to_json -im $input_metadata -o $gate_export_to_json_output_folder -a BSC
    echo "End gate_to_json"
    """
}

process import_json_to_mongo {
    input:
    file input_import_json_to_mongo from gate_export_to_json_output_ch

    """
    exec >> $pipeline_log
    echo "Start import_json_to_mongo"
    import-json-to-mongo -i $input_import_json_to_mongo -c "$params.database.db_uri" -d $params.database.db_name -j $params.db_collection_prefix
    echo "End import_json_to_mongo"
    """
}

workflow.onComplete {
        println ("Workflow Done !!! ")
        """
        exec >> $pipeline_log
        echo "End Pipeline Execution, Pipeline Version $pipeline_version, workflow name ${workflow.runName}"
        echo "********************************************************************************************************************** "
        """
}

