from sqlalchemy import Column, Integer, String, Float, Boolean, DateTime, ForeignKey, create_engine
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
from pydantic import BaseModel
from typing import Optional

Base = declarative_base()


class User(Base):
    __tablename__ = "user"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, nullable=False)
    role = Column(String, nullable=False)
    department = Column(String, nullable=True)


class SpecialTask(Base):
    __tablename__ = "special_task"
    id = Column(String, primary_key=True, index=True)
    personnel = Column(String, nullable=False)
    department = Column(String, nullable=False)
    task = Column(String, nullable=False)
    assigned_by = Column(String, nullable=False)
    due_date = Column(String, nullable=False)
    submitted_date = Column(String, nullable=True)
    status = Column(String, nullable=False)
    score = Column(Integer, nullable=True)


class SpecialTaskEvaluation(Base):
    __tablename__ = "special_task_evaluation"
    id = Column(Integer, primary_key=True, index=True)
    task_id = Column(String, ForeignKey("special_task.id"), nullable=False)
    coordinator_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    completion = Column(Integer, nullable=False)
    quality = Column(Integer, nullable=False)
    timeliness = Column(Integer, nullable=False)
    coordination = Column(Integer, nullable=False)
    remarks = Column(String, nullable=True)
    score = Column(Integer, nullable=False)
    submitted_at = Column(String, nullable=False, default=lambda: datetime.utcnow().isoformat())


class Event(Base):
    __tablename__ = "event"
    id = Column(String, primary_key=True, index=True)
    name = Column(String, nullable=False)
    date = Column(String, nullable=False)
    organizer = Column(String, nullable=False)
    department = Column(String, nullable=False)
    attendees = Column(Integer, default=0)


class EventEvaluation(Base):
    __tablename__ = "event_evaluation"
    id = Column(Integer, primary_key=True, index=True)
    event_id = Column(String, ForeignKey("event.id"), nullable=False)
    evaluator_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    evaluator_role = Column(String, nullable=False)
    planning = Column(Integer, nullable=False)
    objectives = Column(Integer, nullable=False)
    personnel = Column(Integer, nullable=False)
    time_mgmt = Column(Integer, nullable=False)
    engagement = Column(Integer, nullable=False)
    resource = Column(Integer, nullable=False)
    feedback_comments = Column(String, nullable=True)
    date_submitted = Column(String, nullable=False, default=lambda: datetime.utcnow().isoformat())


class ReportSubmission(Base):
    __tablename__ = "report_submission"
    submission_id = Column(Integer, primary_key=True, index=True)
    report_id = Column(Integer, nullable=False)
    personnel_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    deadline = Column(String, nullable=False)
    submitted_at = Column(String, nullable=False)
    timing_status = Column(String, nullable=False)
    timing_points = Column(Integer, nullable=False)
    content_quality_score = Column(Integer, nullable=False)
    format_compliance_score = Column(Integer, nullable=False)
    completeness_score = Column(Integer, nullable=False)


class AppraisalRecord(Base):
    __tablename__ = "appraisal_record"
    appraisal_id = Column(Integer, primary_key=True, index=True)
    personnel_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    appraisal_type = Column(String, nullable=False)
    reference_id = Column(Integer, nullable=True)
    total_points = Column(Float, nullable=False)
    star_rating = Column(Float, nullable=False)
    appraisal_status = Column(String, nullable=False)
    is_locked = Column(Boolean, default=False)
    is_archived = Column(Boolean, default=False)
    date_created = Column(String, nullable=False, default=lambda: datetime.utcnow().isoformat())


class PerformanceSummary(Base):
    __tablename__ = "performance_summary"
    summary_id = Column(Integer, primary_key=True, index=True)
    personnel_id = Column(Integer, ForeignKey("user.id"), nullable=True)
    period = Column(String, nullable=False)
    total_appraisal_points = Column(Float, nullable=False)
    avg_event_score = Column(Float, nullable=True)
    avg_task_score = Column(Float, nullable=True)
    report_timing_points = Column(Integer, default=0)
    escalation_count = Column(Integer, default=0)
    overall_grade = Column(String, nullable=True)
    summary_date = Column(String, nullable=False, default=lambda: datetime.utcnow().isoformat())


class SpecialTaskOut(BaseModel):
    id: str
    personnel: str
    department: str
    task: str
    assigned_by: str
    due_date: str
    submitted_date: Optional[str] = None
    status: str
    score: Optional[int] = None

    model_config = {"from_attributes": True}


class EvaluationIn(BaseModel):
    ratings: dict[str, int]
    remarks: Optional[str] = ""
