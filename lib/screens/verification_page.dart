import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController codeController = TextEditingController();
  String selectedCountry = 'Kenya';

  final List<String> countries = [
    'Kenya',
    'Uganda',
    'Nigeria',
    'Ghana',
    'Malawi',
    'Zambia',
    'Rwanda',
    'Global Users [全球用户]'
  ];

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.primaryGreen),
      prefixIcon: Icon(icon, color: AppColors.greyText),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  void _verifyCode() {
    if (_formKey.currentState?.validate() ?? false) {
      final code = codeController.text.trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Code "$code" submitted for $selectedCountry')),
      );
    }
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verification code resent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Enter the verification code sent to your email',
                style: TextStyle(color: AppColors.greyText),
              ),
              const SizedBox(height: 32),

              // Country Dropdown
              DropdownButtonFormField<String>(
                value: selectedCountry,
                decoration: _inputDecoration('Country', Icons.location_on),
                items: countries.map((String country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCountry = newValue!;
                  });
                },
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.darkText,
                ),
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: Colors.white,
              ),
              const SizedBox(height: 16),

              // Verification Code Input
              TextFormField(
                controller: codeController,
                cursorColor: AppColors.primaryGreen,
                decoration: _inputDecoration('Verification Code', Icons.lock_outline),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Code is required';
                  } else if (!RegExp(r'^\d{4}$').hasMatch(value.trim())) {
                    return 'Enter a valid 4-digit code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _verifyCode,
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Resend Code Section
              Center(
                child: Column(
                  children: [
                    const Text(
                      "Didn't receive the code?",
                      style: TextStyle(fontSize: 14, color: AppColors.greyText),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        'Resend Code',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
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
}