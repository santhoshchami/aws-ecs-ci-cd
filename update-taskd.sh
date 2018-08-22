#!/bin/bash

TASK_REVISION=`aws ecs describe-task-definition --task-definition QA | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
sed -e 's;%TASKD%;'${TASK_REVISION}';g' service-create.json > service-create-c.json
