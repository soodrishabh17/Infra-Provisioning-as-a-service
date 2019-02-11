resource "aws_launch_configuration" "uat-frontendlaunchconfig" {
  name_prefix          = "uat-frontendlaunchconfig"
  image_id             = "ami-0898d3f58bf415990"
  instance_type        = "t2.micro"
  key_name             = "uat-ssh-key.pem"
  security_groups      = ["${aws_security_group.uat-frontend-sg.id}"]
}

resource "aws_autoscaling_group" "uat-frontend-autoscaling" {
  name                 = "uat-frontend-autoscaling"
  vpc_zone_identifier  = ["${aws_subnet.uat-public-1a.id}", "${aws_subnet.uat-public-1c.id}"]
  launch_configuration = "${aws_launch_configuration.uat-frontendlaunchconfig.name}"
  min_size             = 1
  max_size             = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  force_delete = true

  tag {
      key = "Name"
      value = "ec2 instance"
      propagate_at_launch = true
  }
}
