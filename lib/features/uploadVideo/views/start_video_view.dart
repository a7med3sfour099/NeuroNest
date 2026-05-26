import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/features/uploadVideo/widgets/container_widg.dart';
import 'package:firstversion1/features/uploadVideo/widgets/custom_card_widg.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartVideoView extends StatefulWidget {
  const StartVideoView({super.key});

  @override
  State<StartVideoView> createState() => _StartVideoViewState();
}

class _StartVideoViewState extends State<StartVideoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          iconSize: 33,
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Autism Assessment',
          size: 23,
          color: Color(0xff000000),
          weight: FontWeight.w700,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xff6C6969)),
        ),
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Gap(20),
              CustomContainer(
                width: 319,
                title: 'How would you like to start?',
                subtitle:
                    'Select the way you prefer to help us assess your child.',
              ),
              Gap(5),

              /// First Card
              CustomCard(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/uploadvideo'),
                shapeColor: Color(0xff5DB7DE).withOpacity(0.75),
                image: 'assets/video/upload 1.png',
                text: 'Upload Child Video',
                subText: 'Analyze a video of your child.',
                bColor: Color(0xff5DB7DE),
                bText: 'Upload Video',
              ),
              Gap(5),

              /// Second Card
              CustomCard(
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/startques'),
                shapeColor: Color(0xffEF7902),
                image: 'assets/ques/ques_view.png',
                text: 'Answer Questions',
                subText: 'Complete a questionnaire.',
                bColor: Color(0xffEF7902),
                bText: 'Start Questions',
              ),
              Gap(20),
              Container(
                width: 314,
                height: 52,
                child: CustomText(
                  text:
                      'You can upload a video of your child or answer a series of questions to assess them for autism.',
                  size: 14,
                  color: Color(0xff6C6969),
                  weight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
