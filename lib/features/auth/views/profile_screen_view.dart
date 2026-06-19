import 'package:neuronest/features/auth/providers/profile_provider.dart';
import 'package:neuronest/features/auth/views/edit_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  State<ProfileScreenView> createState() => _ProfileScreenViewState();
}

class _ProfileScreenViewState extends State<ProfileScreenView> {
  @override
  void initState() {
    super.initState();
    // Initialize profile provider on first load
    Future.microtask(() {
      context.read<ProfileProvider>().initializeProfile();
    });
  }

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
      appBar: AppBar(
        title: const Text('My Profile'),
        elevation: 0,
        backgroundColor: const Color(0xFFD0E5FF),
        foregroundColor: Colors.black87,
      ),
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
                  _buildProfileCard(context),
                  const SizedBox(height: 24),
                  _buildEditProfileButton(context),
                  const SizedBox(height: 32),
                  _buildProfileDetailsSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final user = profileProvider.user;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple.shade100,
                backgroundImage: user?.image != null && user!.image!.isNotEmpty
                    ? FileImage(File(user.image!))
                    : null,
                child: user?.image == null || user?.image?.isEmpty == true
                    ? Icon(Icons.person, size: 60, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Guest User',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user?.email ?? 'email@example.com',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              if (user?.address != null && user!.address!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    user.address!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileView()),
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
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetailsSection() {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final user = profileProvider.user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard(
              icon: Icons.person,
              label: 'Name',
              value: user?.name ?? 'Not set',
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              icon: Icons.email,
              label: 'Email',
              value: user?.email ?? 'Not set',
            ),
            const SizedBox(height: 12),
            _buildDetailCard(
              icon: Icons.location_on,
              label: 'Address',
              value: user?.address ?? 'Not set',
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
