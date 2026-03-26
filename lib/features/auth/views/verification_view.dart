import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/shared/Custom_rowbutton.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_outlinedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key});

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 122.0,
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/auth/verify.png',
                  width: 329,
                  height: 246,
                ),
              ),
              Gap(12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    CustomText(
                      text: 'Check your email',
                      size: 23,
                      color: Color(0xff000000),
                      weight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                    Gap(3),
                    CustomText(
                      text:
                          'We sent a password reset line to example@gmail.com',
                      size: 20,
                      color: Color(0xff6c6969),
                      weight: FontWeight.w400,
                      textAlign: TextAlign.center,
                    ),
                    Gap(18),
                    CustomElevatedbutton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        '/otpverification',
                      ),
                      text: 'Continue',
                    ),
                    Gap(28),
                    CustomRowButton(
                      text: 'Don\'t receive an email ??',
                      sizedText: 21,
                      textButton: 'Click to',
                    ),
                    Gap(28),
                    CustomOutlinedButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      text: 'Back to Login',
                      backgroundImage: null,
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
