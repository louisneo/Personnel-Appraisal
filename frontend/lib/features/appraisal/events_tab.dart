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
  String _filterType = 'all';
  String? _selectedEvent;

  List<SchoolEvent> get _filteredEvents {
    if (_filterType == 'event' && _selectedEvent != null) {
      return sampleEvents.where((e) => e.event == _selectedEvent).toList();
    }
    return sampleEvents;
  }

  @override
  Widget build(BuildContext context) {
    final pendingReview = _filteredEvents.where((e) => e.status == EventStatus.awaitingRatings).length;
    final evaluated = _filteredEvents.where((e) => e.status == EventStatus.rated).length;
    final lowRating = _filteredEvents.where((e) => e.avgScore != null && e.avgScore! < 3.0).length;
    final avgRating = _filteredEvents.isEmpty 
      ? 0.0 
      : _filteredEvents.where((e) => e.avgScore != null).map((e) => e.avgScore!).reduce((a, b) => a + b) / _filteredEvents.where((e) => e.avgScore != null).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter controls
          Row(
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
                    DropdownMenuItem(value: 'all', child: Text('All Events')),
                    DropdownMenuItem(value: 'event', child: Text('By Event')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _filterType = v;
                        _selectedEvent = null;
                      });
                    }
                  },
                ),
              ),
              if (_filterType == 'event') ...[
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedEvent,
                    decoration: InputDecoration(
                      labelText: 'Select Event',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: sampleEvents
                        .map((e) => e.event)
                        .toSet()
                        .map((ev) => DropdownMenuItem(value: ev, child: Text(ev)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedEvent = v),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Stat cards
          Row(children: [
            Expanded(child: StatCard(label: 'Pending Review', value: '$pendingReview', valueColor: AppColors.warning, icon: const Icon(Icons.assignment, color: AppColors.warning, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Evaluated', value: '$evaluated', valueColor: AppColors.success, icon: const Icon(Icons.star, color: AppColors.success, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Low Rating', value: '$lowRating', valueColor: AppColors.danger, icon: const Icon(Icons.trending_down, color: AppColors.danger, size: 20))),
            const SizedBox(width: 12),
            Expanded(child: StatCard(label: 'Avg Rating', value: avgRating.toStringAsFixed(1), valueColor: AppColors.amber, icon: const Icon(Icons.star, color: AppColors.amber, size: 20))),
          ]),
          const SizedBox(height: 20),

          // Event Evaluation Rubric info
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Event Evaluation Rubric (5-Point Scale)', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 14),
                Row(children: [
                  _RubricItem(icon: Icons.business, label: 'Organization', pct: '20%'),
                  const SizedBox(width: 24),
                  _RubricItem(icon: Icons.people, label: 'Engagement', pct: '25%'),
                  const SizedBox(width: 24),
                  _RubricItem(icon: Icons.notes, label: 'Content Quality', pct: '30%'),
                  const SizedBox(width: 24),
                  _RubricItem(icon: Icons.schedule, label: 'Time Management', pct: '15%'),
                  const SizedBox(width: 24),
                  _RubricItem(icon: Icons.sentiment_satisfied, label: 'Overall Experience', pct: '10%'),
                ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.infoBannerBg,
                    border: Border.all(color: AppColors.infoBannerBdr, width: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.infoBannerIcon, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Events are rated by attendees (faculty and students) through a standardized rubric form. Ratings below 3.0/5 are automatically flagged for review.',
                          style: TextStyle(color: AppColors.infoBannerFg, fontSize: 12),
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
                const Text('Event Evaluations', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                _EventsTable(events: _filteredEvents),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RubricItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String pct;

  const _RubricItem({required this.icon, required this.label, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: AppColors.info, size: 20),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
        Text(pct, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _EventsTable extends StatelessWidget {
  final List<SchoolEvent> events;

  const _EventsTable({required this.events});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(70),
          1: FixedColumnWidth(180),
          2: FixedColumnWidth(110),
          3: FixedColumnWidth(110),
          4: FixedColumnWidth(90),
          5: FixedColumnWidth(90),
          6: FixedColumnWidth(90),
          7: FixedColumnWidth(80),
          8: FixedColumnWidth(80),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.tableHeaderBg,
              border: Border(bottom: BorderSide(color: AppColors.divider, width: 1)),
            ),
            children: ['EVENT ID', 'EVENT NAME', 'DATE', 'ORGANIZER', 'ATTENDEES', 'RESPONSES', 'AVG RATING', 'STATUS', 'ACTION']
                .map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(h, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
                )).toList(),
          ),
          ...events.map((ev) => _buildRow(ev)),
        ],
      ),
    );
  }

  TableRow _buildRow(SchoolEvent ev) {
    Widget ratingWidget;
    if (ev.avgScore != null) {
      final color = ev.avgScore! < 3.0 ? AppColors.danger : AppColors.success;
      ratingWidget = Row(
        children: [
          const Icon(Icons.star, color: AppColors.amber, size: 14),
          const SizedBox(width: 3),
          Text('${ev.avgScore!.toStringAsFixed(1)}/5', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600)),
        ],
      );
    } else {
      ratingWidget = const Text('—', style: TextStyle(color: AppColors.textHint, fontSize: 12));
    }

    Widget statusWidget;
    String actionLabel;
    switch (ev.status) {
      case EventStatus.awaitingRatings:
        statusWidget = const Text('Pending', style: TextStyle(color: AppColors.warning, fontSize: 11, fontWeight: FontWeight.w500));
        actionLabel = 'Rate Event';
      case EventStatus.rated:
        statusWidget = const Text('Completed', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w500));
        actionLabel = 'View Results';
      case EventStatus.flagged:
        statusWidget = const Text('Flagged', style: TextStyle(color: AppColors.danger, fontSize: 11, fontWeight: FontWeight.w500));
        actionLabel = 'View Results';
    }

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider, width: 0.5)),
      ),
      children: [
        _cell(Text(ev.id, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500))),
        _cell(Text(ev.event, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
        _cell(Text(ev.eventDate, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(Text(ev.personnel, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(Text('${ev.raters}', style: const TextStyle(fontSize: 12, color: AppColors.textPrimary))),
        _cell(Text('${ev.raters > 0 ? ((ev.raters / 100) * 100).toStringAsFixed(0) : '0'}%', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        _cell(ratingWidget),
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
            child: Text(actionLabel, style: const TextStyle(fontSize: 10, color: Colors.white)),
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
