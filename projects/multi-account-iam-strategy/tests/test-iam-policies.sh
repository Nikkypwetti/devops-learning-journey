#!/bin/bash

# IAM Policy Testing Script

echo "🧪 Testing IAM Policies"

# Test 1: Check JSON validity
echo "Test 1: Validating JSON syntax..."
for file in iam-policies/*.json; do
    if python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "✅ $file: Valid JSON"
    else
        echo "❌ $file: Invalid JSON"
        exit 1
    fi
done

# Test 2: Check for wildcards
echo -e "\nTest 2: Checking for wildcards..."
for file in iam-policies/*.json; do
    wildcards=$(grep -c '"Resource": "*"' "$file")
    if [ "$wildcards" -gt 0 ]; then
        echo "⚠ $file: Contains $wildcards wildcard resource(s)"
    fi
done

# Test 3: Check policy size (AWS limit is 6144 characters)
echo -e "\nTest 3: Checking policy size..."
for file in iam-policies/*.json; do
    size=$(wc -c < "$file")
    if [ "$size" -gt 6000 ]; then
        echo "⚠ $file: Large policy ($size characters)"
    else
        echo "✅ $file: Size OK ($size characters)"
    fi
done

# Test 4: Run Python validator
echo -e "\nTest 4: Running comprehensive validation..."
python3 scripts/validate-policies.py

echo -e "\n🧪 All tests completed!"