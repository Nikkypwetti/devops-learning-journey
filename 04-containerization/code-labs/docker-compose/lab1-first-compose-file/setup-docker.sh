#!/bin/bash
# ============================================
# Complete Setup Script for Docker Compose Labs
# ============================================

set -e

echo "🔧 Setting up Docker Compose Labs..."
echo "====================================="
echo ""

mkdir -p docker-compose
cd docker-compose

# ============================================
# LAB 1: First Compose File
# ============================================
echo "📁 Creating Lab 1: First Compose File..."
mkdir -p lab1-first-compose-file
cd lab1-first-compose-file
