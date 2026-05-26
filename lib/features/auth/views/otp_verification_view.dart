// import 'dart:async';
import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/shared/Custom_rowbutton.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_outlinedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  // int _secondsRemaining = 60;
  // Timer? _timer;
  // bool _canResend = false;

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
    // _startTimer();

    // Automatically move focus to the next field.
    for (int i = 0; i < 4; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  // void _startTimer() {
  //   _secondsRemaining = 60;
  //   _canResend = false;
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_secondsRemaining > 0) {
  //         _secondsRemaining--;
  //       } else {
  //         _canResend = true;
  //         timer.cancel();
  //       }
  //     });
  //   });
  // }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    // _timer?.cancel();
    super.dispose();
  }

  String get otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 57.0, horizontal: 5.0),
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
                        Gap(37),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(4, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: SizedBox(
                                width: 58,
                                height: 74,
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: "",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Color(0xff6c6969),
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xff5DB7DE),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 3) {
                                      _focusNodes[index + 1].requestFocus();
                                    }
                                    if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                        // Gap(10),
                        // TextButton(
                        //   onPressed: _canResend
                        //       ? () {
                        //           _startTimer(); // Reset the timer
                        //           ScaffoldMessenger.of(context).showSnackBar(
                        //             const SnackBar(
                        //               content: Text('Code has been resent.'),
                        //             ),
                        //           );
                        //         }
                        //       : null,
                        //   child: Text(
                        //     _canResend
                        //         ? 'Resend Code'
                        //         : 'Resend Code in $_secondsRemaining seconds',
                        //     style: TextStyle(
                        //       color: _canResend ? Colors.blue : Colors.grey,
                        //       fontWeight: _canResend
                        //           ? FontWeight.bold
                        //           : FontWeight.normal,
                        //     ),
                        //   ),
                        // ),
                        Gap(37),
                        CustomElevatedbutton(
                          onPressed: otp.length == 4
                              ? () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/setnewpass',
                                  );
                                }
                              : null,
                          text: 'Continue',
                        ),
                        Gap(28),
                        CustomRowButton(
                          text: 'Don\'t receive an email ??',
                          sizedText: 20,
                          textButton: 'Click to resend',
                        ),
                        Gap(28),
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
        ),
      ),
    );
  }
}
