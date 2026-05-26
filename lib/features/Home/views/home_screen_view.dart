import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Reusable card decoration for the soft shadow look
  BoxDecoration get _cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.blueGrey.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 2,
        offset: const Offset(0, 5),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      body: Stack(
        children: [
          // Top Background Gradient
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
                    Color(0xFFD0E5FF), // Light blue top
                    Color(0xFFF4F7FE), // Fades to background color
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildProfileCard(),
                  const SizedBox(height: 32),
                  const Text(
                    "Quick access",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuickAccessCards(),
                  const SizedBox(height: 24),
                  _buildUpcomingBookings(),
                  const SizedBox(height: 24),
                  _buildProgressTracker(),
                  const Gap(40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Gap(40),
        // Balance for centering title
        Text(
          "My Dashboard",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                size: 28,
                color: Colors.black87,
              ),
              onPressed: () {
                print('This Feature will available soon');
              },
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.purple.shade100,
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ), // Replace with actual asset
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Parent Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Child Name",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Next screening due in 3 days",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade300,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: _cardDecoration,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.paste,
                    size: 32,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Start New\nAssessment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: _cardDecoration,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.video_camera_back,
                    size: 32,
                    color: Colors.indigo.shade400,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Start New\nVideo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingBookings() {
    return GestureDetector(
      onTap: () {
        print('This Features will be added soon');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: _cardDecoration,
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.red.shade300, size: 28),
            const SizedBox(width: 16),
            const Text(
              "Upcoming Bookings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTracker() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Progress tracker",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(Icons.trending_up, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 40),
                      FlSpot(1, 60),
                      FlSpot(2, 50),
                      FlSpot(3, 80), // Active point
                      FlSpot(4, 55),
                      FlSpot(5, 80),
                      FlSpot(6, 90),
                    ],
                    isCurved: true,
                    color: Colors.blueAccent,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) =>
                          spot.x == 3, // Only show dot on the peak
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: Colors.blueAccent,
                            strokeWidth: 3,
                            strokeColor: Colors.white,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
