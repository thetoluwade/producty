import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/haptics.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/custom_bottom_sheet.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedIssue = 'Technical Support';
  bool _isLoading = false;

  final List<String> _issueTypes = [
    'Account Recovery',
    'Technical Support',
    'Feature Request',
    'Other',
  ];

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isError = false}) {
    CustomToast.show(context, message, isError: isError);
  }

  void _showIssueTypePicker() {
    Haptics.mediumImpact();
    CustomBottomSheet.show(
      context: context,
      title: 'Select Issue Type',
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _issueTypes.length,
        itemBuilder: (context, index) {
          final issueType = _issueTypes[index];
          final theme = Theme.of(context);
          final isSelected = issueType == _selectedIssue;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            title: Text(
              issueType,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.brightness == Brightness.dark
                        ? const Color(0xFFFFFFFF)
                        : const Color(0xFF3D3D3D),
                fontWeight: isSelected ? FontWeight.w500 : null,
              ),
            ),
            leading: Icon(
              isSelected ? Iconsax.tick_circle : Iconsax.box,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.brightness == Brightness.dark
                      ? const Color(0xFFFFFFFF)
                      : const Color(0xFF3D3D3D),
            ),
            onTap: () {
              setState(() {
                _selectedIssue = issueType;
              });
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_selectedIssue == null) {
      _showToast('Please select an issue type', isError: true);
      return;
    }

    if (_nameController.text.isEmpty) {
      _showToast('Please enter your name', isError: true);
      return;
    }

    if (_emailController.text.isEmpty) {
      _showToast('Please enter your email', isError: true);
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      _showToast('Please enter a valid email', isError: true);
      return;
    }

    if (_messageController.text.isEmpty) {
      _showToast('Please enter your message', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _showToast('Message sent successfully');
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      _showToast('Failed to submit support ticket', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF28282A)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: theme.brightness == Brightness.dark
            ? const Color(0xFF28282A)
            : Colors.white,
        title: Text(
          'Support',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF3D3D3D),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: theme.brightness == Brightness.dark
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF3D3D3D),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help?',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF3D3D3D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a category below or search for your issue',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF7B7B80)
                    : const Color(0xFF616161),
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              controller: _nameController,
              placeholder: 'Enter your full name',
              icon: Iconsax.user_edit,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              placeholder: 'Enter your email address',
              icon: Iconsax.sms_edit,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? const Color(0xFF28282A)
                    : const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: InkWell(
                onTap: _showIssueTypePicker,
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Iconsax.box,
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFFFFFFFF)
                          : const Color(0xFF3D3D3D),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    hintText: 'Select Issue Type',
                    hintStyle: GoogleFonts.dmSans(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0xFF7B7B80)
                          : const Color(0xFF616161),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedIssue,
                        style: GoogleFonts.dmSans(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF3D3D3D),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          FontAwesomeIcons.chevronDown,
                          size: 16,
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF3D3D3D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _messageController,
              placeholder: 'Describe your issue in detail...',
              icon: Iconsax.message_edit,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            CustomButton(
              onPressed: _handleSubmit,
              text: _isLoading ? 'Sending...' : 'Submit',
              isLoading: _isLoading,
              color: const Color(0xFF3D3D3D),
              labelColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
