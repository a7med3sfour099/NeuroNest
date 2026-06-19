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
      'image': 'assets/onboard/onboard_screen.jpg',
      'title': 'Welcome to SpectrumSense',
      'subtitle':
          'Helping parents recognize early behavioral signals with care and intelligence.',
    },
    {
      'image': 'assets/onboard/onboard_screen.jpg',
      'title': 'Early Awareness Starts Here',
      'subtitle':
          'Upload a short video and let SpectrumSense provide early insights into your child\'s behavior.',
    },
    {
      'image': 'assets/onboard/onboard_screen.jpg',
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
    return Scaffold(
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
    );
  }

  Widget _buildPage(Map<String, String> page) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: Image.asset(
            page['image']!,
            width: double.infinity,
            height: 462,
            fit: BoxFit.cover,
          ),
        ),
        Gap(30),
        Container(
          width: 370,
          height: 262,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffD9D9D9), width: 1),
            boxShadow: [
              BoxShadow(
                color: Color(0xffD9D9D9),
                blurRadius: 4,
                blurStyle: BlurStyle.outer,
              ),
            ],
          ),
          child: Padding(
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
                const Spacer(),
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
        ),
        Gap(25),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0xff5DB7DE),
                minimumSize: Size(207, 50),
              ),
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                  // print('Get Started pressed');
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
            Gap(31),

            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                side: BorderSide(color: Color(0xffD9D9D9)),
                minimumSize: Size(115, 50),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
                // print('Skip pressed');
              },
              child: CustomText(
                text: 'Skip',
                size: 23,
                color: Colors.black,
                weight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
