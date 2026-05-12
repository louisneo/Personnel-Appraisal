import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'models/appraisal_models.dart';

class EventsTab extends StatefulWidget {
  const EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab> {
  String _filterMode = 'all'; // 'all' | 'event'
  String? _selectedEvent;

  List<SchoolEvent> get _filteredEvents {
    if (_filterMode == 'event' && _selectedEvent != null) {
      return sampleEvents.where((e) => e.name == _selectedEvent).toList();
    }
    return sampleEvents;
  }

  // ── Stats ─────────────────────────────────────────────────────────────────
  int get _pendingCount =>
      _filteredEvents.where((e) => e.status == EventStatus.awaitingRatings).length;
  int get _evaluatedCount =>
      _filteredEvents.where((e) => e.status == EventStatus.rated).length;
  int get _lowRatingCount =>
      _filteredEvents.where((e) => e.avgRating != null && e.avgRating! < 3.0).length;
  String get _avgRating {
    final scores = _filteredEvents
        .where((e) => e.avgRating != null)
        .map((e) => e.avgRating!);
    if (scores.isEmpty) return '—';
    return '${(scores.reduce((a, b) => a + b) / scores.length).toStringAsFixed(1)}/5';
  }

  List<String> get _eventNames =>
      sampleEvents.map((e) => e.name).toSet().toList()..sort();

  String get _filterLabel => _filterMode == 'event' ? 'By Event' : 'Show All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stat cards (NO filter here) ───────────────────────────────────
          Row(
            children: [
              Expanded(child: _StatCard(
                label: 'Pending Review', value: '$_pendingCount',
                valueColor: AppColors.warning, icon: Icons.assignment_outlined, iconColor: AppColors.warning,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Evaluated', value: '$_evaluatedCount',
                valueColor: AppColors.success, icon: Icons.star_border_outlined, iconColor: AppColors.success,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Low Rating', value: '$_lowRatingCount',
                valueColor: AppColors.danger, icon: Icons.warning_amber_outlined, iconColor: AppColors.danger,
              )),
              const SizedBox(width: 14),
              Expanded(child: _StatCard(
                label: 'Avg Rating', value: _avgRating,
                valueColor: AppColors.amber, icon: Icons.star_border_outlined, iconColor: AppColors.amber,
              )),
            ],
          ),

          const SizedBox(height: 18),

          // ── Event Evaluation Rubric card ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Event Evaluation Rubric (5-Point Scale)',
                    style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  children: const [
                    _RubricItem(icon: Icons.calendar_view_month_outlined, label: 'Organization', pct: '20%', color: Color(0xFF10B981)),
                    _RubricItem(icon: Icons.people_outline, label: 'Engagement', pct: '25%', color: Color(0xFFF59E0B)),
                    _RubricItem(icon: Icons.notes_outlined, label: 'Content Quality', pct: '30%', color: Color(0xFF8B5CF6)),
                    _RubricItem(icon: Icons.schedule_outlined, label: 'Time Management', pct: '15%', color: Color(0xFFEC4899)),
                    _RubricItem(icon: Icons.sentiment_satisfied_outlined, label: 'Overall Experience', pct: '10%', color: Color(0xFF3B82F6)),
                  ],
                ),
                const SizedBox(height: 14),
                // Info banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: AppColors.infoBannerBg,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.infoBannerBdr, width: 0.8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, color: AppColors.infoBannerIcon, size: 15),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Events are rated by attendees (faculty and students) through a standardized rubric form. '
                          'Ratings below 3.0/5 are automatically flagged for review.',
                          style: TextStyle(color: AppColors.infoBannerFg, fontSize: 12, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ── Table card — dropdown lives HERE in the card header ───────────
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder, width: 0.8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card header: title + dropdowns on the right
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
                  child: Row(
                    children: [
                      const Text('Event Evaluations', style: AppTextStyles.sectionTitle),
                      const Spacer(),

                      // ── First dropdown: filter mode ─────────────────────
                      _AppDropdown(
                        label: _filterLabel,
                        showFilterIcon: true,
                        items: const [
                          _MenuItem(value: 'all', label: 'Show All'),
                          _MenuItem(value: 'event', label: 'By Event'),
                        ],
                        onSelected: (v) => setState(() {
                          _filterMode = v;
                          _selectedEvent = null;
                        }),
                      ),

                      // ── Second dropdown: specific event ─────────────────
                      if (_filterMode == 'event') ...[
                        const SizedBox(width: 8),
                        _AppDropdown(
                          label: _selectedEvent ?? 'Select event...',
                          isPlaceholder: _selectedEvent == null,
                          isDark: true,
                          items: [
                            const _MenuItem(value: '__clear__', label: '— Clear filter', isMuted: true),
                            ..._eventNames.map((n) => _MenuItem(value: n, label: n)),
                          ],
                          onSelected: (v) => setState(
                              () => _selectedEvent = v == '__clear__' ? null : v),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _EventsTable(events: _filteredEvents),

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
// Shared dropdown (same pattern as special_tasks_tab)
// ─────────────────────────────────────────────────────────────────────────────

class _MenuItem {
  final String value;
  final String label;
  final bool isMuted;
  const _MenuItem({required this.value, required this.label, this.isMuted = false});
}

class _AppDropdown extends StatelessWidget {
  final String label;
  final List<_MenuItem> items;
  final ValueChanged<String> onSelected;
  final bool showFilterIcon;
  final bool isDark;
  final bool isPlaceholder;

  const _AppDropdown({
    required this.label,
    required this.items,
    required this.onSelected,
    this.showFilterIcon = false,
    this.isDark = false,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark ? AppColors.tabActive : Colors.white;
    final Color fgColor = isDark ? Colors.white : AppColors.textPrimary;
    final Color borderColor = isDark ? AppColors.tabActive : AppColors.cardBorder;
    final Color chevronColor = isDark ? Colors.white : AppColors.textSecondary;

    return PopupMenuButton<String>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.cardBorder, width: 0.8),
      ),
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black12,
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
      itemBuilder: (_) => items.map((item) => PopupMenuItem<String>(
        value: item.value,
        height: 40,
        child: Text(item.label,
          style: TextStyle(
            fontSize: 13,
            color: item.isMuted ? AppColors.textSecondary : AppColors.textPrimary,
            fontStyle: item.isMuted ? FontStyle.italic : FontStyle.normal,
            fontWeight: FontWeight.w400,
          )),
      )).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showFilterIcon) ...[
              Icon(Icons.tune_rounded, size: 14, color: chevronColor),
              const SizedBox(width: 6),
            ],
            Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isPlaceholder ? FontWeight.w400 : FontWeight.w500,
                color: isPlaceholder ? AppColors.textHint : fgColor,
              )),
            const SizedBox(width: 5),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: chevronColor),
          ],
        ),
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
    required this.label, required this.value,
    required this.valueColor, required this.icon, required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder, width: 0.8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.statLabel),
                const SizedBox(height: 10),
                Text(value, style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w600,
                  color: valueColor, letterSpacing: -0.3,
                )),
              ],
            ),
          ),
          Icon(icon, color: iconColor, size: 22),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Rubric item
