import 'package:flutter/material.dart';
import 'package:pretium_finance/theme/app_colors.dart';
import 'login_page.dart'; 

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isAnimating = false;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Direct Pay',
      'description': 'Pay with crypto across Africa effortlessly',
      'icon': Icons.payment,
    },
    {
      'title': 'Accept Payments',
      'description': 'Accept stablecoin payments hassle-free',
      'icon': Icons.payments_sharp,
    },
    {
      'title': 'Pay Bills',
      'description': 'Pay for utility services and earn rewards',
      'icon': Icons.receipt_long_outlined,
    },
  ];

  Future<void> _navigateToNextPage() async {
    if (_currentIndex < _slides.length - 1 && !_isAnimating) {
      setState(() => _isAnimating = true);
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _isAnimating = false);
    } else {
      // Navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

void _skipToLastPage() {
  if (!_isAnimating) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }
}

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemBuilder: (_, index) => _LandingSlide(
                      title: _slides[index]['title'],
                      description: _slides[index]['description'],
                      icon: _slides[index]['icon'],
                      horizontalPadding: width * 0.1,
                    ),
                  ),
                ),
                _PageIndicator(
                  currentIndex: _currentIndex,
                  pageCount: _slides.length,
                  activeColor: AppColors.primaryGreen,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _navigateToNextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentIndex == _slides.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_currentIndex != _slides.length - 1)
              const Positioned(
                top: 16,
                right: 16,
                child: _SkipButton(),
              ),
          ],
        ),
      ),
    );
  }
}

class _LandingSlide extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final double horizontalPadding;

  const _LandingSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  final Color activeColor;

  const _PageIndicator({
    required this.currentIndex,
    required this.pageCount,
    this.activeColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          pageCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 8,
            width: currentIndex == index ? 24 : 8,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? activeColor
                  : Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final state = context.findAncestorStateOfType<_LandingPageState>();
        state?._skipToLastPage();
      },
      child: const Text(
        'Skip',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
        ),
      ),
    );
  }
}
