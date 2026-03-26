import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/shared/custom_outlinedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SuccessSetView extends StatefulWidget {
  const SuccessSetView({super.key});

  @override
  State<SuccessSetView> createState() => _SuccessSetViewState();
}

class _SuccessSetViewState extends State<SuccessSetView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 235.0,
            horizontal: 15.0,
          ),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/auth/success_set.png',
                  width: 155,
                  height: 155,
                ),
              ),
              Gap(52),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    CustomText(
                      text: 'Success password reset',
                      size: 23,
                      color: Color(0xff000000),
                      weight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    Gap(3),
                    CustomText(
                      text: 'Your password successfully reset',
                      size: 20,
                      color: Color(0xff6c6969),
                      weight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    Gap(34),
                    CustomOutlinedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      text: 'Back to Login',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
