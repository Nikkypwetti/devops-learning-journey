#!/bin/bash
# Parse Docker Bench results and highlight critical issues

echo "🔍 Analyzing Audit Results"
echo "==========================="

AUDIT_FILE="audit-results.txt"

if [ ! -f "$AUDIT_FILE" ]; then
    echo "❌ Audit file not found. Run run-audit.sh first."
    exit 1
fi

# Count results by severity
TOTAL=$(grep -c "^\[" "$AUDIT_FILE" 2>/dev/null || echo 0)
INFO=$(grep -c "\[INFO\]" "$AUDIT_FILE" 2>/dev/null || echo 0)
PASS=$(grep -c "\[PASS\]" "$AUDIT_FILE" 2>/dev/null || echo 0)
WARN=$(grep -c "\[WARN\]" "$AUDIT_FILE" 2>/dev/null || echo 0)
FAIL=$(grep -c "\[FAIL\]" "$AUDIT_FILE" 2>/dev/null || echo 0)

echo "📊 Audit Statistics:"
echo "   Total checks: $TOTAL"
echo "   ✅ PASS:      $PASS"
echo "   ⚠️  WARN:      $WARN"
echo "   ❌ FAIL:      $FAIL"
echo "   ℹ️  INFO:      $INFO"
echo ""

# Show critical failures (Section 4 & 5)
echo "🔥 Critical Failures (Sections 4-5):"
grep -E "\[FAIL\] (4\.[0-9]|5\.[0-9])" "$AUDIT_FILE" | while read -r line; do
    echo "   ❌ $line"
done

# Show warnings
echo ""
echo "⚠️  Warnings:"
grep "\[WARN\]" "$AUDIT_FILE" | head -5
if [ $(grep -c "\[WARN\]" "$AUDIT_FILE") -gt 5 ]; then
    echo "   ... and $(($(grep -c "\[WARN\]" "$AUDIT_FILE") - 5)) more warnings"
fi

# Generate remediation recommendations
echo ""
echo "🛠️  Top Remediation Priorities:"
grep "\[FAIL\] 4\.[1-5]" "$AUDIT_FILE" | head -3 | sed 's/\[FAIL\]/   🔴/'
grep "\[FAIL\] 5\.[1-5]" "$AUDIT_FILE" | head -3 | sed 's/\[FAIL\]/   🔴/'