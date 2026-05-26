import 'package:flutter/material.dart';

class AccountProfileScreen extends StatelessWidget {
  const AccountProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7FE),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "Account & Profile",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
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
              child: Column(
                children: [
                  const SizedBox(height: 56),
                  Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundImage: AssetImage('assets/logo/app_logo.png'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "User Profile",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "user@example.com",
                              style: TextStyle(color: Colors.black54, fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Settings Grid
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _buildSettingItem(Icons.track_changes, "Progress\nTracking", color: const Color(0xFF2196F3)),
                          _buildSettingItem(Icons.notifications, "Notifications", color: const Color(0xFFFF9800)),
                          _buildSettingItem(Icons.settings, "App\nSettings", color: const Color(0xFF9C27B0)),
                          _buildSettingItem(Icons.help, "Help &\nSupport", color: const Color(0xFF4CAF50)),
                          _buildSettingItem(Icons.logout, "Log Out", color: Colors.red),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Edit Profile Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF00BCD4)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String label, {
    Color color = Colors.black87,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color == Colors.red ? Colors.red : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
