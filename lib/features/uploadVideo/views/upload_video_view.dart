import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/uploadVideo/views/analysis_video_view.dart';
import 'package:neuronest/features/uploadVideo/widgets/container_widg.dart';
import 'package:neuronest/features/uploadVideo/widgets/custom_row_bulletPoint_widg.dart';
import 'package:neuronest/shared/custom_text.dart';

class UploadVideoView extends StatefulWidget {
  final int childId;
  const UploadVideoView({super.key, required this.childId});

  @override
  State<UploadVideoView> createState() => _UploadVideoViewState();
}

class _UploadVideoViewState extends State<UploadVideoView> {
  XFile? selectedVideo;

  Future<void> _showVideoSourceBottomSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_library_outlined),
                title: const Text('Upload from Gallery'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickVideo(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Record Video'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _pickVideo(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: source);
      if (video == null) return;

      setState(() {
        selectedVideo = video;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
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
              const Gap(25),

              /// دبة رفع الفيديو
              GestureDetector(
                onTap: _showVideoSourceBottomSheet,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 28,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F8FF),
                    borderRadius: BorderRadius.circular(10),
                    border: selectedVideo != null
                        ? Border.all(color: Colors.green, width: 2)
                        : null,
                  ),
                  child: Column(
                    children: [
                      Visibility(
                        visible: selectedVideo == null,
                        child: Image.asset(
                          'assets/video/upload 1.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Visibility(
                        visible: selectedVideo != null,
                        child: Icon(
                          Icons.check_circle_sharp,
                          size: 100,
                          color: Colors.green,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        selectedVideo == null
                            ? 'Tap to upload or record your video'
                            : 'Video Selected Successfully!',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(2),
                      Text(
                        selectedVideo == null
                            ? '(Max 60 seconds)'
                            : 'Tap to change video',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6C6969),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Gap(39),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomRowBulletPoint(text: 'Child should be visible'),
                    const Gap(4),
                    CustomRowBulletPoint(text: 'Natural interaction'),
                    const Gap(4),
                    CustomRowBulletPoint(text: 'Quiet environment preferred'),
                    const Gap(4),
                    CustomRowBulletPoint(text: 'No editing needed'),
                  ],
                ),
              ),
              const Gap(29),
              const Divider(color: Colors.black),
              const Gap(20),
              CustomText(
                text: 'Your video is encrypted and used only for assessment.',
                size: 21,
                color: const Color(0xff6C6969),
                weight: FontWeight.w300,
              ),
              const Gap(15),

              Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: selectedVideo == null
                      ? Colors.grey
                      : const Color(0xFF2196F3),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: selectedVideo == null
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a video first!'),
                              ),
                            );
                          }
                        : () {
                            // الانتقال وتمرير مسار الفيديو للصفحة الجاية
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewAndAnalyzeView(
                                  videoPath: selectedVideo!.path,
                                  childId: widget.childId,
                                ),
                              ),
                            );
                          },
                    child: const Center(
                      child: Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
