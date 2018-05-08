SHA1=$1
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json
EB_BUCKET= ngocduy-deploy-bucket

aws ecr get-login | bash

docker build -t 012881927014.dkr.ecr.ap-southeast-1.amazonaws.com/docker:$SHA1 .
docker push 012881927014.dkr.ecr.ap-southeast-1.amazonaws.com/docker:$SHA1

sed "s/<tag>/$SHA1/" < Dockerrun.aws.json > $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE

aws elasticbeanstalk create-application-version\
  --application-name application \
  --version-label $SHA1 \
  --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE
