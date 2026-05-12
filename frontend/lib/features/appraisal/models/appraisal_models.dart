enum TaskStatus { pending, evaluated, flagged, notSubmitted }
enum EventStatus { awaitingRatings, rated, flagged }
enum TrendDirection { up, down, stable }
enum AppraisalGrade { outstanding, verySatisfactory, satisfactory, unsatisfactory }

class SpecialTask {
  final String id;
  final String personnel;
  final String department;
  final String task;           // full task name
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
  final String name;
  final String date;
  final String organizer;
  final int attendees;
  final int responses;
  final double? avgRating;
  final EventStatus status;

  const SchoolEvent({
    required this.id,
    required this.name,
    required this.date,
    required this.organizer,
    required this.attendees,
    required this.responses,
    this.avgRating,
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
  final double reportScore;
  final double taskScore;
  final double eventScore;

  const MonthlyTrend({
    required this.month,
    required this.reportScore,
    required this.taskScore,
    required this.eventScore,
  });
}

// ── Sample data ───────────────────────────────────────────────────────────────

final List<SpecialTask> sampleTasks = [
  const SpecialTask(
    id: 'ST001',
    personnel: 'John Smith',
    department: 'Engineering',
    task: 'Curriculum Review Documentation',
    assignedBy: 'Dr. Rivera',
    dueDate: '4/15/2025',
    submittedDate: '4/14/2025',
    score: null,
    status: TaskStatus.pending,
  ),
  const SpecialTask(
    id: 'ST002',
    personnel: 'Sarah Johnson',
    department: 'Business',
    task: 'Faculty Development Workshop Facilitation',
    assignedBy: 'Dr. Cruz',
    dueDate: '4/10/2025',
    submittedDate: '4/11/2025',
    score: 67,
    status: TaskStatus.evaluated,
  ),
  const SpecialTask(
    id: 'ST003',
    personnel: 'Mike Chen',
    department: 'Sciences',
    task: 'Laboratory Safety Compliance Report',
    assignedBy: 'Dr. Santos',
    dueDate: '4/5/2025',
    submittedDate: '4/3/2025',
    score: 100,
    status: TaskStatus.evaluated,
  ),
  const SpecialTask(
    id: 'ST004',
    personnel: 'Alice Brown',
    department: 'Humanities',
    task: 'Research Output Documentation',
    assignedBy: 'Dr. Reyes',
    dueDate: '3/30/2025',
    submittedDate: null,
    score: 28,
    status: TaskStatus.flagged,
  ),
  const SpecialTask(
    id: 'ST005',
    personnel: 'John Smith',
    department: 'Engineering',
    task: 'Faculty Development Workshop Facilitation',
    assignedBy: 'Dr. Rivera',
    dueDate: '4/20/2025',
    submittedDate: '4/19/2025',
    score: 88,
    status: TaskStatus.evaluated,
  ),
  const SpecialTask(
    id: 'ST006',
    personnel: 'Sarah Johnson',
    department: 'Business',
    task: 'Laboratory Safety Compliance Report',
    assignedBy: 'Dr. Cruz',
    dueDate: '4/25/2025',
    submittedDate: null,
    score: null,
    status: TaskStatus.notSubmitted,
  ),
];

final List<SchoolEvent> sampleEvents = [
  const SchoolEvent(
    id: 'EV001',
    name: 'Science Fair 2025',
    date: '4/20/2025',
    organizer: 'Dr. Santos',
    attendees: 250,
    responses: 210,
    avgRating: 4.5,
    status: EventStatus.rated,
  ),
  const SchoolEvent(
    id: 'EV002',
    name: 'Faculty Development Workshop',
    date: '4/15/2025',
    organizer: 'Dr. Cruz',
    attendees: 45,
    responses: 38,
    avgRating: 3.8,
    status: EventStatus.rated,
  ),
  const SchoolEvent(
    id: 'EV003',
    name: 'Sports Fest Opening Ceremony',
    date: '4/10/2025',
    organizer: 'Dr. Rivera',
    attendees: 500,
    responses: 420,
    avgRating: 4.8,
    status: EventStatus.rated,
  ),
  const SchoolEvent(
    id: 'EV004',
    name: 'Research Symposium',
    date: '4/5/2025',
    organizer: 'Dr. Reyes',
    attendees: 80,
    responses: 12,
    avgRating: 2.3,
    status: EventStatus.flagged,
  ),
  const SchoolEvent(
    id: 'EV005',
    name: 'Community Outreach Program',
    date: '4/25/2025',
    organizer: 'Dr. Lopez',
    attendees: 150,
    responses: 0,
    avgRating: null,
    status: EventStatus.awaitingRatings,
  ),
];

final List<FacultyPerformance> sampleFaculty = [
  const FacultyPerformance(
    name: 'John Smith', department: 'Engineering',
    reportScore: 92, taskScore: 88, eventScore: null,
    overallScore: 90, grade: AppraisalGrade.outstanding,
    trend: TrendDirection.up,
  ),
  const FacultyPerformance(
    name: 'Sarah Johnson', department: 'Business',
    reportScore: 85, taskScore: 67, eventScore: null,
    overallScore: 76, grade: AppraisalGrade.satisfactory,
    trend: TrendDirection.stable,
  ),
  const FacultyPerformance(
    name: 'Mike Chen', department: 'Sciences',
    reportScore: 100, taskScore: 100, eventScore: null,
    overallScore: 100, grade: AppraisalGrade.outstanding,
    trend: TrendDirection.up,
  ),
  const FacultyPerformance(
    name: 'Alice Brown', department: 'Humanities',
    reportScore: 60, taskScore: 28, eventScore: null,
    overallScore: 44, grade: AppraisalGrade.unsatisfactory,
    trend: TrendDirection.down,
  ),
];

final List<MonthlyTrend> sampleTrends = [
  const MonthlyTrend(month: 'Sep', reportScore: 72.3, taskScore: 70.0, eventScore: 74.0),
  const MonthlyTrend(month: 'Oct', reportScore: 75.1, taskScore: 73.0, eventScore: 76.5),
  const MonthlyTrend(month: 'Nov', reportScore: 76.8, taskScore: 75.0, eventScore: 78.0),
  const MonthlyTrend(month: 'Dec', reportScore: 77.5, taskScore: 76.0, eventScore: 79.0),
  const MonthlyTrend(month: 'Jan', reportScore: 79.2, taskScore: 78.0, eventScore: 80.5),
  const MonthlyTrend(month: 'Feb', reportScore: 80.4, taskScore: 79.5, eventScore: 81.8),
  const MonthlyTrend(month: 'Mar', reportScore: 81.6, taskScore: 80.8, eventScore: 83.0),
  const MonthlyTrend(month: 'Apr', reportScore: 83.1, taskScore: 82.0, eventScore: 84.5),
];