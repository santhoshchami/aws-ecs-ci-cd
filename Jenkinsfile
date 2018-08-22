#!/usr/bin/env groovy
//node for future reference where Jobs can run specific slave node 
node {
    //stage for Checkout Code base from SCM 
        stage('Checkout SCM') {
            checkout scm
	    //get git commit ID which can be used for version controll 
	    //gitCommit = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
      	    //currentBuild.displayName = gitCommit
            }

        //Stage for Build Docker image and push into AWS ECS registry 
        //Credentials for authenticating ECS registry as stored in cs-credentials on Jenkins AWS ECS plugin
        stage ("Build"){

            def customImage = docker.build(
		    "684311504653.dkr.ecr.us-east-1.amazonaws.com/pulseid-task:v_${env.BUILD_ID}")
            docker.withRegistry(
		    'http://684311504653.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:ecs-credentials'){
            customImage.push("v_${env.BUILD_NUMBER}")}
            }
        //update ECS service to desired count 0 for to delete service
	stage ("QA Deploy"){
          sh "aws ecs update-service --cluster QA --service QA --desired-count 0 | sleep 1m"
		
        //delete service to re-create service with new code base
          sh "aws ecs delete-service --cluster QA --service QA | sleep 5m"
		
        //delete tasks with revision number
          sh "bash qa-del-task.sh"
		
        //update task json with new docker image version
          sh 'sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g" qa-task.json > qa-task-c.json'
		
        //creating new task definition with revision and new container configuration based upon qa-task-c.json input
          sh "aws ecs register-task-definition --cli-input-json file://qa-task-c.json"
		
        //update service-create.json file with updated revision number
          sh "bash update-taskd.sh"
          sh  "aws ecs create-service --cli-input-json file://service-create-c.json"
        }

        //Stage for test functional and performance 
        stage ("Test QA"){
          sh  "sleep 1m"
          sh  'curl -s "http://pulseid-test-lb-1867814004.us-east-1.elb.amazonaws.com:8080"'
        }
        //Stage for approval process to promote to Stage, and we can have even manager approval via e-mail or in JOB ID
        stage('QA Promotion'){
            	input "Deploy to Blue Env ?"
        }
  
}
