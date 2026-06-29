// import 'package:neuronest/core/constants/app_colors.dart';
// import 'package:neuronest/features/assessmentResult/widgets/custom_card_widg.dart';
// import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
// import 'package:neuronest/shared/custom_elevatedbutton.dart';
// import 'package:neuronest/shared/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';

// class VideoResultView extends StatefulWidget {
//   const VideoResultView({
//     super.key,
//     this.onBackPressed,
//     this.videoPath,
//     this.analysisResult,
//     this.durationSeconds = 0,
//   });

//   final VoidCallback? onBackPressed;
//   final String? videoPath;
//   final Map<String, dynamic>? analysisResult;
//   final int durationSeconds;

//   @override
//   State<VideoResultView> createState() => _VideoResultViewState();
// }

// class _VideoResultViewState extends State<VideoResultView> {
//   double _riskScore = 0.0;
//   String _riskLevel = 'Low';
//   Color _riskColor = Colors.green;
//   Color _riskBgColor = Colors.green.withOpacity(0.2);

//   late Map<String, dynamic> _metrics;

//   @override
//   void initState() {
//     super.initState();
//     _metrics = widget.analysisResult ?? _getDefaultMetrics();
//     _calculateResults();
//   }

//   void _calculateResults() {
//     // 1️⃣ قراءة نسبة الخطر الإجمالية (Circular Progress Bar)
//     _riskScore = (_metrics['risk_score_percentage'] ?? 0.0).toDouble();
//     _setRiskLevel();
//   }

//   void _setRiskLevel() {
//     if (_riskScore >= 70) {
//       _riskLevel = 'High';
//       _riskColor = Colors.red.shade700;
//       _riskBgColor = Colors.red.withOpacity(0.2);
//     } else if (_riskScore >= 40) {
//       _riskLevel = 'Medium'; // زي ما الباك إند بيبعتها
//       _riskColor = Colors.orange.shade700;
//       _riskBgColor = Colors.orange.withOpacity(0.2);
//     } else {
//       _riskLevel = 'Low';
//       _riskColor = Colors.green.shade700;
//       _riskBgColor = Colors.green.withOpacity(0.2);
//     }
//   }

//   // الداتا الافتراضية محاكية بالضبط لملف الـ AI اللي في الصور
//   Map<String, dynamic> _getDefaultMetrics() {
//     return {
//       'status': 'success',
//       'risk_score_percentage': 76.0,
//       'anomaly_distance': 0.76,
//       'ados_regression_score': 25.2,
//       'overall_confidence': 0.89, // 89%
//       'metadata': {'processing_time_ms': 38383},
//     };
//   }

//   String _getRiskDescription() {
//     if (_riskScore >= 70) {
//       return 'نسبة عالية: أظهر تحليل الفيديو سلوكيات ملحوظة مرتبطة بطيف التوحد. يُنصح باستشارة مختص.';
//     } else if (_riskScore >= 40) {
//       return 'نسبة متوسطة: تم رصد بعض الأنماط السلوكية التي تتطلب المتابعة.';
//     } else {
//       return 'نسبة منخفضة: السلوكيات طبيعية ولا توجد مؤشرات خطيرة. استمر في متابعة التطور الطبيعي.';
//     }
//   }

