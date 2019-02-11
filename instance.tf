resource "aws_instance" "AppServer" {
  ami           = "ami-0898d3f58bf415990"
  instance_type = "t2.micro"

  # the VPC subnet
  subnet_id = "${aws_subnet.uat-public-1a.id}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.uat-frontend-sg.id}"]

  # the private SSH key
  key_name = "uat-ssh-key.pem"
  tags = {
   Name = "Appserver"
  }

  provisioner "file" {
    source = "script.sh"
    destination = "/tmp/script.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh"
    ]
  }
  connection {
    user = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_PRIVATE_KEY}")}"
  }
}

resource "aws_ebs_volume" "ebs-volume-1" {
    availability_zone = "us-east-1a"
    size = 8
    type = "gp2"
    tags {
        Name = "extra volume data"
    }
}

resource "aws_volume_attachment" "ebs-volume-1" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.ebs-volume-1.id}"
  instance_id = "${aws_instance.AppServer.id}"
}

resource "aws_lb_target_group_attachment" "FrontendLB" {
  target_group_arn = "${aws_lb_target_group.uat-tg.arn}"
  target_id        = "${aws_instance.AppServer.id}"
  port             = 8080
}
