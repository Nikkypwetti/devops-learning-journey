# variables {
#   # You can override variables here if your main.tf used them
# }

# run "verify_real_deployment" {
#   command = apply # This tells Terraform to actually build the resources

#   # Check: Ensure AWS actually assigned an ARN (proves it was created)
#   assert {
#     condition     = can(aws_instance.web_server.arn)
#     error_message = "The EC2 instance was not successfully deployed."
#   }

#   # Check: Verify the Name tag was applied correctly in reality
#   assert {
#     condition     = aws_instance.web_server.tags["Name"] == "TestServer"
#     error_message = "Deployment failed: Name tag is incorrect."
#   }
# }

# tests/deployment.tftest.hcl

# Scenario 1: Test Ubuntu Deployment
run "test_ubuntu_deployment" {
  command = plan # Switch to 'apply' for real deployment

  variables {
    os_type = "ubuntu"
  }

  assert {
    condition     = aws_instance.web_server.tags["Name"] == "TestServer-ubuntu"
    error_message = "Ubuntu tag failed"
  }
}

# Scenario 2: Test Amazon Linux Deployment
run "test_amazon_linux_deployment" {
  command = plan # Switch to 'apply' for real deployment

  variables {
    os_type = "amazon-linux"
  }

  assert {
    condition     = aws_instance.web_server.tags["Name"] == "TestServer-amazon-linux"
    error_message = "Amazon Linux tag failed"
  }
}