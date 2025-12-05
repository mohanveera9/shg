import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../config/routes.dart';
import '../../config/app_config.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  String? _validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != AppConfig.otpLength) {
      return 'Enter a valid ${AppConfig.otpLength}-digit OTP';
    }
    
    return null;
  }

  Future<void> _verifyOTP(String phone) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyOTP(phone, _otpController.text);
      
      if (mounted) {
        if (success) {
          final groupProvider = Provider.of<GroupProvider>(context, listen: false);
          await groupProvider.fetchUserGroups();
          
          if (mounted) {
            if (groupProvider.groups.isEmpty) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.groupSelection,
                (route) => false,
              );
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.home,
                (route) => false,
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authProvider.errorMessage ?? 'Failed to verify OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final phone = ModalRoute.of(context)!.settings.arguments as String;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the 6-digit code sent to\n$phone',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    maxLength: AppConfig.otpLength,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 8,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      hintText: '000000',
                    ),
                    validator: _validateOTP,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            await authProvider.sendOTP(phone);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('OTP resent successfully'),
                                ),
                              );
                            }
                          },
                    child: const Text('Resend OTP'),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () => _verifyOTP(phone),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Verify',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
