 
# backend/src/main.py

from fastapi import FastAPI
from .api.routers import buildings


app = FastAPI(
    title="Markoff Backend",
    description="API для учета помещений и пожарных датчиков",
    version="0.1.0"
)

@app.get("/health")
async def health_check():
    return {"status": "ok", "environment": "development"}

@app.get("/")
async def root():
    return {"message": "Markoff API is running", "status": "alive", "timestamp": "2026-02-09"}

app.include_router(buildings.router)
