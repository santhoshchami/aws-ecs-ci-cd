#!/bin/bash
TASK_FAMILY="QA"
TASK_REVISION=`aws ecs describe-task-definition --task-definition QA | egrep "revision" | tr "/" " " | awk '{print $2}' | sed 's/"$//'`
aws ecs deregister-task-definition --task-definition ${TASK_FAMILY}:${TASK_REVISION}
