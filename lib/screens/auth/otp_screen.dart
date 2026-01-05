// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brahmin_matrimony/utils/constants.dart';
import 'package:brahmin_matrimony/widgets/custom_button.dart';

class OTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  
  const OTPScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  String? _verificationId;

  @override
  void initState() {
    super.initState();
    _sendOTP();
    
    // Set up focus node listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus && i < _focusNodes.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    
    // TODO: Implement OTP sending logic
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    _focusNodes[0].requestFocus();
  }

  Future<void> _verifyOTP() async {
    final otp = _controllers.map((c) => c.text).join();
    
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter 6-digit OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // TODO: Implement OTP verification
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    // Navigate to create profile or home
    // Navigator.pushReplacementNamed(context, '/create-profile');
  }

  void _handlePaste(String text) {
    if (text.length == 6) {
      for (int i = 0; i < 6; i++) {
        _controllers[i].text = text[i];
      }
      _verifyOTP();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Verify Phone Number'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Header
              Text(
                'Enter OTP',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textColor,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'We sent a 6-digit code to ${widget.phoneNumber}',
                style: const TextStyle(
                  color: AppConstants.lightTextColor,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // OTP Input Fields
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (RawKeyEvent event) {
                  // Handle paste
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                            borderSide: const BorderSide(
                              color: AppConstants.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _focusNodes[index - 1].requestFocus();
                          }
                          
                          // Auto submit when all fields are filled
                          if (index == 5 && value.isNotEmpty) {
                            final otp = _controllers.map((c) => c.text).join();
                            if (otp.length == 6) {
                              _verifyOTP();
                            }
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              
              const SizedBox(height: 32),
              
              CustomButton(
                text: 'Verify OTP',
                isLoading: _isLoading,
                onPressed: _verifyOTP,
              ),
              
              const SizedBox(height: 24),
              
              // Resend OTP
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  child: const Text(
                    'Resend OTP',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Edit Phone Number
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Edit phone number',
                    style: TextStyle(
                      color: AppConstants.lightTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}