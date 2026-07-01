import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/home/providers/history_provider.dart';
import 'package:provider/provider.dart';

class StatsCards extends StatelessWidget {
  const StatsCards({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;
    final total = history?.stats.total ?? 0;
    final riskLevel = history?.stats.currentRiskLevel ?? "--";
    final lastDateString = history?.stats.lastAssessmentDate;

    final String lastDateFormatted = lastDateString == null
        ? "N/A"
        : DateFormat("dd MMM").format(DateTime.parse(lastDateString));

    Color riskColor;
    IconData riskIcon;

    switch (riskLevel.toLowerCase()) {
      case "low":
        riskColor = Colors.green;
        riskIcon = Icons.check_circle;
        break;
      case "medium":
        riskColor = Colors.orange;
        riskIcon = Icons.warning_amber;
        break;
      case "high":
        riskColor = Colors.red;
        riskIcon = Icons.error;
        break;
      default:
        riskColor = Colors.grey;
        riskIcon = Icons.remove_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border.withOpacity(0.85),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSummaryColumn('$total', 'Total'),

            VerticalDivider(color: AppColors.border, thickness: 1.2),

            _buildSummaryColumn(
              riskLevel,
              'Result',
              isResult: true,
              resultColor: riskColor,
              resultIcon: riskIcon,
            ),

            VerticalDivider(color: AppColors.border, thickness: 1.2),

            // VerticalDivider(
            //   color: const Color(0xFFBFC7D4).withOpacity(0.3),
            //   thickness: 1,
            // ),
            _buildSummaryColumn(lastDateFormatted, 'Last'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryColumn(
    String value,
    String label, {
    bool isResult = false,
    Color? resultColor,
    IconData? resultIcon,
  }) {
    final finalColor = isResult && resultColor != null
        ? resultColor
        : AppColors.secondary;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: finalColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isResult && resultIcon != null) ...[
                const SizedBox(width: 4),
                Icon(resultIcon, size: 18, color: finalColor),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textQuaternary,
            ),
          ),
        ],
      ),
    );
  }
}
