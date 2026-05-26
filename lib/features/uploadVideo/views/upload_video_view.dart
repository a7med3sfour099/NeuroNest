import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/features/uploadVideo/widgets/container_widg.dart';
import 'package:firstversion1/features/uploadVideo/widgets/custom_row_bulletPoint_widg.dart';
import 'package:firstversion1/features/uploadVideo/widgets/video_upload_widg.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UploadVideoView extends StatefulWidget {
  final bool isLoading;
  const UploadVideoView({super.key, this.isLoading = false});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
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
                onUploadTap: () {
                  // ضع هنا كود اختيار أو تسجيل الفيديو
                  print('تم الضغط على منطقة رفع الفيديو');
                  // مثال: استخدام image_picker أو camera
                },
                isLoading: widget.isLoading,
              ),
              Gap(15),
              // (Bullet Points)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomRowBulletPoint(text: 'Child should be visible'),
                    CustomRowBulletPoint(text: 'Natural interaction'),
                    CustomRowBulletPoint(text: 'Quiet environment preferred'),
                    CustomRowBulletPoint(text: 'No editing needed'),
                  ],
                ),
              ),
              Gap(29),
              Divider(color: Colors.black, thickness: 1),

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
                    onTap: widget.isLoading
                        ? null
                        : () {
                            // نفس الـ onUploadTap بتاع VideoUploadSection
                            print('تم الضغط على Upload Video');
                          },
                    child: Center(
                      child: widget.isLoading
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
