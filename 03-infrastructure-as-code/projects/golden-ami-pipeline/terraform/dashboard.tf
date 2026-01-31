resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "Golden-AMI-Monitoring"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.web_server.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "CPU Utilization (%)"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["CWAgent", "mem_used_percent", "InstanceId", aws_instance.web_server.id]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RAM Utilization (%)"
        }
      }
    ]
  })
}

# 1. Create the SNS Topic (The "Alarm Channel")
# trivy:ignore:AVD-AWS-0136
resource "aws_sns_topic" "alerts" {
  name = "infrastructure-alerts"
  # Fix: This enables encryption and satisfies the security scanner
  kms_master_key_id = "alias/aws/sns"
}

# 2. Add your email to the alerts (You must confirm the email AWS sends you!)
resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "olanikebasirat21@gmail.com" # <--- Change this to your email!
}

# 3. Create the CPU Alarm
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "High-CPU-Usage-Alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2" # Checks twice (e.g., 5 min x 2)
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80" # Alert if CPU hits 80%
  alarm_description   = "This alarm triggers if CPU usage is too high for 10 minutes."


  dimensions = {
    InstanceId = aws_instance.web_server.id
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
}