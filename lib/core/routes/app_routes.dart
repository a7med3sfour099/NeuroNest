import 'package:flutter/material.dart';

// View Imports
import 'package:neuronest/features/Home/views/child_info_view.dart';
import 'package:neuronest/features/assessmentQues/views/quesboard_view.dart';
import 'package:neuronest/features/assessmentQues/views/start_ques_view.dart';
import 'package:neuronest/features/assessmentResult/views/result_view.dart';
import 'package:neuronest/features/assessmentResult/views/video_result_view.dart';
import 'package:neuronest/features/auth/views/forget_pass_view.dart';
import 'package:neuronest/features/auth/views/login_view.dart';
import 'package:neuronest/features/auth/views/otp_verification_signup_view.dart';
import 'package:neuronest/features/auth/views/setnewpass_view.dart';
import 'package:neuronest/features/auth/views/signup_view.dart';
import 'package:neuronest/features/auth/views/success_set_view.dart';
import 'package:neuronest/features/auth/views/verification_view.dart';
import 'package:neuronest/features/auth/views/otp_verification_pass_view.dart';
import 'package:neuronest/features/onboarding/views/onboarding_screen_view.dart';
import 'package:neuronest/features/uploadVideo/views/start_video_view.dart';
import 'package:neuronest/root.dart'; 

class AppRoutes {
  /// Defines all named routes for the application.
  static Map<String, WidgetBuilder> get routes => {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginView(),
        '/signup': (context) => const SignUpView(),
        '/forgetpass': (context) => const ForgetPasswordView(),
        '/otpverificationpass': (context) => const OtpVerificationPasswordView(),
        '/otpverificationsignup': (context) => const OtpVerificationSignupView(),
        '/verification': (context) => const VerificationView(),
        '/setnewpass': (context) => const SetNewPasswordView(),
        '/successset': (context) => const SuccessSetView(),
        '/childinfo': (context) => const ChildInfoView(),
        '/startques': (context) => const StartQuesView(),
        '/quesboard': (context) => const QuesboardView(),
        '/result': (context) => const ResultView(),
        '/videoresult': (context) => const VideoResultView(),
        '/startvideo': (context) => const StartVideoView(),
        '/root': (context) => const MainNavigationScreen(),
      };
}