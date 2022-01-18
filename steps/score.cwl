#!/usr/bin/env cwl-runner
#
# Score submission file
#
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [Rscript, /score.R]

hints:
  DockerRequirement:
    dockerPull: docker.synapse.org/syn18404606/scoring:v3

inputs:
  - id: inputfile
    type: File
    inputBinding:
      prefix: -f

  - id: goldstandard
    type: File
    inputBinding:
      prefix: -g

  - id: output
    type: string?
    default: results.json
    inputBinding:
      prefix: -r

  - id: question
    type: string?
    inputBinding:
      prefix: -q
  
  - id: submission_number
    type: int
    inputBinding:
      prefix: -s

  - id: check_validation_finished
    type: boolean?

requirements:
  - class: InlineJavascriptRequirement
     
outputs:
  - id: results
    type: File
    outputBinding:
      glob: $(inputs.output)