#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<html><h1><p> Welcome to my httpd website !.<br> This traffic is servered from:  ${HOSTNAME} </p></h1></html>" > /var/www/html/index.html