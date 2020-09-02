#!/usr/bin/env cwl-runner
#
# Example score submission file
#
cwlVersion: v1.0
class: CommandLineTool
baseCommand: [ python3, get_gold.py ]

inputs: []

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: get_gold.py
        entry: |
          #!/usr/bin/env python
          import subprocess
          # Run these commands to mount files into docker containers
          # docker run -v truth:/goldstandard/ --name helper busybox true
          # docker cp /home01/centos/challenge_data/gold_standard_data.csv helper:/goldstandard/gold_standard_data.csv
          subprocess.check_call(["docker", "cp", "helper:/goldstandard/gold_standard_data.csv",
                                 "goldstandard.csv"])
          subprocess.check_call(["docker", "cp", "helper:/goldstandard/synthetic_gold_standard_data.csv",
                                 "synthetic_goldstandard.csv"])
     
outputs:
  - id: goldstandard
    type: File
    outputBinding:
      glob: goldstandard.csv

  - id: synthetic_goldstandard
    type: File
    outputBinding:
      glob: synthetic_goldstandard.csv