// ─────────────────────────────────────────────────────────────────────────────

class _RubricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String pct;
  final Color color;

  const _RubricItem({required this.icon, required this.label, required this.pct, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Text(pct, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Events table
// ─────────────────────────────────────────────────────────────────────────────

class _EventsTable extends StatelessWidget {
  final List<SchoolEvent> events;

  const _EventsTable({required this.events});

  static const _headers = [
    'EVENT ID', 'EVENT NAME', 'DATE', 'ORGANIZER',
    'ATTENDEES', 'RESPONSES', 'AVG RATING', 'STATUS', 'ACTION',
  ];

  static const _colWidths = <int, TableColumnWidth>{
    0: FixedColumnWidth(80),
    1: FixedColumnWidth(220),
    2: FixedColumnWidth(90),
    3: FixedColumnWidth(110),
    4: FixedColumnWidth(90),
    5: FixedColumnWidth(110),
    6: FixedColumnWidth(110),
    7: FixedColumnWidth(110),
    8: FixedColumnWidth(120),
  };

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text('No events match the selected filter.',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Table(
        columnWidths: _colWidths,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.tableHeaderBg,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.8),
                bottom: BorderSide(color: AppColors.divider, width: 0.8),
              ),
            ),
            children: _headers.map((h) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(h, style: AppTextStyles.tableHeader),
            )).toList(),
          ),
          ...events.asMap().entries.map((e) => _row(e.value, e.key)),
        ],
      ),
    );
  }

  Widget _c(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    child: child,
  );

  TableRow _row(SchoolEvent ev, int i) {
    // Avg rating
    Widget rating;
    if (ev.avgRating != null) {
      final bool low = ev.avgRating! < 3.0;
      rating = Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.star_rounded, color: AppColors.amber, size: 14),
        const SizedBox(width: 4),
        Text('${ev.avgRating!.toStringAsFixed(1)}/5',
            style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600,
              color: low ? AppColors.danger : AppColors.textPrimary,
            )),
      ]);
    } else {
      rating = const Text('—', style: TextStyle(color: AppColors.textHint, fontSize: 13));
    }

    // Status badge + action
    Widget statusBadge;
    String actionLabel;
    bool canAct;
    switch (ev.status) {
      case EventStatus.awaitingRatings:
        statusBadge = _pill('Pending', AppColors.statusAmberBg, AppColors.statusAmberFg);
        actionLabel = 'No Data';
        canAct = false;
      case EventStatus.rated:
        statusBadge = _pill('Completed', AppColors.statusGreenBg, AppColors.statusGreenFg);
        actionLabel = 'View Results';
        canAct = true;
      case EventStatus.flagged:
        statusBadge = _pill('Flagged', AppColors.statusRedBg, AppColors.statusRedFg);
        actionLabel = 'View Results';
        canAct = true;
    }

    final int pct = ev.attendees > 0 ? ((ev.responses / ev.attendees) * 100).round() : 0;

    return TableRow(
      decoration: BoxDecoration(
        color: i.isOdd ? const Color(0xFFFAFAFB) : Colors.white,
        border: const Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      children: [
        _c(Text(ev.id, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary))),
        _c(Text(ev.name,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
            overflow: TextOverflow.ellipsis)),
        _c(Text(ev.date, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _c(Text(ev.organizer, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _c(Text('${ev.attendees}', style: const TextStyle(fontSize: 13, color: AppColors.textPrimary))),
        _c(Text('${ev.responses} ($pct%)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _c(rating),
        _c(statusBadge),
        _c(GestureDetector(
          onTap: canAct ? () {} : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: canAct ? AppColors.tabActive : AppColors.notSubmittedBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(actionLabel,
                style: TextStyle(
                  color: canAct ? Colors.white : AppColors.notSubmittedFg,
                  fontSize: 12, fontWeight: FontWeight.w500,
                )),
          ),
        )),
      ],
    );
  }

  Widget _pill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}