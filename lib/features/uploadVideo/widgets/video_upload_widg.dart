import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VideoUploadSection extends StatelessWidget {
  final VoidCallback? onUploadTap;
  final bool isLoading;

  const VideoUploadSection({
    super.key,
    this.onUploadTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onUploadTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DottedBorder(
            color: const Color(0xFF90CAF9),
            strokeWidth: 2.5,
            dashPattern: const [6, 6],
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 28),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Gap(8),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
