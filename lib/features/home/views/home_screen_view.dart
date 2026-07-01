import 'package:flutter/material.dart';
import 'package:neuronest/core/constants/app_colors.dart'; // NEW IMPORT
import 'package:neuronest/features/home/providers/child_provider.dart';
import 'package:neuronest/features/home/providers/history_provider.dart';
import 'package:neuronest/features/home/widgets/assessment_buttons.dart';
import 'package:neuronest/features/home/widgets/child_card.dart';
import 'package:neuronest/features/home/widgets/latest_assessment_card.dart';
import 'package:neuronest/features/home/widgets/stats_cards.dart';
import 'package:neuronest/features/home/widgets/upcomming_widget.dart';
import 'package:neuronest/features/home/widgets/welcome_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInitLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboardData();
    });
  }

  Future<void> _fetchDashboardData() async {
    if (!mounted) return;

    setState(() {
      _isInitLoading = true;
      _errorMessage = null;
    });

    try {
      final childProvider = context.read<ChildProvider>();
      await childProvider.loadChild();

      if (!mounted) return;

      if (childProvider.currentChild != null) {
        await context.read<HistoryProvider>().loadHistory(
          childProvider.currentChild!.childID,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              "Failed to connect to the server. Please check your internet connection.";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(title: const Text("Dashboard")),

      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,

                  colors: [AppColors.gradientStart, AppColors.background],
                ),
              ),
            ),
          ),
          SafeArea(child: _buildBodyContent()),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isInitLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _fetchDashboardData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer2<ChildProvider, HistoryProvider>(
      builder: (context, childProvider, historyProvider, _) {
        return RefreshIndicator(
          onRefresh: _fetchDashboardData,
          color: AppColors.primary, // Set spinner color
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                WelcomeCard(),
                SizedBox(height: 18),
                ChildCard(),
                SizedBox(height: 22),
                AssessmentButtons(),
                SizedBox(height: 22),
                UpcommingAppointment(),
                SizedBox(height: 22),
                StatsCards(),
                SizedBox(height: 22),
                LatestAssessmentCard(),
                SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
