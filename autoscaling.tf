resource "aws_launch_template" "example-launchtemplate" {
  name                   = "example-launchtemplate"
  image_id               = var.AMIS[var.AWS_REGION]
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  user_data              = filebase64("user-data.sh")
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                = "example-autoscaling"
  vpc_zone_identifier = [aws_subnet.main-public-1.id, aws_subnet.main-public-2.id]
  launch_template {
    id      = aws_launch_template.example-launchtemplate.id
    version = "$Latest"
  }
  min_size                  = 2
  max_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2 instance"
    propagate_at_launch = true
  }
}

