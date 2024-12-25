import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isError = false}) {
    if (isError) {
      Haptics.error();
    }
    CustomToast.show(context, message, isError: isError);
  }

  void _showIssueTypePicker() {
    Haptics.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: CustomBottomSheet(
          title: 'Select Issue Type',
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _issueTypes.length,
            itemBuilder: (context, index) {
              final issueType = _issueTypes[index];
              final theme = Theme.of(context);
              final isSelected = issueType == _selectedIssue;
              
              return ListTile(
                title: Text(
                  issueType,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w500 : null,
                  ),
                ),
                leading: Icon(
                  isSelected ? Iconsax.tick_circle : Iconsax.box,
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
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
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      _showToast('Please fill in all fields', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _showToast('Support ticket submitted successfully');
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
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Support',
          style: theme.textTheme.headlineMedium,
        ),
        leading: IconButton(
          icon: Icon(
            Iconsax.arrow_left,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How can we help?',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Choose a category below or search for your issue',
              style: theme.textTheme.bodyLarge,
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
            CustomTextField(
              controller: TextEditingController(text: _selectedIssue),
              placeholder: 'Select Type of Inquiry',
              icon: Iconsax.message_question,
              onTap: _showIssueTypePicker,
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
              text: 'Send Message',
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
