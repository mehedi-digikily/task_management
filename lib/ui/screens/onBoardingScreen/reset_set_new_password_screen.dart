import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import 'login_screen.dart';

class ResetSetNewPasswordScreen extends StatefulWidget {
  const ResetSetNewPasswordScreen(
      {super.key, required this.email, required this.otp});

  final String email, otp;

  @override
  State<ResetSetNewPasswordScreen> createState() =>
      _ResetSetNewPasswordScreenState();
}

class _ResetSetNewPasswordScreenState extends State<ResetSetNewPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmNewPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isVisible = true;
  bool isVisible2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Set Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Set a new password with a minimum length of 6 characters.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _newPasswordTEController,
                  obscureText: isVisible,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                          isVisible ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintText: 'New Password',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmNewPasswordTEController,
                  obscureText: isVisible2,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible2 = !isVisible2;
                        });
                      },
                      icon: Icon(
                          isVisible2 ? Icons.visibility_off : Icons.visibility),
                    ),
                    hintText: 'Confirm New Password',
                  ),
                  validator: (value) {
                    if (value != _newPasswordTEController.text) {
                      return 'Passwords do not match.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmitButton,
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      children: [
                        const TextSpan(text: "Have an account? "),
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _onTapSignInButton,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      onTapChange();
    }
  }

  Future<void> onTapChange() async {
    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.recoverResetPasswordUrl,
        body: {
          "email":widget.email,
          "OTP": widget.otp,
          "password":_newPasswordTEController.text.trim()
        }

    );
    if (response.isSuccess) {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
            (predicate) => false);
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }
    }
  }

  void onTapChangePassword() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (pre) => false,
    );
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (pre) => false,
    );
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmNewPasswordTEController.dispose();
    super.dispose();
  }
}
