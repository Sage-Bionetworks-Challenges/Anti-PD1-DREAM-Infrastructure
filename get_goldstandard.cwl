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
          # docker cp /home01/centos/goldstandard/test.txt helper:/goldstandard/test.txt
          subprocess.check_call(["docker", "cp", "helper:/goldstandard/test.txt",
                                 "goldstandard.txt"])
     
outputs:
  - id: goldstandard
    type: File
    outputBinding:
      glob: goldstandard.txt