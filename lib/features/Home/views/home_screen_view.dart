import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Time + Notification
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("9:41", style: TextStyle(color: Colors.white, fontSize: 17)),
                      const Icon(Icons.notifications_rounded, color: Colors.white, size: 28),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Parent Profile Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage('assets/parent.png'), // غير الصورة حسب اسمك
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Parent Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("Child Name", style: TextStyle(fontSize: 15, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 3D Score
            Center(
              child: CircularPercentIndicator(
                radius: 95,
                lineWidth: 20,
                animation: true,
                percent: 0.75,           // غير النسبة حسب الـ score
                center: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("3D", style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: Colors.orange)),
                    Text("Score", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.orange,
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("Weekly Progress", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // Upcoming Activities
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActivityCard(Icons.menu_book, "Upcoming\nActivities"),
                  _buildActivityCard(Icons.notifications, "Notification"),
                  _buildActivityCard(Icons.pie_chart, "Stable\nProgress"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Start Next Step Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  minimumSize: const Size(double.infinity, 58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Start Next Step", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard(IconData icon, String title) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade300, blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: Colors.orange),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}