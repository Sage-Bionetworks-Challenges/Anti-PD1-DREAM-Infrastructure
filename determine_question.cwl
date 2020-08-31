#!/usr/bin/env cwl-runner
#
# Throws invalid error which invalidates the workflow
#

$namespaces:
  s: https://schema.org/

s:author:
  - class: s:Person
    s:identifier: https://orcid.org/0000-0002-5841-0198
    s:email: thomas.yu@sagebionetworks.org
    s:name: Thomas Yu

cwlVersion: v1.0
class: ExpressionTool

inputs:
  - id: queue
    type: string

outputs:
  - id: question
    type: string

requirements:
  - class: InlineJavascriptRequirement

expression: |

  ${
    if(inputs.queue == "9614434" || inputs.queue == "9614446"){
      return {question: "1"};
    } else if (inputs.queue == "9614591" || inputs.queue == "9614593"){
      return {question: "2"};
    } else if (inputs.queue == "9614592" || inputs.queue == "9614594"){
      return {question: "3"};
    } else {
      throw 'invalid queue';
    }
  }

