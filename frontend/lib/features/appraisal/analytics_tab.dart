import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme.dart';
import '../../shared/widgets/shared_widgets.dart';
import 'models/appraisal_models.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final avgPerformance = (sampleFaculty.map((f) => f.overallScore).reduce((a, b) => a + b) / sampleFaculty.length).toStringAsFixed(1);
    final tasksCompleted = sampleTasks.where((t) => t.status == TaskStatus.evaluated || t.status == TaskStatus.flagged).length;
    final eventsCompleted = sampleEvents.where((e) => e.status == EventStatus.rated).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary stat cards
          Row(children: [
            Expanded(child: StatCard(
              label: 'Overall Performance',
              value: '$avgPerformance%',
              valueColor: AppColors.success,
              icon: const Icon(Icons.trending_up, color: AppColors.success, size: 20),
            )),
            const SizedBox(width: 12),
            Expanded(child: StatCard(
              label: 'Total Personnel',
              value: '${sampleFaculty.length}',
              valueColor: AppColors.textPrimary,
              icon: const Icon(Icons.people, color: AppColors.info, size: 20),
            )),
            const SizedBox(width: 12),
            Expanded(child: StatCard(
              label: 'Special Tasks',
              value: '$tasksCompleted',
              valueColor: AppColors.amber,
              icon: const Icon(Icons.assignment, color: AppColors.amber, size: 20),
            )),
            const SizedBox(width: 12),
            Expanded(child: StatCard(
              label: 'Events Evaluated',
              value: '$eventsCompleted',
              valueColor: AppColors.info,
              icon: const Icon(Icons.calendar_today, color: AppColors.info, size: 20),
            )),
          ]),
          const SizedBox(height: 20),

          // Monthly trends chart
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Performance Trend', style: AppTextStyles.sectionTitle),
                const SizedBox(height: 16),
                SizedBox(height: 250, child: _MonthlyTrendChart()),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Department Performance & Top Performers side by side
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Department Performance', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 16),
                      _DepartmentPerformance(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Top Performers', style: AppTextStyles.sectionTitle),
                      const SizedBox(height: 16),
                      _TopPerformers(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthlyTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (v) => FlLine(
            color: const Color(0xFFEEEEEE),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) {
                const months = ['Sep', 'Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'];
                if (v.toInt() < months.length) {
                  return Text(months[v.toInt()], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary));
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, meta) => Text('${v.toInt()}%', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              reservedSize: 40,
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 72.3, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 75.1, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 76.8, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 77.5, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 79.2, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 80.4, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 81.6, color: const Color(0xFF7B95B8))]),
          BarChartGroupData(x: 7, barRods: [BarChartRodData(toY: 83.1, color: const Color(0xFF7B95B8))]),
        ],
      ),
    );
  }
}

class _DepartmentPerformance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final departments = [
      ('Engineering', 82.3, AppColors.success),
      ('Business', 76.8, AppColors.info),
      ('Sciences', 85.1, AppColors.success),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: departments.map((dept) {
        final (name, score, color) = dept;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                Text('$score%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: score / 100,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }
}

class _TopPerformers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final topPerformers = sampleFaculty
        .asMap()
        .entries
        .toList()
        .sublist(0, sampleFaculty.length.clamp(0, 5));

    return ListView.builder(
      shrinkWrap: true,
      itemCount: topPerformers.length,
      itemBuilder: (context, index) {
        final entry = topPerformers[index];
        final faculty = entry.value;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: [AppColors.amber, const Color(0xFF9CA3AF), const Color(0xFFCD7F32), AppColors.info, AppColors.success][index],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(faculty.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
                    Text(faculty.department, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Text('${faculty.overallScore}%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
            ],
          ),
        );
      },
    );
  }
}
