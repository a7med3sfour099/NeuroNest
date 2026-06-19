import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/assessmentResult/widgets/custom_card_widg.dart';
import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VideoResultView extends StatefulWidget {
  const VideoResultView({
    super.key,
    this.onBackPressed,
    this.videoPath,
    this.analysisResult,
    this.durationSeconds = 0,
  });

  final VoidCallback? onBackPressed;
  final String? videoPath;
  final Map<String, dynamic>? analysisResult;
  final int durationSeconds;

  @override
  State<VideoResultView> createState() => _VideoResultViewState();
}

class _VideoResultViewState extends State<VideoResultView> {
  double _riskScore = 0.0;
  String _riskLevel = 'Low';
  Color _riskColor = Colors.green;
  Color _riskBgColor = Colors.green.withOpacity(0.2);

  // Video analysis metrics
  late Map<String, dynamic> _metrics;

  @override
  void initState() {
    super.initState();
    _metrics = widget.analysisResult ?? _getDefaultMetrics();
    _calculateResults();
  }

  void _calculateResults() {
    // Calculate overall risk score from video analysis
    _riskScore = _metrics['overallScore'] ?? _calculateOverallScore();
    _setRiskLevel();
  }

  void _setRiskLevel() {
    if (_riskScore >= 70) {
      _riskLevel = 'High';
      _riskColor = Colors.red.shade700;
      _riskBgColor = Colors.red.withOpacity(0.2);
    } else if (_riskScore >= 40) {
      _riskLevel = 'Moderate';
      _riskColor = Colors.orange.shade700;
      _riskBgColor = Colors.orange.withOpacity(0.2);
    } else {
      _riskLevel = 'Low';
      _riskColor = Colors.green.shade700;
      _riskBgColor = Colors.green.withOpacity(0.2);
    }
  }

  double _calculateOverallScore() {
    // Combine different metrics for overall score
    double socialScore = _metrics['socialInteraction'] ?? 0;
    double communicationScore = _metrics['communication'] ?? 0;
    double behaviorScore = _metrics['repetitiveBehaviors'] ?? 0;

    return (socialScore + communicationScore + behaviorScore) / 3;
  }

  Map<String, dynamic> _getDefaultMetrics() {
    return {
      'socialInteraction': 45.0,
      'communication': 50.0,
      'repetitiveBehaviors': 30.0,
      'eyeContact': 60.0,
      'facialExpressions': 55.0,
      'gestures': 40.0,
      'vocalizations': 65.0,
      'overallScore': 48.0,
      'analysisStatus': 'completed',
    };
  }

  String _getRiskDescription() {
    if (_riskScore >= 70) {
      return 'High likelihood: Video analysis shows significant behaviors associated with autism spectrum traits. Consultation recommended.';
    } else if (_riskScore >= 40) {
      return 'Moderate likelihood: Some behavioral patterns observed. Further assessment may be beneficial.';
    } else {
      return 'Low likelihood: Few behavioral indicators observed. Continue monitoring developmental milestones.';
    }
  }

  String _getMetricRating(double value) {
    if (value <= 33) return 'Low';
    if (value <= 66) return 'Moderate';
    return 'High';
  }

  Color _getMetricRatingColor(double value) {
    if (value <= 33) return Colors.green.shade700;
    if (value <= 66) return Colors.orange.shade700;
    return Colors.red.shade700;
  }

  Color _getMetricBgColor(double value) {
    if (value <= 33) return Colors.green.withOpacity(0.2);
    if (value <= 66) return Colors.orange.withOpacity(0.2);
    return Colors.red.withOpacity(0.2);
  }

