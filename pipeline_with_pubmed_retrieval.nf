#!/usr/bin/env nextflow


log.info """
Base directory to use: ${params.baseDir}, This directory is used together with the pipeline name (-name parameter) output the results.
The output will be located at ${params.baseDir}/${workflow.runName}

UMLS configuration path: ${params.umls_config}
"""
.stripIndent()

//set default parameters
//pipeline process
params.pipeline = "UMLS,MM"  


//Configuration of the original pdf directory
params.abstract_input_folder = "${params.inputDir}"

params.general = [
    paramsout:          "${params.baseDir}/execution-results/params_${workflow.runName}.json",
    resultout:          "${params.baseDir}/execution-results/results_${workflow.runName}.txt",
    pipeline:			"${params.pipeline}"
]

pipeline = params.general.pipeline.split(',')

steps = [:]

params.umls_tagger = [
	instalation_folder: "/home/jcorvi/umls-2018AB-full/2018AB-full/MEDICAL_MATERIALS/2018AB/META",
	config: "/home/jcorvi/projects/debbie/debbie-pipeline/umls-annotator/config_MSH.properties"
	//config: "${params.umls_config}"
]

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

params.folders_steps = [
    //Output directory for the pubmed_retrieval step
	PUBRET: "${params.baseDir}/pubmed_retrieval_output",
    //Output directory for the debbie_classifier step
	CLA: "${params.baseDir}/debbie_classifier_output",
	//Output directory for the nlp-standard preprocessing step
	PRE: "${params.baseDir}/nlp_standard_preprocessing_output",
	//Output directory for the umls tagger step
	UMLS: "${params.baseDir}/umls_output",
	//Output directory for the cdisc_etox tagger step
	MM: "${params.baseDir}/medical_materials_output",
	//Output directory for export json
	GATE_JSON: "${params.baseDir}/gate_export_to_json_output"
]

//abstract_input_ch = Channel.fromPath( params.abstract_input_folder, type: 'dir' )

pubmed_retrieval_output_folder=file(params.folders.pubmed_retrieval_output_folder)
debbie_classifier_output_folder=file(params.folders.debbie_classifier_output_folder)
nlp_standard_preprocessing_output_folder=file(params.folders.nlp_standard_preprocessing_output_folder)
umls_output_folder=file(params.folders.umls_output_folder)
medical_materials_output_folder=file(params.folders.medical_materials_output_folder)
gate_export_to_json_output_folder=file(params.folders.gate_export_to_json_output_folder)

abstract_input_folder = params.abstract_input_folder

class StepPipeline {
   int id;
   String name;
   int order;
   String inputDir;
   String outputDir;	
   StepPipeline(id, name, inputDir, outputDir) {          
        this.id = id
        this.name = name
        this.inputDir = inputDir
        this.outputDir = outputDir
   }
   
   
}


void ProcessUserInputArguments(){
    def toRemove = []
    // Detect user inputed arguments.
    // Param's values are all dictionaries, whose class is null
    // User inputed arguments always(?) have classes associated
    for (param in params) 
        if (param.value.class != null)
            toRemove.add(param.key)
	// Transform the user inputed arguments into params
    for (userArgument in toRemove) {
		// Split the name into a list of entries, 
        // which represent a hierarchy inside params
        splittedArgument = userArgument.split('\\.')
		// Traverse the hierarchy starting from params
        curDict = params
        partOfConfiguration = true
		if (splittedArgument.size() > 1) {
            int x = 0;
            // For each hierarchy level in the hierarchy obtained (but last element)
            for (; x < (splittedArgument.size() - 1); x++) {
				// Get the current hierarchy level
                hierarchy = splittedArgument[x]
				// Check if the current hierarchy dict contains the current level as key
                // This is useful to inform the user of misspelled arguments
                if (curDict.containsKey(hierarchy)){
                    if (curDict[hierarchy] != null && curDict[hierarchy].class == null){
                        // Move deeper inside the hierarchy
                        curDict = curDict[hierarchy]    
                        continue  
                    }
                }

                // If current hierarchy dict does not contain the current level, inform the user
                println "[Config Wrapper] Argument \"" + userArgument + "\" is not part of the configuration"

                // Reverse the flag params from containing wrong information
                partOfConfiguration = false
                break
            }

            if (x == splittedArgument.size() - 1) {
                // Check if we have to change a value in params
                if (partOfConfiguration && curDict.containsKey(splittedArgument[x])) {
                    println "[Config Wrapper] " + userArgumALLent + " new value: " + params[userArgument] 
                    curDict[splittedArgument[splittedArgument.size() - 1]] = params[userArgument]
                } else {
                    println "[Config Wrapper] Argument \"" + userArgument + "\" is not part of the configuration\n" +
                            "                 \"" + splittedArgument[x] + "\" is not an element of \"" + splittedArgument[x - 1] + "\"" 
                }
            }
        } 
        else 
            println "[Config Wrapper] Argument \"" + userArgument + "\" is not part of the configuration"
        
        params.remove(userArgument)
    }
}

