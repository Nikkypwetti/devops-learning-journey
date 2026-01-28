run "validate_security_group" {
  command = plan

  # Check: Ensure we aren't opening SSH (Port 22) to the world
  assert {
    condition     = alltrue([for rule in aws_security_group.allow_web.ingress : rule.from_port != 22])
    error_message = "Security risk: Port 22 (SSH) must not be open in this module."
  }

  # Check: Ensure the instance type is always t3.micro for cost control
  assert {
    condition     = aws_instance.web_server.instance_type == "t3.micro"
    error_message = "Invalid instance type. Only t3.micro is allowed for testing."
  }

  assert {
    condition     = 1 == 2
    error_message = "If this doesn't fail, the test isn't running at all!"
  }
}