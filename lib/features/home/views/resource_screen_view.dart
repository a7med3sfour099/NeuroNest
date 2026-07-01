import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LearningResourcesScreen extends StatelessWidget {
  const LearningResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint(
          "This page is under construction. Please check back later for updates.",
        );

        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          title: 'Under Construction',
          desc:
              'This page is under construction. Please check back later for updates.',
          btnOkOnPress: () {},
        ).show();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FE),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 56,
          title: const Text(
            "Resources",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                //
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(30),
                      _buildNeumorphicSearchField(),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Articles"),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240, //horizontal scroll
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildNeumorphicCard(
                                icon: Icons.menu_book,
                                iconColor: Colors.indigo,
                                title: "Creating a Sensory Oasis at Home",
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.menu_book,
                                iconColor: Colors.indigo,
                                title: "The Power of Visual Schedules",
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.menu_book,
                                iconColor: Colors.indigo,
                                title: "The Power of Visual Schedules",
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.menu_book,
                                iconColor: Colors.indigo,
                                title: "The Power of Visual Schedules",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildSectionTitle("Videos"),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 240,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildNeumorphicCard(
                                icon: Icons.play_circle_fill,
                                iconColor: Colors.teal,
                                title: "Morning Calmness Routine",
                                isVideo: true,
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.play_circle_fill,
                                iconColor: Colors.teal,
                                title: "Understanding Stimming Behavior",
                                isVideo: true,
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.play_circle_fill,
                                iconColor: Colors.grey.shade700,
                                title: "Understanding Stimming Behavior",
                              ),
                              const Gap(15),
                              _buildNeumorphicCard(
                                icon: Icons.settings,
                                iconColor: Colors.grey.shade700,
                                title: "Understanding Stimming Behavior",
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== Reusable Widgets ==================

  Widget _buildNeumorphicSearchField() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-1, -1),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(1, 1),
            blurRadius: 10,
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search",
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildNeumorphicCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    bool isVideo = false,
  }) {
    return Container(
      width: 168,
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7FE),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 90,
              child: Center(
                child: Icon(icon, size: isVideo ? 68 : 58, color: iconColor),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
