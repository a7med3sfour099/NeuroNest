import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/assessmentResult/views/video_result_view.dart';
import 'package:neuronest/features/uploadVideo/widgets/container_widg.dart';
import 'package:neuronest/features/uploadVideo/widgets/custom_row_bulletPoint_widg.dart';
import 'package:neuronest/features/uploadVideo/widgets/video_upload_widg.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UploadVideoView extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onUploadPressed;
  final Function(Map<String, dynamic>)? onVideoAnalyzed;
  const UploadVideoView({
    super.key,
    this.isLoading = false,
    this.onUploadPressed,
    this.onVideoAnalyzed,
  });

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
bool _isUploading = false;
  String? _uploadedVideoPath;
  Map<String, dynamic>? _analysisResult;

  // ✅ دالة رفع الفيديو وتحليله
  Future<void> _uploadAndAnalyzeVideo() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // 1️⃣ هنا هتضيف كود رفع الفيديو الفعلي
      // مثال: اختيار فيديو من المعرض أو الكاميرا
      // String videoPath = await pickVideoFromGallery();
      
      // 2️⃣ محاكاة رفع الفيديو (استبدلها بكود الرفع الحقيقي)
      await Future.delayed(const Duration(seconds: 2));
      _uploadedVideoPath = '/path/to/uploaded/video.mp4';
      
      // 3️⃣ محاكاة تحليل الفيديو (استبدلها بكود التحليل الحقيقي)
      _analysisResult = await _analyzeVideo(_uploadedVideoPath!);
      
      // 4️⃣ لو فيه callback من برا استخدمه
      if (widget.onVideoAnalyzed != null) {
        widget.onVideoAnalyzed!(_analysisResult!);
      }
      
      // 5️⃣ الانتقال لصفحة النتيجة
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoResultView(
              videoPath: _uploadedVideoPath,
              analysisResult: _analysisResult,
              durationSeconds: 45, // جيب المدة الفعلية للفيديو
              onBackPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    } catch (e) {
      // معالجة الأخطاء
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading video: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  // ✅ دالة تحليل الفيديو (مؤقتة - استبدلها بالتحليل الحقيقي)
  Future<Map<String, dynamic>> _analyzeVideo(String videoPath) async {
    // محاكاة وقت التحليل
    await Future.delayed(const Duration(seconds: 1));
    
    // بيانات تحليل تجريبية
    return {
      'socialInteraction': 65.0,
      'communication': 45.0,
      'repetitiveBehaviors': 55.0,
      'eyeContact': 70.0,
      'facialExpressions': 60.0,
      'gestures': 40.0,
      'vocalizations': 50.0,
      'overallScore': 55.0,
      'analysisStatus': 'completed',
      'videoDuration': 45,
    };
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 65.0, horizontal: 9.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomContainer(
                width: 375,
                title: 'Upload a short video',
                subtitle: 'A 30–60 second video helps us analyze interactions',
              ),
              Gap(25),

              VideoUploadSection(
                onUploadTap: _uploadAndAnalyzeVideo,
                isLoading: _isUploading,
              ),
              Gap(39),
              // (Bullet Points)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomRowBulletPoint(text: 'Child should be visible'),
                    Gap(4),
                    CustomRowBulletPoint(text: 'Natural interaction'),
                    Gap(4),
                    CustomRowBulletPoint(text: 'Quiet environment preferred'),
                    Gap(4),
                    CustomRowBulletPoint(text: 'No editing needed'),
                  ],
                ),
              ),
              Gap(29),
              Divider(color: Colors.black),
              Gap(20),
              CustomText(
                text: 'Your video is encrypted and used only for assessment.',
                size: 21,
                color: Color(0xff6C6969),
                weight: FontWeight.w300,
              ),
              Gap(15),

              /// Upload Button
              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF2196F3),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isUploading ? null : _uploadAndAnalyzeVideo,
                    child: Center(
                      child: _isUploading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Upload Video',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              // Gap(150),
            ],
          ),
        ),
      ),
    );
  }
}
