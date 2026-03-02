#!/bin/bash
# Real-time Docker container monitoring

while true; do
    clear
    echo "📊 Docker Container Monitor - $(date)"
    echo "========================================"
    
    # Show container stats
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"
    
    echo -e "\n🔍 Container Health:"
    for container in $(docker ps -q); do
        name=$(docker inspect $container --format '{{.Name}}' | cut -c2-)
        status=$(docker inspect $container --format '{{.State.Status}}')
        health=$(docker inspect $container --format '{{if .State.Health}}{{.State.Health.Status}}{{else}}no healthcheck{{end}}')
        
        if [ "$health" = "healthy" ]; then
            echo "  ✅ $name: $status (healthy)"
        elif [ "$health" = "unhealthy" ]; then
            echo "  ❌ $name: $status (UNHEALTHY!)"
        else
            echo "  ⚪ $name: $status ($health)"
        fi
    done
    
    echo -e "\n💾 Disk Usage:"
    docker system df
    
    sleep 5
done