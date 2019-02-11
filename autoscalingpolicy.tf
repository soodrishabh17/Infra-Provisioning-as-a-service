# scale up alarm

resource "aws_autoscaling_policy" "frontend-scaleup-policy" {
  name                   = "frontend-scaleup-policy"
  autoscaling_group_name = "${aws_autoscaling_group.uat-frontend-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "high-cpu-alarm" {
  alarm_name          = "high-cpu-alarm"
  alarm_description   = "high-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.uat-frontend-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.frontend-scaleup-policy.arn}"]
}

# scale down alarm
resource "aws_autoscaling_policy" "frontend-scaledown-policy" {
  name                   = "frontend-scaledown-policy"
  autoscaling_group_name = "${aws_autoscaling_group.uat-frontend-autoscaling.name}"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "low-cpu-alarm" {
  alarm_name          = "low-cpu-alarm"
  alarm_description   = "low-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.uat-frontend-autoscaling.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.frontend-scaledown-policy.arn}"]
}
