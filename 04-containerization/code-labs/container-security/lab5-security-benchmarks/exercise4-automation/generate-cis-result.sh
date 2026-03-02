#!/bin/bash
# Generate HTML report of CIS compliance

OUTPUT="cis-report-$(date +%Y%m%d).html"

cat > "$OUTPUT" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>CIS Docker Compliance Report</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h1 { color: #333; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .card { 
            padding: 15px; 
            border-radius: 5px; 
            background: #f5f5f5;
            flex: 1;
        }
        .pass { color: green; }
        .fail { color: red; }
        .warn { color: orange; }
        table { border-collapse: collapse; width: 100%; }
        th, td { 
            border: 1px solid #ddd; 
            padding: 8px; 
            text-align: left; 
        }
        th { background-color: #4CAF50; color: white; }
    </style>
</head>
<body>
    <h1>CIS Docker Benchmark Compliance Report</h1>
    <p>Generated: $(date)</p>
    
    <div class="summary">
EOF

# Add summary stats
PASS=$(grep -c "\[PASS\]" bench-results.txt || echo 0)
FAIL=$(grep -c "\[FAIL\]" bench-results.txt || echo 0)
WARN=$(grep -c "\[WARN\]" bench-results.txt || echo 0)

cat >> "$OUTPUT" << EOF
        <div class="card">
            <h3>✅ Pass</h3>
            <p class="pass">$PASS</p>
        </div>
        <div class="card">
            <h3>❌ Fail</h3>
            <p class="fail">$FAIL</p>
        </div>
        <div class="card">
            <h3>⚠️ Warn</h3>
            <p class="warn">$WARN</p>
        </div>
    </div>
    
    <h2>Section 4: Container Images</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Status</th>
            <th>Description</th>
        </tr>
EOF

# Parse results and add to table
grep -E "\[(PASS|FAIL|WARN)\] 4\.[0-9]+" bench-results.txt | while read -r line; do
    status=$(echo "$line" | cut -d' ' -f1 | tr -d '[]')
    id=$(echo "$line" | cut -d' ' -f2)
    desc=$(echo "$line" | cut -d' ' -f3-)
    
    color="black"
    [ "$status" = "PASS" ] && color="green"
    [ "$status" = "FAIL" ] && color="red"
    [ "$status" = "WARN" ] && color="orange"
    
    echo "<tr><td>$id</td><td style='color:$color'>$status</td><td>$desc</td></tr>" >> "$OUTPUT"
done

cat >> "$OUTPUT" << 'EOF'
    </table>
    
    <h2>Remediation Recommendations</h2>
    <ul>
EOF

# Add remediation recommendations
grep "\[FAIL\]" bench-results.txt | head -10 | while read -r line; do
    echo "<li><strong>Fix:</strong> $line</li>" >> "$OUTPUT"
done

cat >> "$OUTPUT" << 'EOF'
    </ul>
</body>
</html>
EOF

echo "✅ Report generated: $OUTPUT"