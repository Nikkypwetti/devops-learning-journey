# **📘 Day 5: Provisioners & Data Sources**

```markdown
# Day 5: Provisioners & Data Sources

## 🎯 Learning Objectives
- Use different provisioner types
- Work with data sources
- Handle provisioner failures
- Practice with file and remote-exec provisioners

### Video Tutorial (15 mins):
- [Terraform Provisioners](https://www.youtube.com/watch?v=7YV0e2ZSRnY)
- **Key Takeaways:**
  - Provisioners for initialization/config
  - local-exec vs remote-exec
  - When to use vs when to avoid

### Reading Material (10 mins):
- [Provisioners Documentation](https://developer.hashicorp.com/terraform/language/resources/provisioners)
- [Data Sources Documentation](https://developer.hashicorp.com/terraform/language/data-sources)
- **Focus on:**
  - Provisioner types and use cases
  - Data source patterns
  - Failure handling

### Concept Examples (5 mins):
```hcl
# File provisioner
provisioner "file" {
  source      = "scripts/setup.sh"
  destination = "/tmp/setup.sh"
}

# Remote-exec provisioner
provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/setup.sh",
    "/tmp/setup.sh",
    "echo 'Provisioning complete'"
  ]
}

# Data source example
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}