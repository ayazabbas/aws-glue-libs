#!/bin/bash

docker run --rm -it --entrypoint "/aws-glue-libs/bin/gluesparksubmit" -v ~/mnt/awsgluedev:/mnt awsglue-dev:latest /mnt/etl-job.py
#docker run --rm -it --entrypoint "/bin/bash" -v ~/mnt/awsgluedev:/mnt awsglue-dev:latest
