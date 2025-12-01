#!/usr/bin/env python3
"""
IAM Policy Validator Script
Validates IAM policies against security best practices
"""

import json
import os
import sys
from pathlib import Path

class PolicyValidator:
    def __init__(self):
        self.findings = []
        self.critical_findings = []
        
    def validate_policy_file(self, file_path):
        """Validate a single IAM policy file"""
        try:
            with open(file_path, 'r') as f:
                policy = json.load(f)
                
            filename = os.path.basename(file_path)
            
            # Check basic structure
            self.check_policy_structure(policy, filename)
            
            # Check statements
            statements = policy.get('Statement', [])
            if not isinstance(statements, list):
                statements = [statements]
                
            for i, statement in enumerate(statements):
                self.check_statement(statement, filename, i)
                
        except json.JSONDecodeError as e:
            self.add_finding(f"Invalid JSON in {filename}: {str(e)}", "CRITICAL")
        except Exception as e:
            self.add_finding(f"Error processing {filename}: {str(e)}", "ERROR")
    
    def check_policy_structure(self, policy, filename):
        """Check basic policy structure"""
        if 'Version' not in policy:
            self.add_finding(f"{filename}: Missing Version field", "CRITICAL")
        elif policy['Version'] != '2012-10-17':
            self.add_finding(f"{filename}: Using outdated policy version", "WARNING")
            
        if 'Statement' not in policy:
            self.add_finding(f"{filename}: Missing Statement field", "CRITICAL")
    
    def check_statement(self, statement, filename, statement_index):
        """Check individual statement"""
        sid = statement.get('Sid', f'Statement-{statement_index}')
        
        # Check for wildcard actions
        actions = statement.get('Action', [])
        if not isinstance(actions, list):
            actions = [actions]
            
        for action in actions:
            if action == '*':
                self.add_finding(
                    f"{filename} ({sid}): Wildcard action detected",
                    "CRITICAL" if statement.get('Effect') == 'Allow' else "MEDIUM"
                )
        
        # Check for wildcard resources
        resources = statement.get('Resource', [])
        if not isinstance(resources, list):
            resources = [resources]
            
        for resource in resources:
            if resource == '*':
                self.add_finding(
                    f"{filename} ({sid}): Wildcard resource detected",
                    "CRITICAL" if statement.get('Effect') == 'Allow' else "MEDIUM"
                )
        
        # Check for dangerous actions
        dangerous_actions = [
            'iam:CreateUser',
            'iam:DeleteUser',
            'iam:CreateAccessKey',
            'iam:AttachUserPolicy',
            's3:DeleteBucket',
            'ec2:TerminateInstances',
            'rds:DeleteDBInstance'
        ]
        
        for action in actions:
            if action in dangerous_actions and statement.get('Effect') == 'Allow':
                self.add_finding(
                    f"{filename} ({sid}): Allows dangerous action: {action}",
                    "HIGH"
                )
    
    def add_finding(self, message, severity):
        """Add a finding to the results"""
        finding = {
            'message': message,
            'severity': severity
        }
        
        if severity == 'CRITICAL':
            self.critical_findings.append(finding)
        else:
            self.findings.append(finding)
    
    def print_report(self):
        """Print validation report"""
        print("\n" + "="*60)
        print("IAM POLICY VALIDATION REPORT")
        print("="*60)
        
        if self.critical_findings:
            print("\n❌ CRITICAL FINDINGS:")
            for finding in self.critical_findings:
                print(f"  • {finding['message']}")
        
        if self.findings:
            print("\n⚠ OTHER FINDINGS:")
            for finding in self.findings:
                print(f"  • [{finding['severity']}] {finding['message']}")
        
        if not self.critical_findings and not self.findings:
            print("\n✅ All policies passed validation!")
        else:
            print(f"\n📊 Summary: {len(self.critical_findings)} critical, {len(self.findings)} other findings")
        
        return len(self.critical_findings) == 0

def main():
    validator = PolicyValidator()
    
    # Find all JSON policy files
    policy_dir = Path("iam-policies")
    if not policy_dir.exists():
        print(f"Error: Directory {policy_dir} not found")
        sys.exit(1)
    
    policy_files = list(policy_dir.glob("*.json"))
    
    if not policy_files:
        print("No policy files found in iam-policies/")
        sys.exit(1)
    
    print(f"Found {len(policy_files)} policy files")
    
    # Validate each file
    for policy_file in policy_files:
        print(f"\nValidating: {policy_file.name}")
        validator.validate_policy_file(policy_file)
    
    # Print report
    success = validator.print_report()
    
    # Exit with appropriate code
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()