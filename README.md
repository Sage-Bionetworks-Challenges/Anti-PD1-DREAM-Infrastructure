# Anti-PD1-DREAM-Infrastructure
This repository contains the infrastructure scripts and steps for the
[Anti-PD1 Response Prediction DREAM Challenge] (2021).

For more information about the tools, see [ChallengeWorkflowTemplates].

## Requirements
* Python 3+
* `pip3 install cwltool`
* A Synapse account and [configuration file]
* A [Synapse submission] to a queue

## Usage
To use this workflow as part of a Synapse Evaluation queue, first copy the
link address to the zipped archive of this repository:

```
https://github.com/Sage-Bionetworks-Challenges/Anti-PD1-DREAM-Infrastructure/archive/refs/heads/master.zip
```

Then, go to [Synapse] and create a new File Link in the respective Synapse
Project.  Paste the link above under **URL**, and name it whatever you like,
e.g. `workflow`.

Once the File Link has been created, add a new annotation called `ROOT_TEMPLATE`
and give it the value of 	Anti-PD1-DREAM-Infrastructure-master/workflow.cwl`.
This annotation will notify the [Synapse Workflow Orchestrator] as to which
file within the zipped archive is the workflow script to run.

Finally, copy the Synapse ID of this File Link as it will be needed to configure
the Synapse Workflow Orchestrator on the instance.

### Set up
This workflow does logging and the loading of goldstandard files via Docker
volumes. In order for the workflow to run properly, the volumes will need to
be created first.

#### Logging
First, create the Docker volume for logging:

```
docker volume create \
  --driver local \
  --opt type=none \
  --opt device=~/logs \
  --opt o=bind \
  logging
```

Then, start its container:

```
docker run \
  --name logging \
  -v logging:/logging \
  centos
```

Logs will be located in `~/logs`:

```
ls ~/logs
```

#### Goldstandard files
For this challenge, it is imperative that the goldstandard files remain
secured, and that absolutely NO information about its content are to be sent
back to the participants.

To ensure this, goldstandard files are to be copied into a Docker container:

```
docker run \
  -v truth:/goldstandard/ \
  --name helper busybox true
```

Once running, mount the files over to the container:

```
docker cp \
  ~/goldstandard_data.csv \
  helper:/goldstandard/gold_standard_data.csv
```

### Running locally
You can test the workflow on your local machine with the following command:

```
cwl-runner workflow.cwl inputs.yaml
```

where `inputs.yaml` is a YAML file with 5 values:

* submissionId - Submission ID
* synapseConfig - filepath to .synapseConfig file
* adminUploadSynId - Synapse Folder ID accessible by an admin
* submitterUploadSynId - Synapse Folder ID accessible by the submitter
* workflowSynapseId - Synapse ID that links to the workflow archive

For example:

```yaml
submissionId: 1234567
synapseConfig:
  class: File
  path: /Users/awesome-user/.synapseConfig
adminUploadSynId: syn123
submitterUploadSynId: syn345
workflowSynapseId: syn678
```

Alternatively, all inputs can be passed from the command-line, e.g.

```bash
cwl-runner workflow.cwl \
  --submissionId 1234567 \
  --synapseConfig /Users/awesome-user/.synapseConfig \
  --adminUploadSynId syn123 \
  --submitterUploadSynId syn456 \
  --workflowSynapseId: syn678
```

<!-- Links -->

[Anti-PD1 Response Prediction DREAM Challenge]: https://www.synapse.org/brats2021
[ChallengeWorkflowTemplates]: https://github.com/Sage-Bionetworks/ChallengeWorkflowTemplates
[configuration file]: https://docs.synapse.org/articles/client_configuration.html#for-developers
[Synapse submission]: https://docs.synapse.org/articles/evaluation_queues.html#submissions
[Synapse]: https://www.synapse.org/
[Synapse Workflow Orchestrator]: https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator
