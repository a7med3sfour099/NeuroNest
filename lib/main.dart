import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/Home/providers/history_provider.dart';
import 'package:neuronest/features/Home/views/child_info_view.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/features/assessmentQues/views/quesboard_view.dart';
import 'package:neuronest/features/assessmentQues/views/start_ques_view.dart';
import 'package:neuronest/features/assessmentResult/views/result_view.dart';
import 'package:neuronest/features/assessmentResult/views/video_result_view.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:neuronest/features/auth/views/forget_pass_view.dart';
import 'package:neuronest/features/auth/views/login_view.dart';
import 'package:neuronest/features/auth/views/otp_verification_signup_view.dart';
import 'package:neuronest/features/auth/views/setnewpass_view.dart';
import 'package:neuronest/features/auth/views/signup_view.dart';
import 'package:neuronest/features/auth/views/success_set_view.dart';
import 'package:neuronest/features/auth/views/verification_view.dart';
import 'package:neuronest/features/auth/views/otp_verification_pass_view.dart';
import 'package:neuronest/features/auth/providers/profile_provider.dart';
import 'package:neuronest/features/onboarding/views/onboarding_screen_view.dart';
import 'package:neuronest/features/uploadVideo/providers/video_provider.dart';
import 'package:neuronest/features/uploadVideo/views/analysis_video_view.dart';
import 'package:neuronest/features/uploadVideo/views/start_video_view.dart';
import 'package:neuronest/features/uploadVideo/views/upload_video_view.dart';
import 'package:neuronest/root.dart';
import 'package:neuronest/splash.dart';
import 'package:neuronest/test_me.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChildProvider()),
        ChangeNotifierProvider(create: (_) => ScreeningProvider()),
        ChangeNotifierProvider(create: (_) => QuestionProvider()),
        ChangeNotifierProvider(create: (_) => VideoProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NeuroNest',
        home: SplashView(),
        // home: StartVideoView(),
        // home: LoginView(),
        // home: SignUpView(),
        // home: OtpVerificationSignupView(),
        // home: VerificationView(),
        // home: ChildInfoView(),
        // home: QuesboardView(),
        // home: TestMe(),
        // home: NewResultView(),
        // home: StartVideoView(),
        // home: UploadVideoView(),
        // home: ResultView(),
        // home: MainNavigationScreen(),
        // home: VerificationView(),
        routes: {
          '/onboarding': (BuildContext context) => const OnboardingScreen(),
          '/login': (BuildContext context) => const LoginView(),
          '/signup': (BuildContext context) => const SignUpView(),
          '/forgetpass': (BuildContext context) => const ForgetPasswordView(),
          '/otpverificationpass': (BuildContext context) =>
              const OtpVerificationPasswordView(),
          '/otpverificationsignup': (BuildContext context) =>
              const OtpVerificationSignupView(),
          '/verification': (BuildContext context) => const VerificationView(),
          '/setnewpass': (BuildContext context) => const SetNewPasswordView(),
          '/successset': (BuildContext context) => const SuccessSetView(),
          '/childinfo': (BuildContext context) => const ChildInfoView(),
          '/startques': (BuildContext context) => const StartQuesView(),
          '/quesboard': (BuildContext context) => const QuesboardView(),
          '/result': (BuildContext context) => const ResultView(),
          '/videoresult': (BuildContext context) => const VideoResultView(),
          '/startvideo': (BuildContext context) => const StartVideoView(),
          '/root': (BuildContext context) => const MainNavigationScreen(),
          '/test': (BuildContext context) => const TestMe(),
        },
      ),
    );
  }
}