//   String _formatDuration() {
//     final minutes = widget.durationSeconds ~/ 60;
//     final seconds = widget.durationSeconds % 60;
//     return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.background,
//         leading: IconButton(
//           iconSize: 33,
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: widget.onBackPressed ?? () => Navigator.pop(context),
//         ),
//         title: const CustomText(
//           text: 'Video Analysis Result',
//           size: 21,
//           color: Color(0xff000000),
//           weight: FontWeight.w700,
//           textAlign: TextAlign.center,
//         ),
//         centerTitle: true,
//       ),
//       backgroundColor: AppColors.background,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//           child: Column(
//             children: [
//               _buildVideoInfoCard(),
//               const Gap(13),
//               _buildRiskGaugeCard(),
//               const Gap(13),
//               _buildAiMetricsCards(), // الميثود الجديدة اللي بتقرأ داتا الـ AI
//               const Gap(13),
//               _buildRecommendationsCard(),
//               const Gap(13),
//               CustomElevatedbutton(
//                 onPressed: () {
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/root',
//                     (route) => false,
//                   );
//                 },
//                 text: 'Back to Home',
//               ),
//               const Gap(20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildVideoInfoCard() {
//     return Container(
//       margin: const EdgeInsets.only(top: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.video_library,
//               size: 32,
//               color: Colors.blue,
//             ),
//           ),
//           const Gap(16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CustomText(
//                   text: 'Video Analysis',
//                   size: 16,
//                   weight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//                 const Gap(4),
//                 CustomText(
//                   text: 'Duration: ${_formatDuration()}',
//                   size: 13,
//                   color: Colors.grey.shade600,
//                   weight: FontWeight.w400,
//                 ),
//                 CustomText(
//                   text: 'Status: ${_metrics['status'] ?? 'completed'}',
//                   size: 13,
//                   color: Colors.green.shade700,
//                   weight: FontWeight.w400,
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: _riskBgColor,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               _riskLevel,
//               style: TextStyle(
//                 color: _riskColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRiskGaugeCard() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 27.0, horizontal: 10.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: const Color(0xffDBEFF8),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(top: 5, bottom: 20, left: 10, right: 10),
//               child: CustomText(
//                 text: 'Overall Risk Assessment',
//                 size: 21,
//                 color: Color(0xff6C6969),
//                 weight: FontWeight.w400,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const Gap(5),
//             RiskGauge(value: _riskScore), // دي بتاخد رقم من 0 لـ 100
//             const Gap(17),
//             CustomText(
//               text: _getRiskDescription(),
//               size: 16,
//               color: const Color(0xff6C6969),
//               weight: FontWeight.w400,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // 2️⃣ قراءة وتحليل بيانات الـ AI للعرض
//   Widget _buildAiMetricsCards() {
//     // تجهيز القيم من الـ Map
//     final double adosScore = (_metrics['ados_regression_score'] ?? 0.0)
//         .toDouble();
//     final double anomalyDistance = (_metrics['anomaly_distance'] ?? 0.0)
//         .toDouble();
//     final double confidence =
//         (_metrics['overall_confidence'] ?? 0.0).toDouble() *
//         100; // تحويل 0.89 لـ 89%

//     return Column(
//       children: [
//         const Padding(
//           padding: EdgeInsets.symmetric(vertical: 8),
//           child: CustomText(
//             text: 'AI Detailed Metrics',
//             size: 18,
//             weight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const Gap(8),

//         // كارت 1: ADOS Score
//         CustomCard(
//           backgroundImage: 'assets/ques/ques_image.png',
//           text: 'ADOS Regression Score',
//           textCont:
//               '${adosScore.toStringAsFixed(1)} / 30.0', // من 30 كما بالصورة
//           color: adosScore > 20
//               ? Colors.red.withOpacity(0.2)
//               : Colors.green.withOpacity(0.2),
//           colorTextCont: adosScore > 20
//               ? Colors.red.shade700
//               : Colors.green.shade700,
//         ),
//         const Gap(12),

//         // كارت 2: Anomaly Distance
//         CustomCard(
//           backgroundImage: 'assets/ques/ques_image.png',
//           text: 'Anomaly Distance',
//           textCont:
//               '${anomalyDistance.toStringAsFixed(2)} / 5.0', // من 5 كما بالصورة
//           color: anomalyDistance > 2.5
//               ? Colors.orange.withOpacity(0.2)
//               : Colors.green.withOpacity(0.2),
//           colorTextCont: anomalyDistance > 2.5
//               ? Colors.orange.shade700
//               : Colors.green.shade700,
//         ),
//         const Gap(12),

//         // كارت 3: AI Confidence
//         CustomCard(
//           backgroundImage: 'assets/ques/ques_image.png',
//           text: 'Model Confidence',
//           textCont: '${confidence.toInt()}%',
//           color: Colors.blue.withOpacity(0.2),
//           colorTextCont: Colors.blue.shade700,
//         ),
//       ],
//     );
//   }

