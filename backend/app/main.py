from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from datetime import datetime
import os

from sqlalchemy import create_engine, select
from sqlalchemy.orm import sessionmaker, Session

from .models import Base, SpecialTask, SpecialTaskEvaluation, SpecialTaskOut, EvaluationIn


app = FastAPI(title="Personnel Appraisal API")

# Allow local development origins
ALLOWED_ORIGINS = [
    "http://localhost",
    "http://localhost:8000",
    "http://127.0.0.1",
    "http://127.0.0.1:8000",
    "http://localhost:3000",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database setup
DATABASE_URL = os.environ.get("DATABASE_URL") or "sqlite:///./dev.db"
engine = create_engine(DATABASE_URL, echo=False, connect_args={"check_same_thread": False} if "sqlite" in DATABASE_URL else {})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.on_event("startup")
def on_startup():
    Base.metadata.create_all(bind=engine)
    # seed tasks if empty
    db = SessionLocal()
    try:
        count = db.query(SpecialTask).count()
        if count == 0:
            samples = [
                SpecialTask(id="ST001", personnel="John Smith", department="Engineering", task="Curriculum Review Documentation", assigned_by="Dr. Rivera", due_date="2025-04-15", submitted_date="2025-04-14", status="pending", score=None),
                SpecialTask(id="ST002", personnel="Sarah Johnson", department="Business", task="Faculty Development Workshop Facilitation", assigned_by="Dr. Cruz", due_date="2025-04-10", submitted_date="2025-04-11", status="evaluated", score=70),
                SpecialTask(id="ST003", personnel="Mike Chen", department="Sciences", task="Laboratory Safety Compliance Report", assigned_by="Dr. Santos", due_date="2025-04-05", submitted_date="2025-04-03", status="evaluated", score=100),
                SpecialTask(id="ST004", personnel="Alice Brown", department="Humanities", task="Research Output Documentation", assigned_by="Dr. Reyes", due_date="2025-03-30", submitted_date=None, status="flagged", score=28),
                SpecialTask(id="ST005", personnel="John Smith", department="Engineering", task="Faculty Development Workshop Facilitation", assigned_by="Dr. Rivera", due_date="2025-04-20", submitted_date="2025-04-19", status="evaluated", score=94),
                SpecialTask(id="ST006", personnel="Sarah Johnson", department="Business", task="Laboratory Safety Compliance Report", assigned_by="Dr. Cruz", due_date="2025-04-25", submitted_date=None, status="notSubmitted", score=None),
            ]
            db.add_all(samples)
            db.commit()
    finally:
        db.close()


@app.get("/health")
def health():
    return {"status": "ok", "time": datetime.utcnow().isoformat()}


@app.get("/special-tasks", response_model=List[SpecialTaskOut])
def list_special_tasks(db: Session = Depends(get_session)):
    tasks = db.query(SpecialTask).all()
    return tasks


@app.get("/special-tasks/{task_id}")
def get_task(task_id: str, db: Session = Depends(get_session)):
    t = db.query(SpecialTask).filter(SpecialTask.id == task_id).first()
    if not t:
        raise HTTPException(status_code=404, detail="Task not found")
    eval_data = db.query(SpecialTaskEvaluation).filter(SpecialTaskEvaluation.task_id == task_id).first()
    return {"task": t, "evaluation": eval_data}


@app.post("/special-tasks/{task_id}/evaluate")
def evaluate_task(task_id: str, payload: EvaluationIn, db: Session = Depends(get_session)):
    t = db.query(SpecialTask).filter(SpecialTask.id == task_id).first()
    if not t:
        raise HTTPException(status_code=404, detail="Task not found")
    
    weights = {"completion": 35, "quality": 30, "timeliness": 20, "coordination": 15}
    total = 0.0
    for k, w in weights.items():
        v = payload.ratings.get(k, 0)
        total += (v / 5.0) * w
    score = round(total)
    
    # upsert evaluation
    existing = db.query(SpecialTaskEvaluation).filter(SpecialTaskEvaluation.task_id == task_id).first()
    if existing:
        existing.completion = payload.ratings.get('completion', 0)
        existing.quality = payload.ratings.get('quality', 0)
        existing.timeliness = payload.ratings.get('timeliness', 0)
        existing.coordination = payload.ratings.get('coordination', 0)
        existing.remarks = payload.remarks
        existing.score = score
        existing.submitted_at = datetime.utcnow().isoformat()
        db.add(existing)
    else:
        eval_obj = SpecialTaskEvaluation(
            task_id=task_id,
            completion=payload.ratings.get('completion', 0),
            quality=payload.ratings.get('quality', 0),
            timeliness=payload.ratings.get('timeliness', 0),
            coordination=payload.ratings.get('coordination', 0),
            remarks=payload.remarks,
            score=score
        )
        db.add(eval_obj)
    
    # update task
    t.score = score
    t.status = "evaluated" if score >= 60 else "flagged"
    db.add(t)
    db.commit()
    db.refresh(t)
    
    return {"task": t, "evaluation": existing or eval_obj}
