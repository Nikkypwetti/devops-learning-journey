# Stage 1: Build dependencies
FROM python:3.11-slim AS builder
WORKDIR /app
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