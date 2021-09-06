===================================================================
Learning about Concourse
===================================================================

===================================================================
#1. WHAT IS CONCOURSE ?
===================================================================
    - Concourse is a pipeline-based continuous thing-doer.(Definition from https://concourse-ci.org/)
    - Concourse is a 100% open source
    - Concourses declarative file approach makes it easier for Developers to manage your complex project
    - Everything in Concourse runs in a container
    - Instead of modifying workers to install build tools, Concourse run pipeline using container images
    - Typically uses Docker images via the registry-image resource
    - Concourse pipelines represent a dependency flow
    - A pipeline is the result of configuring Jobs and Resources together
    - Concourse Pipelines are designed to be self-contained so as to minimize server-wide configuration
    - Concourse Pipelines are built around Resources
    - These resource represent all external state, and Jobs, which interact with them

===================================================================
#2. WHAT MAKES CONCOURSE PIPELINES ?
===================================================================
# 2.1-RESOURCES IN CONCOURSE:
        - Using Resources we can express references for Source Code (ex: git resource)
        - Using Resources We can mention BUILD dependencies and RELEASE dependencies in the pipeline
        - Resource Types are defined as part of the pipeline itself
        - Declaring the Resource in pipeline makes the pipeline more self-contained, small and generic

#2.2-JOBS IN CONCOURSE
        - Jobs are sequences of get, put, and task steps to execute
        - These steps determine the job's inputs and outputs.

#2.3-TASKS IN CONCOURSE
        - Smallest configurable unit in a Concourse pipeline is a single TASK
        - Tasks are pure functions
        - A task can be thought of as a function from task.inputs to task.outputs that can either succeed or fail.

===================================================================
#3. CREATING PIPELINES
===================================================================
  To create Concourse Pipelines we will need
        - Running docker
        - Running docker-compose
        NOTE:
        - You need to set the external url env variable inside the docker-compose.yml.
        - By default Concourse use PORT 8080, but our tomcat based also used port 8080
        - So resolve this conflict ,we bind CONCOUSRSE to use PORT 9090
        - Also Open port 9090 on EC2 Instance Security Group to allow traffic open to port 9090 from Internet (0.0.0.0/0)

#3.1:   JAVA, MAVEN and Docker and Docker compose Installation:
URL for ref:  https://docs.docker.com/compose/install/#install-compose
Consider an Ubuntu EC2 instance and run the following commands
            $ sudo su
            $ cd
            $ sudo apt-get update -y
            $ sudo apt-get install docker.io -y
            $ sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            $ sudo chmod +x /usr/local/bin/docker-compose
            $ sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
            $ docker-compose --version

#3.2:   Deploy Concourse using Docker Compose:

            $ curl -O https://concourse-ci.org/docker-compose.yml
            $ sudo nano docker-compose.yml
              Add + CONCOURSE_EXTERNAL_URL: http://{{Public DNS or Public IP of EC2 Instance}}:9090
            - CONCOURSE_EXTERNAL_URL
            + CONCOURSE_EXTERNAL_URL: http://{{Public DNS or Public IP of EC2 Instance}}:9090
            + CONCOURSE_BIND_PORT: 9090
            $ docker-compose up -d

#3.3:   Access Concourse
            Open browser and run http://{{Public DNS or Public IP of EC2 Instance}}:9090

#3.4:   FLY Installation ( CLI for Concourse)
            - Click on your operating system to download the fly CLI.
            - Once downloaded, copy the fly binary into your path ($PATH), such as /usr/local/bin or ~/bin.
            - Don't forget to also make it executable.

            $ curl 'http://{{Public DNS or Public IP of EC2 Instance}}:9090/api/v1/cli?arch=amd64&platform=linux' -o fly && chmod +x ./fly && mv ./fly /usr/local/bin/
            $ fly --target=ralpha login --concourse-url=http://{{Public DNS or Public IP of EC2 Instance}}:9090/ --username=test --password=test
            $ fly --target=ralpha sync
            $ cat ~/.flyrc

#3.5    Create a Pipeline using Target
            $ git clone https://github.com/ssadcloud/ion.git
            $ cd ion

      Command Templates:
          fly -t ralpha set-pipeline --pipeline <<name-of-the-pipeline>> --config <<config-file>>.yml
          fly -t ralpha unpause-pipeline -p <<name-of-the-pipeline>>

            $ fly -t ralpha set-pipeline --pipeline alpha-pipeline --config configuration/pipeline/pipeline.yml
            $ fly -t ralpha unpause-pipeline -p alpha-pipeline

#3.6    To Delete a Pipeline with name myp1
      Command Templates:
          fly -t ralpha destroy-pipeline --pipeline <<name-of-the-pipeline>>

             $ fly -t ralpha destroy-pipeline --pipeline alpha-pipeline
#3.7    To Delete Targets
            $ fly -t tutorial delete-target
#3.8    Uninstallation for Concourse
            $ docker-compose down
#3.9    Uninstallation for docker-compose
            $ sudo rm /usr/local/bin/docker-compose
