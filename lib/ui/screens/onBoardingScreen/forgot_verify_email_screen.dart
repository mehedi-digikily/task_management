import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/network_response.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';

import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import 'forgot_pin_verification_screen.dart';

class ForgotPasswordVerifyEmailScreen extends StatefulWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  State<ForgotPasswordVerifyEmailScreen> createState() =>
      _ForgotPasswordVerifyEmailScreenState();
}

class _ForgotPasswordVerifyEmailScreenState
    extends State<ForgotPasswordVerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool inProgress = false;

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
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin will be sent to your email.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailTEController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: inProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: nextScreen,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
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
                        const TextSpan(text: "Have account? "),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void nextScreen(){
    if(_formKey.currentState!.validate()){
      emailVerify(_emailTEController.text.trim());
    }
  }

  Future<void> emailVerify(String email) async {
    setState(() {
      inProgress = true;
    });
    NetworkResponse response = await NetworkClient.getRequest(url: Urls.recoverVerifyEmailUrl(email),);
    if (response.isSuccess) {
      if(mounted){
        showSnackBarMessage(context, 'Verification code sent to your email');
        _onTapSubmitButton(email);
        _emailTEController.clear();
      }
    } else {
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }
    }
    setState(() {
      inProgress = false;
    });
  }

  void _onTapSubmitButton(String email) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordPinVerificationScreen(email: email,),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
