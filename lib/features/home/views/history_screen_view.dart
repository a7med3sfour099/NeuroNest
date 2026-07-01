import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:neuronest/features/home/providers/history_provider.dart';
import 'package:neuronest/features/home/providers/child_provider.dart';

class AssessmentHistoryScreen extends StatefulWidget {
  const AssessmentHistoryScreen({super.key});

  @override
  State<AssessmentHistoryScreen> createState() =>
      _AssessmentHistoryScreenState();
}

String formatDate(String dateString) {
  final date = DateTime.parse(dateString);

  return DateFormat('dd MMM yyyy').format(date);
}

class _AssessmentHistoryScreenState extends State<AssessmentHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final childProvider = context.read<ChildProvider>();

      if (childProvider.currentChild == null) {
        await childProvider.loadChild();
      }
      print("Current Child => ${childProvider.currentChild?.childID}");

      if (childProvider.currentChild != null) {
        await context.read<HistoryProvider>().loadHistory(
          childProvider.currentChild!.childID,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HistoryProvider>();
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Assessment History",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
            child: Column(
              children: [
                // Summary Card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SummaryCard(provider: provider),
                ),

                // // Search Bar
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //   child: SearchBarWidget(controller: _searchController),
                // ),
                const SizedBox(height: 16),

                // Past Assessments Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Past assessments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Assessments List
                // Expanded(
                //   child: ListView(
                //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                //     children: const [
                //       AssessmentListItem(
                //         color: Color(0xFFFF9800), // Orange
                //         icon: Icons.assignment,
                //         type: "Questionnaire",
                //         date: "13 May",
                //         result: "High Probability",
                //         resultColor: Colors.red,
                //       ),
                //       SizedBox(height: 12),
                //       AssessmentListItem(
                //         color: Color(0xFF9C27B0), // Purple
                //         icon: Icons.description,
                //         type: "Document Review",
                //         date: "3 May",
                //         result: "Moderate",
                //         resultColor: Colors.orange,
                //       ),
                //       SizedBox(height: 12),
                //       AssessmentListItem(
                //         color: Color(0xFF2196F3), // Blue
                //         icon: Icons.videocam,
                //         type: "Video Session",
                //         date: "22 April",
                //         result: "Low Probability",
                //         resultColor: Colors.green,
                //       ),
                //       SizedBox(height: 12),
                //       AssessmentListItem(
                //         color: Color(0xFF2196F3), // Blue
                //         icon: Icons.videocam,
                //         type: "Video Session",
                //         date: "22 April",
                //         result: "Low Probability",
                //         resultColor: Colors.green,
                //       ),
                //       SizedBox(height: 12),
                //       AssessmentListItem(
                //         color: Color(0xFF9C27B0), // Purple
                //         icon: Icons.description,
                //         type: "Document Review",
                //         date: "3 May",
                //         result: "Moderate",
                //         resultColor: Colors.orange,
                //       ),
                //       SizedBox(height: 12),
                //       AssessmentListItem(
                //         color: Color(0xFF2196F3), // Blue
                //         icon: Icons.videocam,
                //         type: "Video Session",
                //         date: "22 April",
                //         result: "Low Probability",
                //         resultColor: Colors.green,
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (provider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.history == null) {
                        return const Center(
                          child: Text("Failed to load history"),
                        );
                      }

                      if (provider.history!.history.isEmpty) {
                        return const Center(
                          child: Text("No assessments yet 😊"),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.history!.history.length,
                        itemBuilder: (context, index) {
                          final item = provider.history!.history[index];
                          final bool isVideo = (item.screeningType)
                              .toLowerCase()
                              .contains("video");
                          final Color itemColor = isVideo
                              ? Colors.blue
                              : Color(0xFFFF9800);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: AssessmentListItem(
                              color: itemColor,
                              icon: isVideo
                                  ? Icons.videocam_outlined
                                  : Icons.assignment_outlined,
                              type: item.screeningType,
                              date: formatDate(item.screeningDate),
                              result: item.riskLevel,
                              resultColor: item.riskLevel == "High"
                                  ? Colors.red
                                  : item.riskLevel == "Moderate"
                                  ? Colors.orange
                                  : Colors.green,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // ====================> Bottom Button <====================
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Container(
                //     width: double.infinity,
                //     height: 56,
                //     decoration: BoxDecoration(
                //       gradient: const LinearGradient(
                //         colors: [Color(0xFF1565C0), Color(0xFF00BCD4)],
                //         begin: Alignment.centerLeft,
                //         end: Alignment.centerRight,
                //       ),
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //     child: ElevatedButton(
                //       onPressed: () {
                //         // TODO: Navigate to detailed history
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.transparent,
                //         shadowColor: Colors.transparent,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(30),
                //         ),
                //       ),
                //       child: const Text(
                //         "View Detailed History",
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== Summary Card ====================
class SummaryCard extends StatelessWidget {
  final HistoryProvider provider;
  const SummaryCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Current Assessment Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column (Last Date)
              Expanded(
                child: Column(
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      size: 32,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Last assessment",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.history!.stats.lastAssessmentDate == null
                          ? "No assessment"
                          : formatDate(
                              provider.history!.stats.lastAssessmentDate!,
                            ),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Container(
                height: 60,
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ),

              // Center Column (Total)
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "${provider.history?.stats.total ?? 0}",
                      style: const TextStyle(
                        fontSize: 36,
                        height: 1.1,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF455A64),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Total",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              Container(
                height: 60,
                width: 1,
                color: Colors.grey.withOpacity(0.2),
              ),

              // Right Column (Result)
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.scale, size: 32, color: Colors.orange),
                    const SizedBox(height: 8),
                    const Text(
                      "Current result",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      provider.history?.stats.currentRiskLevel ?? "N/A",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== Search Bar ====================
class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        textDirection: Directionality.of(context),
        decoration: const InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: Colors.black45),
          prefixIcon: Icon(Icons.search, color: Colors.black54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ==================== Assessment List Item ====================
class AssessmentListItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String type;
  final String date;
  final String result;
  final Color resultColor;

  const AssessmentListItem({
    super.key,
    required this.color,
    required this.icon,
    required this.type,
    required this.date,
    required this.result,
    required this.resultColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Colored Icon Container
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Type: $type",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Completed on: $date",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 6),
                Text(
                  "Result: $result",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: resultColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
