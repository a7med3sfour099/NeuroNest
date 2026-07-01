import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/uploadVideo/views/upload_video_view.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class StartVideoView extends StatefulWidget {
  const StartVideoView({super.key});

  @override
  State<StartVideoView> createState() => _StartVideoViewState();
}

class _StartVideoViewState extends State<StartVideoView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 198.0,
              horizontal: 15.0,
            ),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/video/start_video.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Gap(3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Gap(3),
                      CustomText(
                        text:
                            'You can start the assessment by uploading a video of your daily activities.',
                        size: 20,
                        color: AppColors.textTertiary,
                        weight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      Gap(32),
                      CustomElevatedbutton(
                        onPressed: () {
                          final child = context
                              .read<ChildProvider>()
                              .currentChild;

                          if (child == null) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  UploadVideoView(childId: child.childID),
                            ),
                          );
                        },
                        text: 'Start Uploading Video',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
