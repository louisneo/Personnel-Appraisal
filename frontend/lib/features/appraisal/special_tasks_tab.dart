import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'models/appraisal_models.dart';

enum _FilterMode { all, byPersonnel, byTask }

class SpecialTasksTab extends StatefulWidget {
  const SpecialTasksTab({super.key});

  @override
  State<SpecialTasksTab> createState() => _SpecialTasksTabState();
}

class _SpecialTasksTabState extends State<SpecialTasksTab> {
  _FilterMode _filterMode = _FilterMode.all;
  String? _selectedPersonnel;
  String? _selectedTask;

  List<String> get _personnelList =>
      sampleTasks.map((t) => t.personnel).toSet().toList()..sort();

  List<String> get _taskList =>
      sampleTasks.map((t) => t.task).toSet().toList()..sort();

  List<SpecialTask> get _filteredTasks {
    switch (_filterMode) {
      case _FilterMode.byPersonnel:
        if (_selectedPersonnel == null) return sampleTasks;
        return sampleTasks.where((t) => t.personnel == _selectedPersonnel).toList();
      case _FilterMode.byTask:
        if (_selectedTask == null) return sampleTasks;
        return sampleTasks.where((t) => t.task == _selectedTask).toList();
      case _FilterMode.all:
        return sampleTasks;
    }
  }

  int get _pendingCount =>
      _filteredTasks.where((t) => t.status == TaskStatus.pending).length;
  int get _evaluatedCount =>
      _filteredTasks.where((t) => t.status == TaskStatus.evaluated).length;
  int get _flaggedCount =>
      _filteredTasks.where((t) => t.status == TaskStatus.flagged).length;

  String get _avgScore {
    final scores = _filteredTasks
        .where((t) => t.score != null)
        .map((t) => t.score!);
    if (scores.isEmpty) return '—';
    return '${(scores.reduce((a, b) => a + b) / scores.length).round()}/100';
  }

  String get _filterModeLabel {
    switch (_filterMode) {
      case _FilterMode.all:        return 'Show All';
      case _FilterMode.byPersonnel: return 'By Personnel';
      case _FilterMode.byTask:      return 'By Task';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stat cards ────────────────────────────────────────────────────
          Row(
            children: [
              Expanded(child: _StatCard(
                label: 'Pending',
                value: '$_pendingCount',
                valueColor: AppColors.warning,
                icon: Icons.schedule_outlined,
                iconColor: AppColors.warning,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Evaluated',
                value: '$_evaluatedCount',
                valueColor: AppColors.success,
                icon: Icons.check_circle_outline,
                iconColor: AppColors.success,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Flagged',
                value: '$_flaggedCount',
                valueColor: AppColors.danger,
                icon: Icons.flag_outlined,
                iconColor: AppColors.danger,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Avg Score',
                value: _avgScore,
                valueColor: AppColors.textPrimary,
                icon: Icons.bar_chart_outlined,
                iconColor: AppColors.textSecondary,
              )),
            ],
          ),

          const SizedBox(height: 18),

          // ── Weighted scoring breakdown ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weighted Scoring Breakdown (Total: 100 pts)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 16),
                Row(
                  children: const [
                    Expanded(child: _WeightItem(emoji: '✅', label: 'Task Completion', pct: '35%')),
                    Expanded(child: _WeightItem(emoji: '🏆', label: 'Quality of Output', pct: '30%')),
                    Expanded(child: _WeightItem(emoji: '⏰', label: 'Timeliness', pct: '20%')),
                    Expanded(child: _WeightItem(emoji: '💬', label: 'Coordination & Communication', pct: '15%')),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFFECACA), width: 0.8),
                  ),
                  child: Row(children: const [
                    Icon(Icons.flag, color: AppColors.danger, size: 14),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Scores below 60/100 are automatically flagged and supervisor is alerted.',
                        style: TextStyle(color: AppColors.danger, fontSize: 12.5),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Table card ────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  child: Row(
                    children: [
                      const Text('Special Task Evaluations', style: AppTextStyles.sectionTitle),
                      const Spacer(),
                      // Filter mode selector (compact)
                      SizedBox(
                        width: 140,
                        child: DropdownButtonFormField<String>(
                          value: _filterMode.toString().split('.').last == 'all' ? 'all' 
                               : _filterMode.toString().split('.').last == 'byPersonnel' ? 'personnel' 
                               : 'task',
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('Show All', style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 'personnel', child: Text('By Personnel', style: TextStyle(fontSize: 12))),
                            DropdownMenuItem(value: 'task', child: Text('By Task', style: TextStyle(fontSize: 12))),
                          ],
                          onChanged: (v) {
                            if (v == 'personnel') {
                              setState(() => _filterMode = _FilterMode.byPersonnel);
                            } else if (v == 'task') {
                              setState(() => _filterMode = _FilterMode.byTask);
                            } else {
                              setState(() => _filterMode = _FilterMode.all);
                            }
                            setState(() {
                              _selectedPersonnel = null;
                              _selectedTask = null;
                            });
                          },
                        ),
                      ),
                      // Secondary selection dropdown
                      if (_filterMode == _FilterMode.byPersonnel) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            value: _selectedPersonnel,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              isDense: true,
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Personnel', style: TextStyle(fontSize: 12))),
                              ..._personnelList.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)))),
                            ],
                            onChanged: (v) => setState(() => _selectedPersonnel = v),
                          ),
                        ),
                      ],
                      if (_filterMode == _FilterMode.byTask) ...[
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 160,
                          child: DropdownButtonFormField<String>(
                            value: _selectedTask,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              isDense: true,
                            ),
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Tasks', style: TextStyle(fontSize: 12))),
                              ..._taskList.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))),
                            ],
                            onChanged: (v) => setState(() => _selectedTask = v),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 14),
                _SpecialTaskTable(tasks: _filteredTasks),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final IconData icon;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.statLabel),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: valueColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: iconColor, size: 26),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Weight item
