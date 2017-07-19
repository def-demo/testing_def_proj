#!/bin/bash
set -e -x
pushd source-code
mvn clean package
popd
if [ -f source-code/target/*.war ]; then
artifact=$(basename source-code/target/*.war)
cp source-code/target/$artifact  build-output/.
curl -u admin:password -X PUT http://192.168.115.152/artifactory/def-temp/random/$artifact -T source-code/target/$artifact
#sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no build-output/*.war vagrant@ipaddress:/home/vagrant
#sshpass -p 'vagrant' ssh -t vagrant@ipaddress "sudo cp *.war /var/lib/tomcat7/webapps"
else
artifact=$(basename source-code/target/*.jar)
 cp source-code/target/$artifact  build-output/.
 curl -u admin:password -X PUT http://192.168.115.152/artifactory/def-temp/random/$artifact -T source-code/target/$artifact
# sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no build-output/*.jar vagrant@ipaddress:/home/vagrant
# sshpass -p 'vagrant' ssh -t vagrant@ipaddress "sudo cp *.jar /var/lib/tomcat7/webapps"
fi
if [ "tarenv" = "openstack" ];then
sleep 200
sshpass -p 'vagrant' scp -o StrictHostKeyChecking=no build-output/*.* vagrant@ipaddress:/home/vagrant
sshpass -p 'vagrant' ssh -t vagrant@ipaddress "sudo cp *.* /var/lib/tomcat7/webapps"
else
echo "pivotal "
fi
