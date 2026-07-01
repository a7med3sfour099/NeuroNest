import 'package:flutter/material.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:neuronest/features/auth/providers/profile_provider.dart';
import 'package:neuronest/features/auth/views/edit_profile_view.dart';
import 'dart:io';

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize profile provider on first load
    Future.microtask(() {
      context.read<ProfileProvider>().initializeProfile();
    });
  }

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
                    colors: [Color(0xFFD0E5FF), Color(0xFFF4F7FE)],
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
                      child: Consumer<ProfileProvider>(
                        builder: (context, profileProvider, _) {
                          final user = profileProvider.user;

                          return Column(
                            children: [
                              // Profile Card
                              Container(
                                width:
                                    MediaQuery.of(context).size.width.isFinite
                                    ? 300
                                    : double.infinity,
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
                                      // width: 250,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        shape: BoxShape.circle,
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          radius: 46,
                                          backgroundColor:
                                              Colors.purple.shade100,
                                          backgroundImage:
                                              user?.image != null &&
                                                  user!.image!.isNotEmpty
                                              ? FileImage(File(user.image!))
                                              : null,
                                          child:
                                              user?.image == null ||
                                                  user?.image?.isEmpty == true
                                              ? Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      user?.name ?? "User Profile",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user?.email ?? "user@example.com",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (user?.address != null &&
                                        user!.address!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8.0,
                                        ),
                                        child: Text(
                                          user.address!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black45,
                                            fontSize: 13,
                                          ),
                                        ),
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
                                  _buildSettingItem(
                                    Icons.track_changes,
                                    "Progress\nTracking",
                                    color: const Color(0xFF2196F3),
                                    onTap: () {
                                      // Navigator.pushNamed(context, '/progressTracking');
                                    },
                                  ),
                                  // _buildSettingItem(
                                  //   Icons.notifications,
                                  //   "Notifications",
                                  //   color: const Color(0xFFFF9800),
                                  //   onTap: (){
                                  //     // Navigator.pushNamed(context, '/notifications');
                                  //   },
                                  // ),
                                  _buildSettingItem(
                                    Icons.settings,
                                    "App\nSettings",
                                    color: const Color(0xFF9C27B0),
                                    onTap: () {
                                      // Navigator.pushNamed(context, '/appSettings');
                                    },
                                  ),
                                  _buildSettingItem(
                                    Icons.help,
                                    "Help &\nSupport",
                                    color: const Color(0xFF4CAF50),
                                    onTap: () {
                                      // Navigator.pushNamed(context, '/helpSupport');
                                    },
                                  ),
                                  _buildSettingItem(
                                    Icons.logout,
                                    "Log Out",
                                    color: Colors.red,
                                    onTap: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text("Logout"),
                                          content: const Text(
                                            "Are you sure you want to logout?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                "Logout",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm != true || !context.mounted)
                                        return;

                                      await context
                                          .read<AuthProvider>()
                                          .logout();

                                      if (!context.mounted) return;

                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/login',
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
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
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProfileView(),
                            ),
                          );

                          if (result == true && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
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
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
