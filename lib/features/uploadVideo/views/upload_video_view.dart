import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/uploadVideo/widgets/container_widg.dart';
import 'package:neuronest/features/uploadVideo/widgets/custom_row_bulletPoint_widg.dart';
// Keeping project imports minimal; we directly render the upload container UI here.

import 'package:neuronest/shared/custom_text.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

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
  /// Selected video file.
  XFile? selectedVideo;

  /// Video preview controller.
  VideoPlayerController? controller;

  /// Used only for UI states (e.g., upload button spinner).
  bool isUploading = false;

  @override
  void dispose() {
    controller?.dispose();
    controller = null;
    super.dispose();
  }

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
                  await _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined),
                title: const Text('Record Video'),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await _recordVideo();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickVideoFromGallery() async {
    final picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (!mounted) return;
      if (video == null) return;

      await _initializeVideoPlayer(video);
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

  Future<void> _recordVideo() async {
    final picker = ImagePicker();
    try {
      final XFile? video = await picker.pickVideo(source: ImageSource.camera);
      if (!mounted) return;
      if (video == null) return;

      await _initializeVideoPlayer(video);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error recording video: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _initializeVideoPlayer(XFile video) async {
    // Dispose previous controller (if any).
    await controller?.dispose();

    final nextController = VideoPlayerController.file(
      // image_picker provides a file path we can use for VideoPlayerController.
      File(video.path),
    );

    setState(() {
      selectedVideo = video;
      controller = nextController;
    });

    try {
      await nextController.initialize();
      if (!mounted) return;

      // await nextController.setLooping(true);
      await nextController.play();

      // Ensure the UI refreshes after initialization.
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing video player: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildVideoPreview() {
    final c = controller;
    if (c == null || !c.value.isInitialized) {
      return const Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    final aspectRatio = c.value.aspectRatio;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(aspectRatio: aspectRatio, child: VideoPlayer(c)),
    );
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
              const Gap(25),

              /// Upload Video Section (bottom sheet).
              GestureDetector(
                onTap: isUploading ? null : _showVideoSourceBottomSheet,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 28,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Gap(8),
                          if (selectedVideo == null) ...[
                            Image.asset(
                              'assets/video/upload 1.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            const Gap(2),
                            const Text(
                              'Tap to upload or record your video',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Gap(2),
                            const Text(
                              '(Max 60 seconds)',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF6C6969),
                              ),
                            ),
                          ] else ...[
                            SizedBox(
                              height: 160,
                              width: double.infinity,
                              child: _buildVideoPreview(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(39),

              /// (Bullet Points)
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

              /// Upload Button (no navigation/analyze yet).
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
                    onTap: null,
                    child: Center(
                      child: isUploading
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
            ],
          ),
        ),
      ),
    );
  }
}
