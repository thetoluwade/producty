import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_checkbox.dart';
import '../../widgets/custom_bottom_sheet.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;
  bool _isLoading = false;

  final List<Map<String, String>> _introSlides = [
    {
      'title': 'Welcome to Producty',
      'description': 'Your Personal Task Manager and Productivity Companion',
      'image': 'assets/images/intro1.svg',
    },
    {
      'title': 'Plan Smarter, Work Better',
      'description': 'Make Goals Happen with One Powerful App',
      'image': 'assets/images/intro2.svg',
    },
    {
      'title': 'From Chaos to Clarity',
      'description': 'Streamline and Focus on What Matters Most',
      'image': 'assets/images/intro3.svg',
    },
    {
      'title': 'Boost Your Productivity',
      'description': 'Simplify Your Day',
      'image': 'assets/images/intro4.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
  }

  Widget _buildIntroSlide(Map<String, String> slide) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: screenHeight * 0.05),
        SvgPicture.asset(
          slide['image']!,
          height: screenHeight * 0.35,
          fit: BoxFit.contain,
        ),
        SizedBox(height: screenHeight * 0.01),
        Text(
          slide['title']!,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: screenHeight * 0.005),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            slide['description']!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emailController,
          labelText: 'Enter your email',
          prefixIcon: Iconsax.sms,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        Center(
          child: CustomCheckbox(
            value: _rememberMe,
            onChanged: (value) => setState(() => _rememberMe = value),
            label: 'Remember me',
          ),
        ),
        const SizedBox(height: 16),
        CustomButton(
          text: 'Login/Signup',
          onPressed: () async {
            setState(() => _isLoading = true);
            await _completeOnboarding();
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            setState(() => _isLoading = false);
          },
          isLoading: _isLoading,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton(
              onTap: () {
                // TODO: Implement Google sign in
              },
              icon: Iconsax.google_1,
            ),
            const SizedBox(width: 16),
            _socialButton(
              onTap: () {
                // TODO: Implement Facebook sign in
              },
              icon: Iconsax.facebook,
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton({
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _introSlides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: _currentPage == index ? 32 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _introSlides.length,
                        itemBuilder: (context, index) => _buildIntroSlide(_introSlides[index]),
                      ),
                    ),
                    // Support Icon Button
                    Positioned(
                      top: 10,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/support');
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Iconsax.headphone,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildDots(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.02),
                      offset: const Offset(0, 0),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomBottomSheet(
                  showHandle: false,
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  child: _buildAuthForm(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
