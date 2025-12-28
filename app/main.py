from fastapi import FastAPI
import logging
import os

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

app = FastAPI()

APP_VERSION = os.getenv("APP_VERSION", "0.1.0")

@app.get("/health")
def health():
    logging.info("Health check called")
    return {"status": "ok"}

@app.get("/version")
def version():
    return {"version": APP_VERSION}

