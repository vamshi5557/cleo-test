# Initialize AWS provider 

provider "aws" {
    region = "ap-south-1"  
}

/* Initailzed public Key and private key and map to account however it is not used while testing purpose already old key is used , the below code is for key_pair 
ch works */

 /*
 resource "tls_private_key" "terrafrom_generated_private_key" {
   algorithm = "RSA"
   rsa_bits  = 4096
 }

 resource "aws_key_pair" "generated_key" {

   # Name of key: Write the custom name of your key
   key_name   = "aws_keys_pairs"

   # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
   public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

   # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
   provisioner "local-exec" {
     command = <<-EOT
       echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
       chmod 400 aws_keys_pairs.pem
     EOT
   }
 }

*/

Create Ec2 instance by using the below parameters.

resource "aws_instance" "cleo-vm"{

    ami = "ami-074dc0a6f6c764218"  
    instance_type = "t2.micro"
    key_name = "vamsi-key"
    subnet_id      = aws_subnet.subnet-1-public.id
    vpc_security_group_ids = [aws_security_group.terra-sg.id]
       
	 tags = {
        Name = "cleo-instance"
    }

/* Privsioners used for executing and copying scripts or files locally or remotely Even Ansible and other CM can also be integrated.
file is to cop from source server to destination server
remote-exec is used to remotely execute the scrits.
*/  

    provisioner "file" {

         source      = "install.sh"
         destination = "/home/ec2-user/install.sh"
    
  }
    provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ec2-user/install.sh",
      "sudo ./install.sh"
    ]
  }
  connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("vamsi-keypem.pem")
      timeout     = "4m"
   }
}
