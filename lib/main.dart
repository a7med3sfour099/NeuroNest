// Flutter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Core
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/routes/app_routes.dart';
import 'package:neuronest/core/routes/nav_key.dart';
import 'package:neuronest/splash.dart';

// Providers
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/Home/providers/history_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/question_provider.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:neuronest/features/auth/providers/profile_provider.dart';
import 'package:neuronest/features/uploadVideo/providers/video_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        navigatorKey: NavKey.navigatorKey,

        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
            centerTitle: false,
            titleTextStyle: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        home: const SplashView(),
        routes: AppRoutes.routes,
      ),
    );
  }
}
