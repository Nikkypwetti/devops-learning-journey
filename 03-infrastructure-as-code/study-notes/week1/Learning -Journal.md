# Week 1 Learning Journal

## Date: [Current Date]
## Week: 1 of 4
## Focus: Terraform Fundamentals

## What I Accomplished:

1. ✅ Installed and configured Terraform
2. ✅ Learned HCL syntax and structure
3. ✅ Deployed AWS resources (EC2, S3, VPC)
4. ✅ Managed state with S3 backend
5. ✅ Completed static website project
6. ✅ Documented all learnings

## Key Insights:

- Terraform's declarative approach is powerful
- State management is critical for team collaboration
- Modular code is easier to maintain
- AWS Free Tier makes practice affordable

## Challenges Overcome:

1. **State Locking Issues**: Learned to use DynamoDB for locking
2. **Provider Configuration**: Understood provider version constraints
3. **Variable Validation**: Implemented input validation
4. **Resource Dependencies**: Managed implicit/explicit dependencies

## Skills Developed:

- Infrastructure as Code mindset
- AWS service integration
- Configuration management
- Troubleshooting skills
- Documentation practices

## Resources Created:

- [Static Website Project](/projects/static-website)
- [Terraform Cheatsheets](/cheatsheets)
- [Learning Notes](/study-notes/week1)
- [Practice Code](/code-labs)

## Next Steps:

1. Review Week 1 concepts
2. Complete any pending exercises
3. Prepare for Week 2 modules
4. Join Terraform community

## Self-Rating: 8/10

**Strengths**: Practical implementation, documentation
**Areas to Improve**: Advanced debugging, performance optimization

## What to do if you see "Merge Conflicts"

If you and the remote version both changed the same line of the same file, Git will pause and ask you to fix it.

    Open the file with the conflict in VS Code (it will be highlighted in red).

    Choose which version to keep.

    Save the file, then run:
    Bash

git add .
git rebase --continue
git push origin main

## Quote of the Week:

 "Infrastructure as Code is not about writing code, it's about thinking in infrastructure as software."