// ─────────────────────────────────────────────────────────────────────────────

class _WeightItem extends StatelessWidget {
  final String emoji;
  final String label;
  final String pct;

  const _WeightItem({required this.emoji, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 7),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Text(pct,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full-width flexible table  (no horizontal scroll — matches reference)
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialTaskTable extends StatelessWidget {
  final List<SpecialTask> tasks;
  const _SpecialTaskTable({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('No tasks match the selected filter.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
      );
    }

    return Column(
      children: [
        // Header
        _TableHeader(),
        const Divider(height: 0, thickness: 0.8, color: AppColors.divider),
        // Rows
        ...tasks.asMap().entries.map((e) => _TaskRow(task: e.value, index: e.key)),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.tableHeaderBg,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: const [
          SizedBox(width: 55,  child: _Th('ID')),
          SizedBox(width: 145, child: _Th('PERSONNEL')),
          SizedBox(width: 105, child: _Th('DEPARTMENT')),
          Expanded(            child: _Th('TASK')),
          SizedBox(width: 100, child: _Th('ASSIGNED BY')),
          SizedBox(width: 90,  child: _Th('DUE DATE')),
          SizedBox(width: 105, child: _Th('SUBMITTED')),
          SizedBox(width: 95,  child: _Th('SCORE')),
          SizedBox(width: 125, child: _Th('STATUS')),
          SizedBox(width: 90,  child: _Th('ACTION')),
        ],
      ),
    );
  }
}

class _Th extends StatelessWidget {
  final String text;
  const _Th(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.tableHeader);
  }
}

class _TaskRow extends StatelessWidget {
  final SpecialTask task;
  final int index;
  const _TaskRow({required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: index.isOdd ? const Color(0xFFFAFAFB) : Colors.white,
        border: const Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ID
          SizedBox(
            width: 55,
            child: Text(task.id,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          // Personnel
          SizedBox(
            width: 145,
            child: Row(
              children: [
                PersonAvatar(name: task.personnel),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(task.personnel,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                ),
              ],
            ),
          ),
          // Department
          SizedBox(
            width: 105,
            child: Text(task.department,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          // Task — flex, wraps naturally
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(task.task,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4)),
            ),
          ),
          // Assigned By
          SizedBox(
            width: 100,
            child: Text(task.assignedBy,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          // Due Date
          SizedBox(
            width: 90,
            child: Text(task.dueDate,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          // Submitted
          SizedBox(width: 105, child: _submittedCell()),
          // Score
          SizedBox(width: 95, child: _scoreCell()),
          // Status
          SizedBox(width: 125, child: _statusCell()),
          // Action
          SizedBox(width: 90, child: _actionButton()),
        ],
      ),
    );
  }

  Widget _submittedCell() {
    if (task.status == TaskStatus.notSubmitted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text('Not\nSubmitted',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.danger, fontWeight: FontWeight.w500, height: 1.3)),
      );
    }
    if (task.submittedDate != null) {
      return Text(task.submittedDate!,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.success));
    }
    return const Text('—', style: TextStyle(fontSize: 14, color: AppColors.textHint));
  }

  Widget _scoreCell() {
    if (task.score == null) {
      return const Text('—', style: TextStyle(fontSize: 14, color: AppColors.textHint));
    }
    final Color bg = task.score! >= 80
        ? const Color(0xFFDCFCE7)
        : task.score! >= 60
            ? const Color(0xFFFEF3C7)
            : const Color(0xFFFECACA);
    final Color fg = task.score! >= 80
        ? const Color(0xFF15803D)
        : task.score! >= 60
            ? const Color(0xFF92400E)
            : const Color(0xFFDC2626);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text('${task.score}/100',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: fg)),
    );
  }

  Widget _statusCell() {
    switch (task.status) {
      case TaskStatus.pending:
        return const Text('Pending',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning));
      case TaskStatus.evaluated:
        return Row(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.check_circle_outline, color: AppColors.success, size: 14),
          SizedBox(width: 4),
          Text('Evaluated',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.success)),
        ]);
      case TaskStatus.flagged:
        return Row(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.flag, color: AppColors.danger, size: 14),
          SizedBox(width: 4),
          Text('Flagged',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger)),
        ]);
      case TaskStatus.notSubmitted:
        return const Text('Not Submitted',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.danger));
    }
  }

  Widget _actionButton() {
    final String label = task.status == TaskStatus.pending ? 'Evaluate' : 'View';
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.tabActive,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}