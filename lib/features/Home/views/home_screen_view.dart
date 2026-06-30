import 'package:flutter/material.dart';
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/Home/providers/history_provider.dart';
import 'package:neuronest/features/Home/widgets/assessment_buttons.dart';
import 'package:neuronest/features/Home/widgets/child_card.dart';
import 'package:neuronest/features/Home/widgets/latest_assessment_card.dart';
import 'package:neuronest/features/Home/widgets/stats_cards.dart';
import 'package:neuronest/features/Home/widgets/testy.dart';
import 'package:neuronest/features/Home/widgets/upcomming_widget.dart';
import 'package:neuronest/features/Home/widgets/welcome_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final childProvider = context.read<ChildProvider>();

      await childProvider.loadChild();

      if (childProvider.currentChild != null) {
        await context.read<HistoryProvider>().loadHistory(
          childProvider.currentChild!.childID,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        // centerTitle: true,
      ),

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
                  colors: [Color(0xFFD0E5FF), Color(0xFFF4F7FE)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Consumer2<ChildProvider, HistoryProvider>(
              builder: (context, childProvider, historyProvider, _) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await childProvider.loadChild();

                    if (childProvider.currentChild != null) {
                      await historyProvider.loadHistory(
                        childProvider.currentChild!.childID,
                      );
                    }
                  },

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

                        // TestyWidget(),

                        // SizedBox(height: 22),
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
            ),
          ),
        ],
      ),
    );
  }
}
