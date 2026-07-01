import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuronest/features/home/providers/history_provider.dart';
import 'package:provider/provider.dart';

class LatestAssessmentCard extends StatelessWidget {
  const LatestAssessmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;

    final assessment = history?.history.isNotEmpty == true
        ? history!.history.first
        : null;

    final cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );

    if (assessment == null) {
      return Container(
        padding: const EdgeInsets.all(22),
        decoration: cardDecoration,
        child: const Center(
          child: Text(
            "No assessments yet",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    Color riskColor;
    IconData riskIcon;

    switch (assessment.riskLevel.toLowerCase()) {
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

    final parsedDate =
        DateTime.tryParse(assessment.screeningDate) ?? DateTime.now();
    final bool isVideo = (assessment.screeningType).toLowerCase().contains(
      "video",
    );
    final Color itemColor = isVideo ? Colors.blue : Color(0xFFFF9800);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: cardDecoration, // واستخدمناه هنا كمان
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isVideo
                    ? Colors.blue.withOpacity(.12)
                    : Colors.orange.withOpacity(.12),
                child: Icon(
                  isVideo ? Icons.videocam_outlined : Icons.assignment_outlined,
                  color: itemColor,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Latest Assessment",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            assessment.screeningType,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: riskColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(riskIcon, size: 18, color: riskColor),
                const SizedBox(width: 8),
                Text(
                  assessment.riskLevel,
                  style: TextStyle(
                    color: riskColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                DateFormat("dd MMM yyyy").format(parsedDate),
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(Icons.score, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                "Score : ${assessment.totalScore}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
