import 'package:firstversion1/features/Home/views/child_info_view.dart';
import 'package:firstversion1/features/assessmentQues/views/quesboard_view.dart';
import 'package:firstversion1/features/assessmentQues/views/start_ques_view.dart';
import 'package:firstversion1/features/assessmentResult/views/newResult.dart';
import 'package:firstversion1/features/assessmentResult/views/result_view.dart';
import 'package:firstversion1/features/auth/views/forget_pass_view.dart';
import 'package:firstversion1/features/auth/views/login_view.dart';
import 'package:firstversion1/features/auth/views/setnewpass_view.dart';
import 'package:firstversion1/features/auth/views/signup_view.dart';
import 'package:firstversion1/features/auth/views/success_set_view.dart';
import 'package:firstversion1/features/auth/views/verification_view.dart';
import 'package:firstversion1/features/auth/views/otp_verification_view.dart';
import 'package:firstversion1/features/onboarding/views/onboarding_screen_view.dart';
import 'package:firstversion1/features/uploadVideo/views/start_video_view.dart';
import 'package:firstversion1/features/uploadVideo/views/upload_video_view.dart';
import 'package:firstversion1/splash.dart';
import 'package:firstversion1/test_me.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpectrumSense',
      // home: SplashView(),
      // home: TestMe(),
      home: StartVideoView(),
      routes: {
        '/onboarding': (BuildContext context) => const OnboardingScreen(),
        '/login': (BuildContext context) => const LoginView(),
        '/signup': (BuildContext context) => const SignUpView(),
        '/forgetpass': (BuildContext context) => const ForgetPasswordView(),
        '/otpverification': (BuildContext context) =>
            const OtpVerificationView(),
        '/verification': (BuildContext context) => const VerificationView(),
        '/setnewpass': (BuildContext context) => const SetNewPasswordView(),
        '/successset': (BuildContext context) => const SuccessSetView(),
        '/childinfo': (BuildContext context) => const ChildInfoView(),
        '/startques': (BuildContext context) => const StartQuesView(),
        '/quesboard': (BuildContext context) => const QuesboardView(),
        '/result': (BuildContext context) => const ResultView(),
        '/uploadvideo': (BuildContext context) => const UploadVideoView(),
        '/test': (BuildContext context) => const TestMe(),
      },
    );
  }
}
