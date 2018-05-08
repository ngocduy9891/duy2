SHA1=$1
DOCKERRUN_FILE=$SHA1-Dockerrun.aws.json
EB_BUCKET= # Elastic Beanstalkのバージョンファイルが入るS3のバケット名

aws ecr get-login | bash

docker build -t {AWS ID}.dkr.ecr.us-east-1.amazonaws.com/{リポジトリ名}:$SHA1 .
docker push {AWS ID}.dkr.ecr.us-east-1.amazonaws.com/{リポジトリ名}:$SHA1

sed "s/<tag>/$SHA1/" < Dockerrun.aws.json > $DOCKERRUN_FILE

aws s3 cp $DOCKERRUN_FILE s3://$EB_BUCKET/$DOCKERRUN_FILE

aws elasticbeanstalk create-application-version\
  --application-name application \
  --version-label $SHA1 \
  --source-bundle S3Bucket=$EB_BUCKET,S3Key=$DOCKERRUN_FILE
