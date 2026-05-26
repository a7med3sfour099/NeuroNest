import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/features/assessmentResult/widgets/riskgauge_widg.dart';
import 'package:firstversion1/features/assessmentResult/widgets/risky_test2.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class nResultView extends StatefulWidget {
  const nResultView({super.key, this.onBackPressed});

  final VoidCallback? onBackPressed;

  @override
  State<nResultView> createState() => _ResultViewState();
}

class _ResultViewState extends State<nResultView> {
  get onBackPressed => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          iconSize: 33,
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: onBackPressed ?? () => Navigator.pop(context),
        ),
        title: CustomText(
          text: 'Assesment result',
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 27.0,
                  horizontal: 10.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBEFF8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 12.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 5,
                          bottom: 20,
                          left: 10,
                          right: 10,
                        ),
                        child: CustomText(
                          text: 'Social Interaction',
                          size: 21,
                          color: Color(0xff6C6969),
                          weight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Gap(5),
                      // RiskGauge(value: score?.toDouble() ?? 0.0),
                      RiskGauge(value: 50.0),
                      Gap(17),
                      CustomText(
                        text:
                            'Based on your answers, some behaviors may be associated with autism spectrum traits.',
                        size: 16,
                        color: Color(0xff6C6969),
                        weight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // RiskGauge(value: 30.0),
              // SegmentedGauge(value: 20),
              GlassmorphicGauge(value: 0.80),
            ],
          ),
        ),
      ),
    );
  }
}
