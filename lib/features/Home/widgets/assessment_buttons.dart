import 'package:flutter/material.dart';
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';
import 'package:provider/provider.dart';

class AssessmentButtons extends StatelessWidget {
  const AssessmentButtons({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<QuestionProvider>();
    final childProvider = context.watch<ChildProvider>();
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            title: "Questionnaire",
            subtitle: "Quick Test",
            icon: Icons.assignment_outlined,
            color: const Color(0xFFFF9800),
            onTap: () {
              final currentChildId = childProvider.currentChild?.childID;
              Navigator.pushReplacementNamed(
                context,
                '/startques',
                arguments: {'childId': currentChildId},
              );
            },
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _buildActionCard(
            context,
            title: "Video Analysis",
            subtitle: "AI Screening",
            icon: Icons.videocam_outlined,
            color: const Color(0xFF2196F3),
            onTap: () {
              Navigator.pushNamed(context, '/startvideo');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
