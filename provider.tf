# Initialize AWS provider 

provider "aws" {
    region = "ap-south-1"  
}

resource "aws_instance" "cleo-vm"{

    ami = "ami-074dc0a6f6c764218"  
    instance_type = "t2.micro"
    key_name = "vamsi-key"
    subnet_id      = aws_subnet.subnet-1-public.id
    vpc_security_group_ids = [aws_security_group.terra-sg.id]
       
	 tags = {
        Name = "cleo-instance"
    }

  
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
