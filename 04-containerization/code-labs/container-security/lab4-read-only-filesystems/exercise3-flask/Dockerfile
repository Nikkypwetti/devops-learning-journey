FROM python:3.11-slim

RUN useradd -m -u 1000 appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

# Create directories that need write access
RUN mkdir -p /data /var/log/flask && \
    chown -R appuser:appuser /app /data /var/log/flask

USER appuser

EXPOSE 5000
CMD ["python", "app.py"]