void ProcessPipelineParameters(){
	print(pipeline)
	if(pipeline!="ALL"){
	    int i = 1
		for (s in pipeline){
			if(steps.size()==0){
		 		stepPip = new StepPipeline(i,s, abstract_input_folder, params.folders_steps[s])
				print(stepPip)
			}else{
				stepPip = new StepPipeline(i,s,params.folders_steps[pipeline[i-2]], params.folders_steps[s])
				print(stepPip)
			}
			steps.putAt(stepPip.name, stepPip)	
			i=i+1
		}	
	}else{
		print(pipeline)
	}
}

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
    println "ADEs Text-mining pipeline Configuration"
    println "=" * 34

    for (configSection in params) {
        printSection(configSection)
        println "=" * 30
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


ProcessUserInputArguments()
ProcessPipelineParameters()
PrintConfiguration()
SaveParamsToFile()

process pubmed_retrieval {
    
    output:
    val pubmed_retrieval_output_folder into pubmed_retrieval_output_folder_ch
    
    
    script:
    """
    python3 /usr/src/app/pubmed_timed_retrieval.py -o $pubmed_retrieval_output_folder -term 'polydioxanone' -term2 'PDSII' -OR
	
    """
}


process debbie_classifier {
    input:
    file input_debbie_classifier from pubmed_retrieval_output_folder_ch
    
    output:
    val debbie_classifier_output_folder into debbie_classifier_output_folder_ch
    
    
    script:
    """
    python3 /usr/src/app/debbie_trained_classifier.py -i $input_debbie_classifier -o $debbie_classifier_output_folder -w /usr/src/app
	
    """
}

process nlp_standard_preprocessing {
    input:
    file input_nlp_standard_preprocessing from debbie_classifier_output_folder_ch
    
    output:
    val nlp_standard_preprocessing_output_folder into nlp_standard_preprocessing_output_folder_ch
    
    
    script:
    """
    echo $input_nlp_standard_preprocessing
    nlp-standard-preprocessing -i $input_nlp_standard_preprocessing -o $nlp_standard_preprocessing_output_folder -a BSC
	
    """
}

process umls_tagger {
    input:
    file input_umls from nlp_standard_preprocessing_output_folder_ch
   
    output:
    val umls_output_folder into umls_output_folder_ch
    	
    """
    umls-tagger -u $params.umls_tagger.instalation_folder -i $input_umls -o $umls_output_folder -a BSC -c $params.umls_tagger.config 
	
    """
}



process medical_materials {
    input:
    file input_medical_materials from umls_output_folder_ch
    output:
    val medical_materials_output_folder into medical_materials_output_folder_ch
    	
    """
    medical-materials -i $input_medical_materials -o $medical_materials_output_folder -a BSC
	
    """
}


process gate_to_json {
    input:
    file input_gate_to_json from medical_materials_output_folder_ch
    
    output:
    val gate_export_to_json_output_folder into gate_export_to_json_output_ch
    	
    """
    gate_to_json -i $input_gate_to_json -o $gate_export_to_json_output_folder
	
    """
}

process import_json_to_mongo {
    input:
    file input_import_json_to_mongo from gate_export_to_json_output_ch
    	
    """
    import-json-to-mongo -i $input_import_json_to_mongo -c mongodb://127.0.0.1:27017  -mongoDatabase DEBBIE -collection debbie_pipeline
	
    """
}

workflow.onComplete { 
	println ("Workflow Done !!! ")
}
