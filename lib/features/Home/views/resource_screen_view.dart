import 'package:flutter/material.dart';

class LearningResourcesScreen extends StatelessWidget {
  const LearningResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {},
        ),
        title: const Text(
          "Resources",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () {},
          ),
        ],
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
                  colors: [
                    Color(0xFFD0E5FF),
                    Color(0xFFF4F7FE),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  const SizedBox(height: 56),

            // Neumorphic Search Field
            _buildNeumorphicSearchField(),

            const SizedBox(height: 32),

            // Articles Section
            _buildSectionTitle("Articles"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNeumorphicCard(
                  icon: Icons.menu_book,
                  iconColor: Colors.indigo,
                  title: "Creating a Sensory Oasis at Home",
                ),
                _buildNeumorphicCard(
                  icon: Icons.menu_book,
                  iconColor: Colors.indigo,
                  title: "The Power of Visual Schedules",
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Videos Section
            _buildSectionTitle("Videos"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNeumorphicCard(
                  icon: Icons.play_circle_fill,
                  iconColor: Colors.teal,
                  title: "Morning Calmness Routine",
                  isVideo: true,
                ),
                _buildNeumorphicCard(
                  icon: Icons.settings,
                  iconColor: Colors.grey.shade700,
                  title: "Understanding Stimming Behavior",
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Exercises Section
            _buildSectionTitle("Exercises"),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNeumorphicCard(
                  icon: Icons.access_time,
                  iconColor: Colors.orange,
                  title: "The 'My Day' Journal Guide",
                ),
                _buildNeumorphicCard(
                  icon: Icons.calendar_today,
                  iconColor: Colors.purple,
                  title: "Mindful Sensory Bin Ideas",
                ),
              ],
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
      ),
      ],
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
            offset: Offset(-4, -4),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(4, 4),
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
            // Icon
            SizedBox(
              height: 90,
              child: Center(
                child: Icon(icon, size: isVideo ? 68 : 58, color: iconColor),
              ),
            ),
            const Spacer(),
            // Title
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
