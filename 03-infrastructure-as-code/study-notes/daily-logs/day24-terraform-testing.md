# Day 24: Terraform Testing

## What I Learned

Concept 1: What is Terraform Testing?
    Terraform testing is the process of verifying that your Infrastructure as Code (IaC) configuration works as expected before deployment. It helps identify bugs, logic errors, and security risks early in the development cycle.

Concept 2: Unit Testing vs. Integration Testing
    In Terraform, Unit Tests (check-only) validate configurations without actually deploying resources, often using `plan`. Integration Tests (deploy-and-verify) involve creating real resources in a temporary environment, running checks, and then destroying them.

Concept 3: The Native Test Framework (`terraform test`)
    Introduced in Terraform 1.6, this is a built-in framework that uses HashiCorp Configuration Language (HCL) to write tests. It eliminates the need for external tools like Go-based Terratest for many common use cases.

Concept 4: Test Files (`.tftest.hcl`)
    Tests are stored in a dedicated `tests/` directory. Files ending in `.tftest.hcl` are automatically discovered by Terraform. These files contain variables, providers, and `run` blocks.

Concept 5: The `run` Block
    The `run` block is the primary unit of a test. Each block can execute a `plan` or an `apply`. It allows you to modularize testing steps, such as setting up a network in one block and testing a resource inside that network in the next.

Concept 6: Assertions
    Inside a `run` block, `assert` blocks define the conditions for success. Each assertion requires a `condition` (a boolean expression) and an `error_message` that displays if the condition fails.

Concept 7: Mocking and Overrides
    For faster unit tests, Terraform allows you to mock data or override certain values within the test files, ensuring you don't always need to hit a cloud provider's API to verify logic.

## Code Practice Terraform

Terraform

# tests/ec2_validation.tftest.hcl - Validating resource attributes

# 1. Setup Variables for the test
variables {
  instance_type = "t3.micro"
}

# 2. Define the Run block
run "verify_instance_configuration" {
  command = plan # This is a Unit Test

  # 3. Assertions to check conditions
  assert {
    condition     = aws_instance.web.instance_type == "t3.micro"
    error_message = "EC2 instance type must be t3.micro for development"
  }

  assert {
    condition     = contains(keys(aws_instance.web.tags), "Environment")
    error_message = "EC2 instance is missing the required 'Environment' tag"
  }
}

## Commands Used Bash

Initialize the directory (required to download the test framework)

terraform init
Execute all tests in the /tests directory

terraform test
Run a specific test file

terraform test -filter=tests/ec2_validation.tftest.hcl
Check syntax and validity of the main configuration

terraform validate

## Challenges

Problem: Tests failing because of existing resources or state conflicts.
Solution: Ensured that integration tests (`command = apply`) were run in a clean environment or used unique naming conventions for resources to avoid collisions with production infrastructure.

Problem: Testing complex logic inside modules.
Solution: Leveraged the `run` block's ability to output values, allowing me to pass the output of one test stage as an input to another.

## Resources

Video Tutorial
    Video: [https://www.youtube.com/watch?v=urMvGXfBDdc](https://www.youtube.com/watch?v=urMvGXfBDdc) (12 mins)

## Documentation

    Reading: [https://developer.hashicorp.com/terraform/language/tests](https://developer.hashicorp.com/terraform/language/tests)

## Practice Exercise: Writing Your First Test

Objective: Write a test to ensure an AWS EC2 instance has the correct "Environment" tag.

    Create your main config (main.tf):
    Terraform

resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  tags = {
    Name        = "HelloWorld"
    Environment = "Dev"
  }
}

Create a tests directory: mkdir tests

Create tests/tags.tftest.hcl:
Terraform

run "validate_tags" {
  command = plan

  assert {
    condition     = aws_instance.web.tags["Environment"] == "Dev"
    error_message = "The Environment tag must be set to 'Dev'"
  }
}

Run the test: Execute terraform test in your terminal and observe the pass/fail result.

## Tomorrow's Plan

Topic 1: Terraform Cloud & Enterprise (Remote State and Governance)
Topic 2: Policy as Code with Sentinel or OPA (Open Policy Agent)