import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'models/appraisal_models.dart';

class SpecialTasksTab extends StatefulWidget {
  const SpecialTasksTab({super.key});

  @override
  State<SpecialTasksTab> createState() => _SpecialTasksTabState();
}

class _SpecialTasksTabState extends State<SpecialTasksTab> {
  String _filterType = 'all'; // 'all', 'personnel', 'task'
  String? _selectedPersonnel;
  String? _selectedTask;

  List<SpecialTask> get _filteredTasks {
    if (_filterType == 'personnel' && _selectedPersonnel != null) {
      return sampleTasks.where((t) => t.personnel == _selectedPersonnel).toList();
    } else if (_filterType == 'task' && _selectedTask != null) {
      return sampleTasks.where((t) => t.task == _selectedTask).toList();
    }
    return sampleTasks;
  }

  @override
  Widget build(BuildContext context) {
    final pending = _filteredTasks.where((t) => t.status == TaskStatus.pending).length;
    final evaluated = _filteredTasks.where((t) => t.status == TaskStatus.evaluated).length;
    final flagged = _filteredTasks.where((t) => t.status == TaskStatus.flagged).length;
    final scores = _filteredTasks.where((t) => t.score != null).map((t) => t.score!);
    final avgScore = scores.isEmpty ? 0 : scores.reduce((a, b) => a + b) ~/ scores.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter controls
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: _filterType,
                        decoration: InputDecoration(
                          labelText: 'Filter by',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All Tasks')),
                          DropdownMenuItem(value: 'personnel', child: Text('By Personnel')),
                          DropdownMenuItem(value: 'task', child: Text('By Task')),
                        ],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() {
                              _filterType = v;
                              _selectedPersonnel = null;
                              _selectedTask = null;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (_filterType == 'personnel')
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedPersonnel,
                          decoration: InputDecoration(
                            labelText: 'Select Personnel',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: sampleTasks
                              .map((t) => t.personnel)
                              .toSet()
                              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedPersonnel = v),
                        ),
                      ),
                    if (_filterType == 'task')
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedTask,
                          decoration: InputDecoration(
                            labelText: 'Select Task',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          items: sampleTasks
                              .map((t) => t.task)
                              .toSet()
                              .map((tk) => DropdownMenuItem(value: tk, child: Text(tk)))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedTask = v),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stat cards
          Row(children: [
            Expanded(child: StatCard(label: 'Pending', value: '$pending', valueColor: AppColors.warning, icon: const Icon(Icons.schedule, color: AppColors.warning, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Evaluated', value: '$evaluated', valueColor: AppColors.success, icon: const Icon(Icons.check_circle, color: AppColors.success, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Flagged', value: '$flagged', valueColor: AppColors.danger, icon: const Icon(Icons.flag, color: AppColors.danger, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Avg Score', value: '$avgScore/100', valueColor: AppColors.textPrimary, icon: const Icon(Icons.trending_up, color: AppColors.textPrimary, size: 20))),
          ]),
          const SizedBox(height: 20),

          // Weighted scoring breakdown card
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weighted Scoring Breakdown (Total: 100 pts)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 14),
                Row(children: [
                  _WeightItem(emoji: '✅', label: 'Task Completion', pct: '35%', color: AppColors.success),
                  const SizedBox(width: 24),
                  _WeightItem(emoji: '🏆', label: 'Quality of Output', pct: '30%', color: AppColors.amber),
                  const SizedBox(width: 24),
                  _WeightItem(emoji: '⏰', label: 'Timeliness', pct: '20%', color: Color(0xFFA78BFA)),
                  const SizedBox(width: 24),
                  _WeightItem(emoji: '💬', label: 'Coordination & Communication', pct: '15%', color: Color(0xFFFB7185)),
                ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warningBannerBg,
                    border: Border.all(color: AppColors.warningBannerBdr, width: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.flag, color: AppColors.danger, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Scores below 60/100 are automatically flagged and supervisor is alerted.',
                          style: TextStyle(color: AppColors.warningBannerFg, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Table card
          SectionCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Special Task Evaluations', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                _TaskTable(tasks: _filteredTasks),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String pct;
  final Color color;

  const _WeightItem({required this.emoji, required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
            Text(pct, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _TaskTable extends StatelessWidget {
  final List<SpecialTask> tasks;

  const _TaskTable({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(50),
          1: FixedColumnWidth(120),
          2: FixedColumnWidth(100),
          3: FixedColumnWidth(160),
          4: FixedColumnWidth(100),
          5: FixedColumnWidth(80),
          6: FixedColumnWidth(80),
          7: FixedColumnWidth(80),
          8: FixedColumnWidth(80),
          9: FixedColumnWidth(80),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.tableHeaderBg,
              border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
            ),
            children: ['ID', 'PERSONNEL', 'DEPARTMENT', 'TASK', 'ASSIGNED BY', 'DUE DATE', 'SUBMITTED', 'SCORE', 'STATUS', 'ACTION']
                .map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                )).toList(),
          ),
          ...tasks.map((task) => _buildRow(task)),
        ],
      ),
    );
  }

  TableRow _buildRow(SpecialTask task) {
    Widget submittedWidget;
    if (task.submittedDate != null) {
      submittedWidget = Text(task.submittedDate!, style: const TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w500));
    } else {
      submittedWidget = const Text('Not Submitted', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w500));
    }

    Widget scoreWidget;
    if (task.score != null) {
      final scoreColor = task.score! >= 80 ? AppColors.success : task.score! >= 60 ? AppColors.warning : AppColors.danger;
      scoreWidget = Text('${task.score}/100', style: TextStyle(color: scoreColor, fontSize: 12, fontWeight: FontWeight.w600));
    } else {
      scoreWidget = const Text('—', style: TextStyle(color: AppColors.textHint, fontSize: 12));
    }

    Widget statusWidget;
    switch (task.status) {
      case TaskStatus.pending:
        statusWidget = const Text('Pending', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w500));
      case TaskStatus.evaluated:
        statusWidget = const Text('Evaluated', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w500));
      case TaskStatus.flagged:
        statusWidget = const Text('Flagged', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w500));
      case TaskStatus.notSubmitted:
        statusWidget = const Text('Not Submitted', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w500));
    }

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      children: [
        _cell(Text(task.id, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
        _cell(Row(children: [
          PersonAvatar(name: task.personnel),
          const SizedBox(width: 6),
          Expanded(child: Text(task.personnel, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
        ])),
        _cell(Text(task.department, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(Text(task.task, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
        _cell(Text(task.assignedBy, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(Text(task.dueDate, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(submittedWidget),
        _cell(scoreWidget),
        _cell(statusWidget),
        _cell(SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tabActive,
              padding: EdgeInsets.zero,
              minimumSize: const Size(70, 30),
            ),
            child: const Text('View', style: TextStyle(fontSize: 11, color: Colors.white)),
          ),
        )),
      ],
    );
  }

  Widget _cell(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    child: child,
  );
}
