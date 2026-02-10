# backend/src/main.py

from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy import text
from sqlalchemy.orm import Session
from .api.routers import buildings
from .db.session import get_db

app = FastAPI(
    title="Markoff Backend",
    description="API для учета помещений и пожарных датчиков",
    version="0.1.0"
)

app.include_router(buildings.router)


@app.get("/")
async def root():
    return {"message": "Markoff API is running", "status": "alive", "timestamp": "2026-02-09"}

@app.get("/health")
async def health_check():
    return {"status": "ok", "environment": "development"}

@app.get("/test-db", tags=["health"])
def test_database_connection(db: Session = Depends(get_db)):
    try:
        # Самый простой запрос, который почти всегда работает или нет
        result = db.execute(text("SELECT 1"))
        value = result.scalar()
        return {
            "status": "ok",
            "message": "Database connection successful",
            "test_query_result": value
        }
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Database connection failed: {str(e)}"
        )
        
@app.get("/schemas", tags=["health"])
def list_schemas(db: Session = Depends(get_db)):
    try:
        query = text("""
            SELECT schema_name 
            FROM information_schema.schemata 
            WHERE schema_name NOT IN ('information_schema', 'pg_catalog', 'pg_toast')
            ORDER BY schema_name;
        """)
        result = db.execute(query)
        schemas = [row[0] for row in result.fetchall()]
        
        return {
            "status": "ok",
            "schemas": schemas,
            "count": len(schemas)
        }
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Failed to list schemas: {str(e)}"
        )


@app.get("/tables", tags=["health"])
def list_tables_in_schemas(db: Session = Depends(get_db)):
    try:
        query = text("""
            SELECT table_schema, table_name
            FROM information_schema.tables
            WHERE table_schema IN ('audit', 'business', 'dictionary', 'fire', 'physical', 'security')
              AND table_type = 'BASE TABLE'
            ORDER BY table_schema, table_name;
        """)
        result = db.execute(query)
        tables = {}
        for row in result.fetchall():
            schema = row[0]
            table = row[1]
            if schema not in tables:
                tables[schema] = []
            tables[schema].append(table)
        
        return {
            "status": "ok",
            "tables_by_schema": tables,
            "total_tables": sum(len(v) for v in tables.values())
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to list tables: {str(e)}")