import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'special_tasks_tab.dart';
import 'events_tab.dart';
import 'analytics_tab.dart';

enum _AppraisalTab { specialTasks, events, analytics }

class AppraisalScreen extends StatefulWidget {
  const AppraisalScreen({super.key});

  @override
  State<AppraisalScreen> createState() => _AppraisalScreenState();
}

class _AppraisalScreenState extends State<AppraisalScreen> {
  _AppraisalTab _activeTab = _AppraisalTab.specialTasks;

  // Build the header once and pass it into the active tab so it scrolls
  // together with the tab content. Only the sidebar stays fixed.
  Widget _buildHeader() => _PageHeader(
        activeTab: _activeTab,
        onTabChanged: (t) => setState(() => _activeTab = t),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Row(
        children: [
          // ── Sidebar — never scrolls ──────────────────────────────────────
          AppSidebar(activeIndex: 2, onNavTap: (_) {}),

          // ── Content area — fully scrollable ─────────────────────────────
          Expanded(child: _tabBody()),
        ],
      ),
    );
  }

  Widget _tabBody() {
    // Pass the pre-built header widget into each tab.
    // The tab places it at the top of its SingleChildScrollView so the title,
    // subtitle, breadcrumb, and tab buttons all scroll with the content.
    final header = _buildHeader();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(
        key: ValueKey(_activeTab),
        child: switch (_activeTab) {
          _AppraisalTab.specialTasks => SpecialTasksTab(pageHeader: header),
          _AppraisalTab.events       => EventsTab(pageHeader: header),
          _AppraisalTab.analytics    => AnalyticsTab(pageHeader: header),
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Page header  (breadcrumb + title + subtitle + tab pills)
// Kept here so the tab-switching callbacks stay in one place.
// ─────────────────────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final _AppraisalTab activeTab;
  final ValueChanged<_AppraisalTab> onTabChanged;

  const _PageHeader({required this.activeTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      color: AppColors.pageBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Breadcrumb + action buttons ──────────────────────────────────
          Row(
            children: [
              const Text('Home',
                  style: TextStyle(fontSize: 12, color: AppColors.textHint)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right, size: 14, color: AppColors.textHint),
              ),
              const Text('Appraisal',
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500)),
              const Spacer(),
              TableActionButton(label: 'Export Report', outlined: true, onTap: () {}),
              const SizedBox(width: 8),
              TableActionButton(label: 'Lock Appraisal', onTap: () {}),
            ],
          ),

          const SizedBox(height: 14),

          // ── Title + subtitle ─────────────────────────────────────────────
          const Text('Performance Appraisal', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text(
            'Evaluate special tasks and events · Track faculty performance · View annual analytics',
            style: AppTextStyles.pageSub,
          ),

          const SizedBox(height: 16),

          // ── Pill-style tab bar ───────────────────────────────────────────
          Row(
            children: [
              _PillTab(
                icon: Icons.assignment_outlined,
                label: 'Special Tasks',
                badge: 1,
                active: activeTab == _AppraisalTab.specialTasks,
                onTap: () => onTabChanged(_AppraisalTab.specialTasks),
              ),
              const SizedBox(width: 10),
              _PillTab(
                icon: Icons.calendar_today_outlined,
                label: 'Events',
                badge: 1,
                active: activeTab == _AppraisalTab.events,
                onTap: () => onTabChanged(_AppraisalTab.events),
              ),
              const SizedBox(width: 10),
              _PillTab(
                icon: Icons.bar_chart_outlined,
                label: 'Analytics',
                badge: 0,
                active: activeTab == _AppraisalTab.analytics,
                onTap: () => onTabChanged(_AppraisalTab.analytics),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pill tab button
// ─────────────────────────────────────────────────────────────────────────────

class _PillTab extends StatefulWidget {
  final IconData icon;
  final String label;
  final int badge;
  final bool active;
  final VoidCallback onTap;

  const _PillTab({
    required this.icon,
    required this.label,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  @override
  State<_PillTab> createState() => _PillTabState();
}

class _PillTabState extends State<_PillTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active
                ? AppColors.tabActive
                : _hovered
                    ? AppColors.tableRowHover
                    : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.active ? AppColors.tabActive : AppColors.cardBorder,
              width: 1,
            ),
            boxShadow: widget.active
                ? [
                    BoxShadow(
                      color: AppColors.tabActive.withOpacity(0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon,
                  size: 15,
                  color: widget.active ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: widget.active ? Colors.white : AppColors.textSecondary,
                ),
              ),
              if (widget.badge > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: widget.active
                        ? const Color(0xFFEA580C)
                        : AppColors.danger,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${widget.badge}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}