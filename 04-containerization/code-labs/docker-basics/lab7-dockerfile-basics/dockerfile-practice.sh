#!/bin/bash
echo "📝 Dockerfile Practice"
echo "======================"
Create simple web files

mkdir -p web-files
cat > web-files/index.html << 'END'
<!DOCTYPE html><html> <head><title>Docker Practice</title></head> <body> <h1>Success! 🎉</h1> <p>This page is served from a custom Docker image.</p> </body> </html> END
Create Dockerfile

cat > Dockerfile.practice << 'END'
FROM nginx:alpine
COPY web-files/index.html /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3
CMD wget --no-verbose --tries=1 --spider http://localhost:80/ || exit 1
END
Build image

echo -e "\n1️⃣ Building image..."
docker build -f Dockerfile.practice -t practice-web .
Run container

echo -e "\n2️⃣ Running container..."
docker run -d --name practice-web -p 8080:80 practice-web
Test

echo -e "\n3️⃣ Testing web server..."
curl -s http://localhost:8080 | grep -o "<title>.*</title>"
Show image size

echo -e "\n4️⃣ Image size:"
docker images practice-web --format "table {{.Repository}}\t{{.Size}}"
Clean up

echo -e "\n5️⃣ Cleaning up..."
docker rm -f practice-web
docker rmi practice-web
rm -rf web-files

echo -e "\n✅ Practice complete!"