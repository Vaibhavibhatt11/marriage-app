import 'package:flutter/material.dart';
import 'package:brahmin_marriage/auth_service.dart';
import 'otp_screen.dart';
import 'package:brahmin_marriage/Services/database_service.dart';
import 'package:brahmin_marriage/Services/screens/profile/create_profile_screen.dart';
import 'package:brahmin_marriage/Services/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  bool useEmail = false;

  void sendOtp() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty || phone.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10 digit phone number")),
      );
      return;
    }

    // capture navigator and messenger to avoid using BuildContext after async gaps
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      isLoading = true;
    });

    try {
      await authService.signInWithPhone(
        "+91$phone",
        (verificationId) {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });

          navigator.push(MaterialPageRoute(
              builder: (ctx) => OTPScreen(verificationId: verificationId)));
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> signInEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter email and password')));
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authService.signInWithEmail(email, password);
      if (user == null) throw Exception('Login failed');
      // check verification
      if (!user.emailVerified) {
        messenger.showSnackBar(SnackBar(
          content: const Text('Your email is not verified.'),
          action: SnackBarAction(
            label: 'Resend',
            onPressed: () async {
              try {
                await authService.resendEmailVerification(user);
                messenger.showSnackBar(
                    const SnackBar(content: Text('Verification email sent')));
              } catch (_) {
                messenger.showSnackBar(const SnackBar(
                    content: Text('Failed to resend verification')));
              }
            },
          ),
        ));
        return;
      }
      final profile = await DatabaseService().getProfileByUid(user.uid);
      if (!mounted) return;
      if (profile == null) {
        navigator.pushReplacement(
            MaterialPageRoute(builder: (ctx) => const CreateProfileScreen()));
      } else {
        navigator.pushReplacement(
            MaterialPageRoute(builder: (ctx) => const HomeScreen()));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> registerEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter valid email and password (min 6 chars)')));
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final user = await authService.registerWithEmail(email, password);
      if (user == null) throw Exception('Registration failed');
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const CreateProfileScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text('Phone'),
                  selected: !useEmail,
                  onSelected: (v) => setState(() => useEmail = !v),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text('Email'),
                  selected: useEmail,
                  onSelected: (v) => setState(() => useEmail = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!useEmail) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  prefixText: "+91 ",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendOtp,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Send OTP"),
                ),
              ),
            ] else ...[
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final email = emailController.text.trim();
                    if (email.isEmpty) {
                      messenger.showSnackBar(const SnackBar(
                          content: Text('Enter email to reset password')));
                      return;
                    }
                    try {
                      await authService.sendPasswordReset(email);
                      if (!mounted) return;
                      // ignore: use_build_context_synchronously
                      await showDialog<void>(
                        context: context,
                        builder: (dCtx) => AlertDialog(
                          title: const Text('Password reset'),
                          content: Text(
                              'A password reset link has been sent to $email.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(dCtx).pop(),
                                child: const Text('OK')),
                          ],
                        ),
                      );
                    } catch (e) {
                      messenger
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : signInEmail,
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isLoading ? null : registerEmail,
                      child: const Text('Register'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
