enum TaskStatus { pending, evaluated, flagged, notSubmitted }
enum EventStatus { awaitingRatings, rated, flagged }
enum TrendDirection { up, down, stable }
enum AppraisalGrade { outstanding, verySatisfactory, satisfactory, unsatisfactory }

class SpecialTask {
  final String id;
  final String personnel;
  final String department;
  final String task;
  final String assignedBy;
  final String dueDate;
  final String? submittedDate;
  final int? score;
  final TaskStatus status;

  const SpecialTask({
    required this.id,
    required this.personnel,
    required this.department,
    required this.task,
    required this.assignedBy,
    required this.dueDate,
    this.submittedDate,
    this.score,
    required this.status,
  });
}

class SchoolEvent {
  final String id;
  final String personnel;
  final String department;
  final String event;
  final String eventDate;
  final int raters;
  final double? avgScore;
  final EventStatus status;

  const SchoolEvent({
    required this.id,
    required this.personnel,
    required this.department,
    required this.event,
    required this.eventDate,
    required this.raters,
    this.avgScore,
    required this.status,
  });
}

class FacultyPerformance {
  final String name;
  final String department;
  final int? reportScore;
  final int? taskScore;
  final int? eventScore;
  final int overallScore;
  final AppraisalGrade grade;
  final TrendDirection trend;

  const FacultyPerformance({
    required this.name,
    required this.department,
    this.reportScore,
    this.taskScore,
    this.eventScore,
    required this.overallScore,
    required this.grade,
    required this.trend,
  });
}

class MonthlyTrend {
  final String month;
  final double? reportScore;
  final double? taskScore;
  final double? eventScore;

  const MonthlyTrend({
    required this.month,
    this.reportScore,
    this.taskScore,
    this.eventScore,
  });
}

// ── Sample data ──────────────────────────────────────────────────────────────

final List<SpecialTask> sampleTasks = [
  const SpecialTask(
    id: 'ST001', personnel: 'John Smith', department: 'Engineering',
    task: 'Curriculum Revie...', assignedBy: 'Dr. Rivera',
    dueDate: '4/15/2025', submittedDate: '4/14/2025',
    score: null, status: TaskStatus.pending,
  ),
  const SpecialTask(
    id: 'ST002', personnel: 'Sarah Johnson', department: 'Business',
    task: 'Faculty...', assignedBy: 'Dr. Cruz',
    dueDate: '4/10/2025', submittedDate: '4/11/2025',
    score: 67, status: TaskStatus.evaluated,
  ),
  const SpecialTask(
    id: 'ST003', personnel: 'Mike Chen', department: 'Sciences',
    task: 'Laboratory Safet...', assignedBy: 'Dr. Santos',
    dueDate: '4/5/2025', submittedDate: '4/3/2025',
    score: 100, status: TaskStatus.evaluated,
  ),
  const SpecialTask(
    id: 'ST004', personnel: 'Alice Brown', department: 'Humanities',
    task: 'Research Output...', assignedBy: 'Dr. Reyes',
    dueDate: '3/30/2025', submittedDate: null,
    score: 28, status: TaskStatus.flagged,
  ),
];

final List<SchoolEvent> sampleEvents = [
  const SchoolEvent(
    id: 'EV001', personnel: 'David Lee', department: 'HR & Training',
    event: 'Leadership Seminar 2025', eventDate: '4/20/2025',
    raters: 3, avgScore: 4.61, status: EventStatus.rated,
  ),
  const SchoolEvent(
    id: 'EV002', personnel: 'Maria Santos', department: 'Sciences',
    event: 'Science Fair Coordination', eventDate: '4/10/2025',
    raters: 2, avgScore: 2.33, status: EventStatus.flagged,
  ),
  const SchoolEvent(
    id: 'EV003', personnel: 'Robert Cruz', department: 'Engineering',
    event: 'Tech Innovation Summit', eventDate: '5/5/2025',
    raters: 0, avgScore: null, status: EventStatus.awaitingRatings,
  ),
  const SchoolEvent(
    id: 'EV004', personnel: 'Jennifer Park', department: 'Business',
    event: 'Professional Development Workshop', eventDate: '4/25/2025',
    raters: 4, avgScore: 4.25, status: EventStatus.rated,
  ),
];

final List<FacultyPerformance> sampleFaculty = [
  const FacultyPerformance(
    name: 'John Smith', department: 'Engineering',
    reportScore: 92, taskScore: null, eventScore: null,
    overallScore: 92, grade: AppraisalGrade.outstanding, trend: TrendDirection.up,
  ),
  const FacultyPerformance(
    name: 'Sarah Johnson', department: 'Business',
    reportScore: 85, taskScore: 67, eventScore: null,
    overallScore: 76, grade: AppraisalGrade.satisfactory, trend: TrendDirection.stable,
  ),
  const FacultyPerformance(
    name: 'Mike Chen', department: 'Sciences',
    reportScore: 100, taskScore: 100, eventScore: null,
    overallScore: 100, grade: AppraisalGrade.outstanding, trend: TrendDirection.up,
  ),
  const FacultyPerformance(
    name: 'Alice Brown', department: 'Humanities',
    reportScore: 60, taskScore: 28, eventScore: null,
    overallScore: 44, grade: AppraisalGrade.unsatisfactory, trend: TrendDirection.down,
  ),
  const FacultyPerformance(
    name: 'David Lee', department: 'HR & Training',
    reportScore: 78, taskScore: null, eventScore: 92,
    overallScore: 85, grade: AppraisalGrade.verySatisfactory, trend: TrendDirection.up,
  ),
  const FacultyPerformance(
    name: 'Maria Santos', department: 'Sciences',
    reportScore: 70, taskScore: null, eventScore: 47,
    overallScore: 59, grade: AppraisalGrade.unsatisfactory, trend: TrendDirection.down,
  ),
];

final List<MonthlyTrend> sampleTrends = [
  const MonthlyTrend(month: 'Jan', reportScore: 82, taskScore: 80, eventScore: 83),
  const MonthlyTrend(month: 'Feb', reportScore: 82, taskScore: 80, eventScore: 82),
  const MonthlyTrend(month: 'Mar', reportScore: 81, taskScore: 79, eventScore: 81.5),
  const MonthlyTrend(month: 'Apr', reportScore: 83, taskScore: 81, eventScore: 84),
  const MonthlyTrend(month: 'May', reportScore: 82, taskScore: 80, eventScore: 82),
];
