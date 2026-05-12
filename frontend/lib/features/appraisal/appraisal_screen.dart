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
  _AppraisalTab _activeTab = _AppraisalTab.analytics;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: Row(
        children: [
          AppSidebar(activeIndex: 2, onNavTap: (_) {}),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _PageHeader(
                  activeTab: _activeTab,
                  onTabChanged: (t) => setState(() => _activeTab = t),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.pageBg,
                    child: _tabBody(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabBody() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: KeyedSubtree(
        key: ValueKey(_activeTab),
        child: switch (_activeTab) {
          _AppraisalTab.specialTasks => const SpecialTasksTab(),
          _AppraisalTab.events => const EventsTab(),
          _AppraisalTab.analytics => const AnalyticsTab(),
        },
      ),
    );
  }
}

// ── Page header ───────────────────────────────────────────────────────────────

class _PageHeader extends StatelessWidget {
  final _AppraisalTab activeTab;
  final ValueChanged<_AppraisalTab> onTabChanged;

  const _PageHeader({required this.activeTab, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 6),
                child: Icon(Icons.chevron_right,
                    size: 14, color: AppColors.textHint),
              ),
              const Text(
                'Appraisal',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              // Right-side actions
              TableActionButton(
                label: 'Export Report',
                outlined: true,
                onTap: () {},
              ),
              const SizedBox(width: 8),
              TableActionButton(
                label: 'Lock Appraisal',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Title + subtitle
          const Text('Performance Appraisal', style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          const Text(
            'Evaluate special tasks and events · Track faculty performance · View annual analytics',
            style: AppTextStyles.pageSub,
          ),

          const SizedBox(height: 16),

          // ── Underline-style tab bar ─────────────────────────────────────
          Row(
            children: [
              _UnderlineTab(
                icon: Icons.assignment_outlined,
                label: 'Special Tasks',
                badge: 1,
                active: activeTab == _AppraisalTab.specialTasks,
                onTap: () => onTabChanged(_AppraisalTab.specialTasks),
              ),
              _UnderlineTab(
                icon: Icons.calendar_today_outlined,
                label: 'Events',
                badge: 1,
                active: activeTab == _AppraisalTab.events,
                onTap: () => onTabChanged(_AppraisalTab.events),
              ),
              _UnderlineTab(
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

// ── Underline tab item ────────────────────────────────────────────────────────

class _UnderlineTab extends StatefulWidget {
  final IconData icon;
  final String label;
  final int badge;
  final bool active;
  final VoidCallback onTap;

  const _UnderlineTab({
    required this.icon,
    required this.label,
    required this.badge,
    required this.active,
    required this.onTap,
  });

  @override
  State<_UnderlineTab> createState() => _UnderlineTabState();
}

class _UnderlineTabState extends State<_UnderlineTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bool highlighted = widget.active || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            // Underline indicator at bottom
            border: Border(
              bottom: BorderSide(
                color: widget.active
                    ? AppColors.tabActive
                    : Colors.transparent,
                width: 2,
              ),
            ),
            // Subtle hover background
            color: _hovered && !widget.active
                ? AppColors.tableRowHover
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.active
                    ? AppColors.tabActive
                    : highlighted
                        ? AppColors.textSecondary
                        : AppColors.textHint,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: widget.active
                    ? AppTextStyles.tabLabelActive
                    : AppTextStyles.tabLabel,
              ),
              if (widget.badge > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
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