  String _formatDuration() {
    final minutes = widget.durationSeconds ~/ 60;
    final seconds = widget.durationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          iconSize: 33,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Video Analysis Result',
          size: 21,
          color: Color(0xff000000),
          weight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              _buildVideoInfoCard(),
              const Gap(13),
              _buildRiskGaugeCard(),
              const Gap(13),
              _buildMetricsCards(),
              const Gap(13),
              _buildRecommendationsCard(),
              const Gap(13),
              CustomElevatedbutton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/root',
                    (route) => false,
                  );
                },
                text: 'Back to Home',
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoInfoCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.video_library,
              size: 32,
              color: Colors.blue,
            ),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: 'Video Analysis',
                  size: 16,
                  weight: FontWeight.w600,
                  color: Colors.black87,
                ),
                const Gap(4),
                CustomText(
                  text: 'Duration: ${_formatDuration()}',
                  size: 13,
                  color: Colors.grey.shade600,
                  weight: FontWeight.w400,
                ),
                CustomText(
                  text: 'Status: ${_metrics['analysisStatus'] ?? 'completed'}',
                  size: 13,
                  color: Colors.green.shade700,
                  weight: FontWeight.w400,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _riskBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _riskLevel,
              style: TextStyle(
                color: _riskColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskGaugeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffDBEFF8),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
              child: CustomText(
                text: 'Overall Video Assessment',
                size: 21,
                color: Color(0xff6C6969),
                weight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
            ),
            const Gap(5),
            RiskGauge(value: _riskScore),
            const Gap(17),
            CustomText(
              text: _getRiskDescription(),
              size: 16,
              color: const Color(0xff6C6969),
              weight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards() {
    final metrics = [
      {
        'title': 'Social Interaction',
        'value': _metrics['socialInteraction'] ?? 45.0,
        'icon': Icons.people,
        'description': 'Looking at faces, responding to name',
      },
      {
        'title': 'Communication',
        'value': _metrics['communication'] ?? 50.0,
        'icon': Icons.chat,
        'description': 'Gestures, vocalizations, responses',
      },
      {
        'title': 'Repetitive Behaviors',
        'value': _metrics['repetitiveBehaviors'] ?? 30.0,
        'icon': Icons.autorenew,
        'description': 'Hand flapping, rocking, repetitive actions',
      },
      {
        'title': 'Eye Contact',
        'value': _metrics['eyeContact'] ?? 60.0,
        'icon': Icons.remove_red_eye,
        'description': 'Looking at faces and maintaining gaze',
      },
      {
        'title': 'Facial Expressions',
        'value': _metrics['facialExpressions'] ?? 55.0,
        'icon': Icons.face,
        'description': 'Smiling, emotional responses',
      },
      {
        'title': 'Motor Gestures',
        'value': _metrics['gestures'] ?? 40.0,
        'icon': Icons.gesture,
        'description': 'Pointing, waving, showing',
      },
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CustomText(
            text: 'Detailed Analysis',
            size: 18,
            weight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Gap(8),
        ...metrics.map((metric) {
          final value = metric['value'] as double;
          final rating = _getMetricRating(value);
          final ratingColor = _getMetricRatingColor(value);
          final ratingBgColor = _getMetricBgColor(value);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CustomCard(
              backgroundImage: 'assets/ques/ques_image.png', // صورة افتراضية
              text: metric['title'] as String,
              textCont: rating,
              color: ratingBgColor,
              colorTextCont: ratingColor,
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildRecommendationsCard() {
    List<String> recommendations = [
      '✓ Continue monitoring developmental milestones',
      '✓ Encourage social interaction and play',
      '✓ Maintain consistent routines',
      '✓ Consult with pediatrician for concerns',
    ];

    if (_riskScore >= 70) {
      recommendations = [
        '⚠️ Schedule a consultation with a developmental specialist',
        '📝 Document specific behaviors for healthcare provider',
        '🧩 Explore early intervention programs',
        '👨‍👩‍👧 Join support groups for families',
        '📚 Research evidence-based therapies',
      ];
    } else if (_riskScore >= 40) {
      recommendations = [
        '📊 Monitor progress and track behaviors',
        '🗣️ Discuss observations with pediatrician',
        '🎯 Focus on specific areas of concern',
        '📱 Use developmental tracking apps',
      ];
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
              Gap(8),
              CustomText(
                text: 'Recommendations',
                size: 18,
                weight: FontWeight.w600,
                color: Colors.black87,
              ),
            ],
          ),
          const Gap(16),
          ...recommendations.map(
            (rec) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomText(
                text: rec,
                size: 14,
                color: Colors.grey.shade700,
                weight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
