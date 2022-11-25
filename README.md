# cleo-test
#################### information purpose only ################

1. Provisioned resources using Terraform.

Since this is a Test environemnt other areas like Modules , Varaibles etc are not extensively used.

For a Real time you could use a 3 tier architecture for Test, Pre-prd/UAT , Prod environemnts using Variables and modules (Webservers + Application servers + Databases severs)

Pruchased domain since freedomain websites are not working  adding A record in Domain registrar and installed LetsEncrypt SSL certificates

************* Please find the PNG images uplaoded for config **************

        *********** Conifigure Terraform **********
1. Make terraform files I have created seperate for networking and VM(ec2 related sources)
2. For Networking : 
3.      Created VPC, Subnets ,Internet Gateway, Public subnets route association and Security groups (For 22,443 and 80 )
4. For Ec2 Instance and its parameters: 
5.      Create a Public key and Private keys . Public can be placed in Ec2 instance and Private can be stored from our local machine can be used later if required and then set
6.      permissions.
7.      .
8.      Created a ec2 machine resource and mapped using subnets and Security groups created in Networking.
9.      .
10.      Now write install.sh shell script and make executable permissions.
11.      .
12.      Using "Provisioners" like file and Remote-exec the file is copied and executed the shell scitpt. though you can also achieve from user data I have used "Provisioners"
13.      for convienence.
14.      
15.  For Shell script file : 
        Install Httpd server 
        Start and enable it .
        Change permissions & ownership for /var/www folder
        
        Install docker and configure Mariadb container using the commands that was provided in shell script (Refer to install.sh)
        
        Downlaod the Wordpress and unzip it.
        
 
 *********** For Configuring Wordpress ********
 Edited wp-config-sample.php to wp-config.php
 
Followed the instructions from documentation from https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress-aml-2022.html

**************** For Mysql container ********

Docker container is running at port 33060 download while terraform instance creation.

logged into docker container using docker exec -it mariatestdb bash

Add user wordpress and password.  Also using the command GRANT ALL PRIVILEGES ON `wordpress-db`.* TO "wordpress-user"@"%"; worked while connecting Wordpress and docker container. if not connection is not established.

 ******************************* For Mapping Domain *****************
 Purchased Domain vkby.net.in from hiox india and then mapped A record form the Public ip of EC2 instance 
 
 **************************** SSL certificate **************************
 
 Using Letsencrypt configured the SSL certificate using certbot -apache command. we can get instructions from online.
 Run Qualys SSL scan to make sure the SSL is working fine.
 
 *************For weather app creation ************8
 
 Downlaod the Html, css , javascipt files from online and then use api key from openweather website .
 
     Moved weather site folder to where wordpress is available and you could get the page.
