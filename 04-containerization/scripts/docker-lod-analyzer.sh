#!/bin/bash
# Analyze Docker container logs

LOG_DIR="./docker-logs-$(date +%Y%m%d)"
mkdir -p $LOG_DIR

echo "📝 Analyzing Docker logs..."

for container in $(docker ps -a -q); do
    name=$(docker inspect $container --format '{{.Name}}' | cut -c2-)
    echo "  Processing $name..."
    
    # Get container logs
    docker logs $container 2>&1 > $LOG_DIR/$name.log
    
    # Analyze logs
    echo "=== Analysis for $name ===" > $LOG_DIR/$name-analysis.txt
    
    # Count errors
    ERROR_COUNT=$(grep -i "error\|exception\|fail" $LOG_DIR/$name.log | wc -l)
    echo "Errors found: $ERROR_COUNT" >> $LOG_DIR/$name-analysis.txt
    
    # Extract unique errors
    if [ $ERROR_COUNT -gt 0 ]; then
        echo -e "\nUnique error patterns:" >> $LOG_DIR/$name-analysis.txt
        grep -i "error\|exception\|fail" $LOG_DIR/$name.log | sort | uniq -c | sort -nr >> $LOG_DIR/$name-analysis.txt
    fi
    
    # Check for warnings
    WARN_COUNT=$(grep -i "warn" $LOG_DIR/$name.log | wc -l)
    echo -e "\nWarnings found: $WARN_COUNT" >> $LOG_DIR/$name-analysis.txt
    
    # Log timestamps (first and last)
    FIRST_LINE=$(head -1 $LOG_DIR/$name.log 2>/dev/null)
    LAST_LINE=$(tail -1 $LOG_DIR/$name.log 2>/dev/null)
    echo -e "\nLog range:" >> $LOG_DIR/$name-analysis.txt
    echo "First: $FIRST_LINE" >> $LOG_DIR/$name-analysis.txt
    echo "Last: $LAST_LINE" >> $LOG_DIR/$name-analysis.txt
done

# Generate summary report
echo "📊 Generating summary report..."
cat > $LOG_DIR/summary.txt << EOF
Docker Log Analysis Summary
Generated: $(date)
========================

Container Summary:
EOF

docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" >> $LOG_DIR/summary.txt

echo -e "\nLog Analysis Complete! Check $LOG_DIR for details."