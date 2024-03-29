

provider aws {
    region = "us-east-1"
}
# for sg purpose
resource "aws_security_group" "security" {
  name        = "sg1"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-0540a2c4b2fd6ce42"

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["103.110.170.85/32"]
  }

 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg1"
  }
}

# for key pair purpose

resource "aws_key_pair" "key" {
  key_name   = "k1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChqAZWCFQuVRIZdCN5NwgTZCRVpqBIY5YQRRzRZqB5997IkDocFT0G7mDwh8wWcsqUp74KS280LMlHKZ10rPw/kkAxjnwldqSinD4K+C8rquP23c/h/VUbA6T+siJs9i81qkgWnY6ipFSVMUHe+TrTvTH/yKo4V/C7Ae5uAbEck9sq/XU3BtqOLotbpbqsXCzfe+l2hZ76Pw5Snj8+A4XB0rsmZcv2NkgBixwMsvvPQitoFhNO2wT7dA83XcD3+Z9RjbfSyWTkMJDetQH+he6TvY6OvSU+OpitDYSm/CgxHL3c2ebLxAOZa3v/Fc5H+JBFfmSFaBYnc8DZk7PlIBLbSYjeUL7JER8pHAmEsRnO4iLNXi3WOJxb+2yojTviQXScLD6ekhIFyKwPzPs4u4ll61k48THmbKSeEkQ/4tqfipDBVdpf1VmNBlnBZ7ZHloKXAdN68pjwRhxpJxUQ0vsD1dTTOFTasl0nRbMKQ/pJmP1JMJrm7zc5oMESeTFh5JE= Bala@LAPTOP-E3S8V9GE"
}

# for instance purpose

resource "aws_instance" "instance" {
    count = 1
    ami = "ami-0022f774911c1d690"
    instance_type = "t2.micro"
    key_name = "k1"
    vpc_security_group_ids = ["sg1"]
    user_data = <<EOF

    #!/bin/bash
    yum update -y
    yum install httpd -y 
    systemctl enable httpd
    systemctl start httpd
    mkdir -p  /var/www/html/
    echo "This is my first Task" >/var/www/html/index.html

    EOF 

    tags = {
        Name = "Ec2-1"
    }
}

