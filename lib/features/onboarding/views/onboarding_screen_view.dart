import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image': 'assets/onboard/first_onboarding_image.png',
      'title': 'Welcome to NeuroNest',
      'subtitle':
          'Helping parents recognize early behavioral signals with care and intelligence.',
    },
    {
      'image': 'assets/onboard/second_onboarding_image.png',
      'title': 'Early Awareness Starts Here',
      'subtitle':
          'Upload a short video and let SpectrumSense provide early insights into your child\'s behavior.',
    },
    {
      'image': 'assets/onboard/third_onboarding_image.jpg',
      'title': 'Smart, Supportive Results',
      'subtitle':
          'Upload a short video and let SpectrumSense provide early insights into your child\'s behavior.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.asset(
              page['image']!,
              width: double.infinity,
              height: 450,
              fit: BoxFit.cover,
            ),
          ),
          Gap(25),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                CustomText(
                  text: page['title']!,
                  size: 24,
                  color: Color(0xff000000),
                  weight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                Gap(5),
                CustomText(
                  text: page['subtitle']!,
                  size: 21,
                  color: Color(0xff6C6969),
                  weight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  height: 1.7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 19,
                      height: 19,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFFB8F2FF)
                            : Color(0xffD9D9D9),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          Gap(25),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Color(0xff4a7dcd),
              minimumSize: Size(351, 56),
              elevation: 8,
              shadowColor: Colors.blueAccent.withOpacity(0.4),
            ),
            onPressed: () {
              if (_currentPage < _pages.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: CustomText(
              text: _currentPage < _pages.length - 1 ? 'Next' : 'Get started',
              size: 23,
              color: Colors.white,
              weight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ),
          Gap(25),

          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              side: BorderSide(color: Colors.transparent),
              minimumSize: Size(351, 56),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
              // print('Skip pressed');
            },
            child: CustomText(
              text: 'Skip',
              size: 23,
              color: Color(0xffa0aec0),
              weight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
