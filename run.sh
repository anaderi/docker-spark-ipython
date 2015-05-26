#!/bin/bash
halt() {
echo $*
exit 1
}

which docker-compose > /dev/null || halt "Install docker-compose"
docker-compose run

#IMAGE='anaderi/pyspark:0.1'
#CID=`docker run -ti -h sandbox --name pyspark -v /home/ubuntu/spark-vm/notebook:/root/notebook -p 8001:8000 $IMAGE bash`
#echo $CID > docker.cid
