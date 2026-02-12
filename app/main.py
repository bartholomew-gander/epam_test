from fastapi import FastAPI
import time

app = FastAPI()

# TODO: Add documentation for Swagger generation

@app.get("/")
def read_root():
    return {
        "service_info": {
            "name": "Technical Test Service",
            "version": "1.0.0",
            "endpoints": {
                "health": "/health",
                "brief": "/",
            }
        },
        "timestamp": int(time.time()),
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}
