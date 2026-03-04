# Stage 1: Build dependencies
FROM python:3.11-slim AS builder
WORKDIR /app

# NEW: Upgrade pip and setuptools to fix the HIGH vulnerabilities found by Trivy
RUN pip install --upgrade pip setuptools wheel

COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Final Production Image
FROM python:3.11-slim
WORKDIR /app
# Only copy the installed packages from the builder
COPY --from=builder /root/.local /root/.local
COPY . .
ENV PATH=/root/.local/bin:$PATH
EXPOSE 80
CMD ["python", "app.py"]