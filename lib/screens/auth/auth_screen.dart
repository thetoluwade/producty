import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  late final PageController _pageController = PageController();
  String? _emailError;
  bool _rememberMe = false;
  bool _isLoading = false;
  int _currentPage = 0;
  bool _isKeyboardVisible = false;
  final FocusNode _emailFocusNode = FocusNode();
  late AnimationController _animationController;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.black87,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  final List<Map<String, String>> _introSlides = [
    {
      'title': 'Stay Organized, Achieve More',
      'description': 'Unlock Your Full Potential with Ease',
      'image': 'assets/images/intro1.svg',
    },
    {
      'title': 'Smart Task Management',
      'description': 'Prioritize and Track Your Progress',
      'image': 'assets/images/intro2.svg',
    },
    {
      'title': 'Seamless Collaboration',
      'description': 'Work Together, Achieve Together',
      'image': 'assets/images/intro3.svg',
    },
    {
      'title': 'Stay Connected Anywhere',
      'description': 'Access Your Tasks On Any Device',
      'image': 'assets/images/intro4.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(_onFocusChange);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _startAutoPlay();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pageController.dispose();
    _emailFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.dispose();
    _animationController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isKeyboardVisible = _emailFocusNode.hasFocus;
    });
    if (_emailFocusNode.hasFocus) {
      _resetAutoPlayTimer();
    }
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isUserInteracting && mounted) {
        final nextPage = (_currentPage + 1) % _introSlides.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetAutoPlayTimer() {
    _autoPlayTimer?.cancel();
    _startAutoPlay();
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
      _emailError = null;
    });

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email address';
        _isLoading = false;
      });
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email address';
        _isLoading = false;
      });
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      if (mounted) {
        // TODO: Navigate to OTP verification screen
        // For now, just marking as onboarded and going to home
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _emailError = 'An error occurred. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  void _handleNeedHelp() {
    // Haptics.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.05),
                offset: const Offset(0, 0),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need Help?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Iconsax.message_question),
                      title: const Text('Contact Support'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/support');
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Iconsax.info_circle),
                      title: const Text('FAQ'),
                      onTap: () {
                        Navigator.pop(context);
                        _showToast('FAQ section coming soon', isError: false);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthForm() {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Email address',
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : const Color(0xFF3D3D3D),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          placeholder: 'Enter your email',
          error: _emailError,
          keyboardType: TextInputType.emailAddress,
          icon: Iconsax.sms,
          onChanged: (value) {
            if (_emailError != null) {
              setState(() => _emailError = null);
            }
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomCheckbox(
            //   value: _rememberMe,
            //   onChanged: (value) => setState(() => _rememberMe = value),
            // ),
            // const SizedBox(width: 8),
            // Text(
            //   'Remember me',
            //   style: GoogleFonts.dmSans(
            //     fontSize: 14,
            //     color: const Color(0xFF8E8E93),
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 24),
        CustomButton(
          text: 'Login/Signup',
          onPressed: _handleContinue,
          isLoading: _isLoading,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
                child: Divider(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF3D3D3D)
                        : const Color(0xFFE5E5EA))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'or continue with',
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: const Color(0xFF8E8E93),
                ),
              ),
            ),
            Expanded(
                child: Divider(
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF3D3D3D)
                        : const Color(0xFFE5E5EA))),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 115,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF28282A)
                    : Colors.white,
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF3D3D3D)
                      : const Color(0xFFE5E5EA),
                ),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.google,
                  size: 24,
                  color: Color(0xFF3D3D3D),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 115,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF28282A)
                    : Colors.white,
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF3D3D3D)
                      : const Color(0xFFE5E5EA),
                ),
              ),
              child: const Center(
                child: Icon(
                  Iconsax.facebook,
                  size: 24,
                  color: Color(0xFF1877F2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _introSlides.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF3D3D3D)
                : Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF3D3D3D)
                    : const Color(0xFFE5E5EA),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  void _onPageChanged(int index) {
    // Haptics.softImpact();
    setState(() {
      _currentPage = index;
      _isUserInteracting = true;
    });
    _resetAutoPlayTimer();
  }

  void _handleDragStart() {
    setState(() {
      _isUserInteracting = true;
    });
  }

  void _handleDragEnd() {
    setState(() {
      _isUserInteracting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF1C1C1E)
          : const Color(0xFFF1F1F1),
      appBar: AppBar(
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF1C1C1E)
            : const Color(0xFFF1F1F1),
        elevation: 0,
        leadingWidth: 123,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SvgPicture.asset(
            theme.brightness == Brightness.dark
                ? 'assets/images/darkLogo.svg'
                : 'assets/images/lightLogo.svg',
            width: 103,
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF28282A)
                    : const Color(0xFFFFFFFF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  Iconsax.message_question,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
                onPressed: _handleNeedHelp,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          if (MediaQuery.of(context).viewInsets.bottom > 0) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: size.height * 0.5,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: _onPageChanged,
                            itemCount: _introSlides.length,
                            itemBuilder: (context, index) {
                              final slide = _introSlides[index];
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      slide['image']!,
                                      height: size.height * 0.25,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      slide['title']!,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: theme.brightness == Brightness.dark
                                            ? const Color(0xFFFFFFFF)
                                            : const Color(0xFF3D3D3D),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(
                                        slide['description']!,
                                        style: GoogleFonts.dmSans(
                                          fontSize: 16,
                                          color:
                                              theme.brightness == Brightness.dark
                                                  ? const Color(0xFF7B7B80)
                                                  : const Color(0xFF616161),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: _buildDots(),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(
                20,
                0,
                20,
                MediaQuery.of(context).viewInsets.bottom > 0 ? 110 : 20,
              ),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF28282A)
                    : Colors.white,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF3D3D3D)
                          : const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                        child: _buildAuthForm(),
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
}
