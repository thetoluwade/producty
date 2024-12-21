import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_button.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _inquiryType = 'Password Reset';
  final _messageController = TextEditingController();
  bool _isLoading = false;

  final List<String> _inquiryTypes = [
    'Password Reset',
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

  void _showInquiryTypePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Inquiry Type',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      _inquiryTypes.length,
                      (index) => InkWell(
                        onTap: () {
                          setState(() {
                            _inquiryType = _inquiryTypes[index];
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                _inquiryType == _inquiryTypes[index]
                                    ? Iconsax.tick_circle
                                    : Iconsax.box,
                                color: _inquiryType == _inquiryTypes[index]
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _inquiryTypes[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: _inquiryType == _inquiryTypes[index]
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
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
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Support request submitted successfully!'),
          margin: EdgeInsets.all(20),
        ),
      );
      Navigator.pop(context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Contact Support',
          style: textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Iconsax.support,
                size: 64,
                color: Colors.black,
              ),
              const SizedBox(height: 24),
              Text(
                'How can we help you?',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Iconsax.user,
                fillColor: Colors.white,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email Address',
                prefixIcon: Iconsax.sms,
                fillColor: Colors.white,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomDropdownField(
                value: _inquiryType,
                labelText: 'Type of Inquiry',
                prefixIcon: Iconsax.message_question,
                onTap: _showInquiryTypePicker,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _messageController,
                labelText: 'Message',
                prefixIcon: Iconsax.message,
                fillColor: Colors.white,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Send Message',
                onPressed: _submitForm,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
