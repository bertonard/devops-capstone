# ---------- Builder stage ----------
FROM python:3.12-slim AS builder

WORKDIR /install

COPY app/requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---------- Runtime stage ----------
#FROM python:3.12-slim
FROM python:3.12-slim

#RUN apt-get update && apt-get install -y --no-install-recommends \
 #   curl \
  #  && rm -rf /var/lib/apt/lists/*


ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy installed dependencies from builder
COPY --from=builder /install /usr/local

# Copy application code
COPY app/ .

# Create non-root user
RUN useradd -m appuser
USER appuser

EXPOSE 8000

# Healthcheck (Docker-level)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