//   Widget _buildRecommendationsCard() {
//     // ... (نفس الكود اللي كان عندك مفيش تغيير فيه)
//     List<String> recommendations = [
//       '✓ Continue monitoring developmental milestones',
//       '✓ Encourage social interaction and play',
//     ];

//     if (_riskScore >= 70) {
//       recommendations = [
//         '⚠️ Schedule a consultation with a developmental specialist',
//         '📝 Document specific behaviors for healthcare provider',
//         '🧩 Explore early intervention programs',
//       ];
//     } else if (_riskScore >= 40) {
//       recommendations = [
//         '📊 Monitor progress and track behaviors',
//         '🗣️ Discuss observations with pediatrician',
//       ];
//     }

//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue.shade100, width: 1),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Row(
//             children: [
//               Icon(Icons.lightbulb_outline, color: Colors.amber, size: 24),
//               Gap(8),
//               CustomText(
//                 text: 'Recommendations',
//                 size: 18,
//                 weight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ],
//           ),
//           const Gap(16),
//           ...recommendations.map(
//             (rec) => Padding(
//               padding: const EdgeInsets.only(bottom: 12),
//               child: CustomText(
//                 text: rec,
//                 size: 14,
//                 color: Colors.grey.shade700,
//                 weight: FontWeight.w400,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:neuronest/features/uploadVideo/data/video_model.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/features/uploadVideo/providers/video_provider.dart';

class VideoResultView extends StatelessWidget {
  final VoidCallback? onBackPressed;

  const VideoResultView({
    super.key,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // 1️⃣ قراءة النتيجة مباشرة من الـ Provider
    final result = context.watch<VideoProvider>().result;

    // 2️⃣ إظهار الـ Loading في حالة عدم وصول البيانات بعد
    if (result == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 3️⃣ تحديد الألوان بناءً على مستوى الخطورة القادم من الـ API
    Color riskColor;
    Color riskBgColor;

    if (result.riskLevel.toLowerCase() == 'high') {
      riskColor = Colors.red.shade700;
      riskBgColor = Colors.red.withOpacity(0.2);
    } else if (result.riskLevel.toLowerCase() == 'medium') {
      riskColor = Colors.orange.shade700;
      riskBgColor = Colors.orange.withOpacity(0.2);
    } else {
      riskColor = Colors.green.shade700;
      riskBgColor = Colors.green.withOpacity(0.2);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          iconSize: 33,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              const Gap(16),
              _buildOverallAssessmentCard(result, riskColor, riskBgColor),
              const Gap(13),
              _buildRecommendationsCard(result.riskLevel),
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

  // كارت النتيجة الإجمالية المعتمد على بيانات الـ API فقط
  Widget _buildOverallAssessmentCard(
      VideoResultModel result, Color riskColor, Color riskBgColor) {
    return Container(
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
              text: 'Overall Risk Assessment',
              size: 21,
              color: Color(0xff6C6969),
              weight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ),
          const Gap(5),
          RiskGauge(value: result.totalScore),
          const Gap(17),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: riskBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Risk Level: ${result.riskLevel}',
              style: TextStyle(
                color: riskColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const Gap(12),
          CustomText(
            text: 'Score: ${result.totalScore.toStringAsFixed(1)}%',
            size: 16,
            color: Colors.black87,
            weight: FontWeight.w600,
          ),
          const Gap(8),
          CustomText(
            text: result.message,
            size: 16,
            color: const Color(0xff6C6969),
            weight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // كارت التوصيات الديناميكي بناءً على الـ Risk Level القادم من الـ API
  Widget _buildRecommendationsCard(String riskLevel) {
    List<String> recommendations;

    switch (riskLevel.toLowerCase()) {
      case 'high':
        recommendations = [
          '⚠️ Consult a developmental specialist.',
          '📝 Schedule a comprehensive assessment.',
          '🧩 Begin early intervention.',
        ];
        break;
      case 'medium':
        recommendations = [
          '📊 Continue monitoring.',
          '🗣️ Discuss results with pediatrician.',
          '⏳ Repeat assessment later.',
        ];
        break;
      case 'low':
      default:
        recommendations = [
          '✓ Continue normal developmental monitoring.',
          '🧸 Encourage social interaction.',
          '📅 Repeat screening if needed.',
        ];
        break;
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