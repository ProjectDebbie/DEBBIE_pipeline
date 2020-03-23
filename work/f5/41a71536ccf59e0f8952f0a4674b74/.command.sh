#!/bin/bash -ue
import-json-to-mongo -i gate_export_to_json_output -c mongodb://127.0.0.1:27017  -mongoDatabase debbie -collection abstract_annotated
