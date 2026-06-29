import 'dart:async';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class OtpVerificationPasswordView extends StatefulWidget {
  const OtpVerificationPasswordView({super.key});

  @override
  State<OtpVerificationPasswordView> createState() =>
      _OtpVerificationPasswordViewState();
}

class _OtpVerificationPasswordViewState
    extends State<OtpVerificationPasswordView> {
  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  bool _initialized = false;

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String email = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is String) {
        email = args;
      }

      _controllers = List.generate(6, (_) => TextEditingController());
      _focusNodes = List.generate(6, (_) => FocusNode());

      for (int i = 0; i < 6; i++) {
        _controllers[i].addListener(() {
          if (_controllers[i].text.length == 1 && i < 5) {
            _focusNodes[i + 1].requestFocus();
          }
        });

        _focusNodes[i].onKeyEvent = (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[i].text.isEmpty &&
              i > 0) {
            _controllers[i - 1].clear();
            _focusNodes[i - 1].requestFocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        };
      }

      _initialized = true;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _canResend = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendCode() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.forgotPassword(email);

    if (!mounted) return;

    if (success) {
      _startTimer();

      for (var controller in _controllers) {
        controller.clear();
      }

      _focusNodes[0].requestFocus();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Code sent successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to resend code'),
        ),
      );
    }
  }

  // void _resendCode() {
  //   _startTimer();
  //   for (var controller in _controllers) {
  //     controller.clear();
  //   }
  //   _focusNodes[0].requestFocus();

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: const Text('Code has been resent.'),
  //       duration: const Duration(seconds: 2),
  //       backgroundColor: Colors.green,
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 57.0,
                horizontal: 5.0,
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
                          text: 'We sent a password reset code to $email',
                          size: 20,
                          color: Color(0xff6c6969),
                          weight: FontWeight.w400,
                          textAlign: TextAlign.center,
                        ),
                        Gap(37),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: SizedBox(
                                width: 58,
                                height: 74,
                                child: TextField(
                                  cursorColor: Color(0xff5DB7DE),
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  onChanged: (_) {
                                    setState(() {});
                                  },
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
                                ),
                              ),
                            );
                          }),
                        ),
                        Gap(21),
                        Text(
                          _canResend
                              ? 'You can resend now'
                              : 'Resend Code in $_secondsRemaining seconds',
                          style: TextStyle(
                            color: _canResend ? Colors.green : Colors.grey,
                            fontWeight: _canResend
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: _canResend ? _resendCode : null,
                          child: RichText(
                            text: TextSpan(
                              text: "Don't receive an email? ",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 20,
                              ),
                              children: [
                                TextSpan(
                                  text: 'Click to resend',
                                  style: TextStyle(
                                    color: _canResend
                                        ? Colors.blueAccent
                                        : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gap(27),
                        CustomElevatedbutton(
                          onPressed: otp.length == 6
                              ? () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/setnewpass',
                                    arguments: {'email': email, 'code': otp},
                                  );
                                }
                              : null,
                          text: otp.length == 6 ? 'Verify' : 'Enter OTP',
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
