#! /bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
chmod -R 775 /var/www
chown ec2-user:ec2user /var/www
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2 docker

sudo systemctl start docker
sudo systemctl enable docker


sleep 10

sudo docker run --name mariadbtest -e MYSQL_ROOT_PASSWORD=mypass -p 33060:3306 -d mariadb

sudo wget https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
