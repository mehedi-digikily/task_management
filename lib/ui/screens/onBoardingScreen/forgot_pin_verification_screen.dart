import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_managemnt/ui/screens/onBoardingScreen/reset_set_new_password_screen.dart';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';

import '../../../data/model/network_response.dart';
import '../../../data/service/network_client.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/snack_bar_message.dart';
import 'login_screen.dart';

class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  const ForgotPasswordPinVerificationScreen({super.key, required this.email,});

  final String email;

  @override
  State<ForgotPasswordPinVerificationScreen> createState() =>
      _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState
    extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pinCodeTEController = TextEditingController();
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
                  'Pin Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit verification pin has been sent to your email.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.length != 6) {
                      return 'Enter valid 6-digit code';
                    }
                    return null;
                  },
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _pinCodeTEController,
                  appContext: context,
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: inProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: onTapNext,
                    child: const Text('Verify'),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapNext(){
    if(_formKey.currentState!.validate()){
      onTapVerify(widget.email, _pinCodeTEController.text.trim());
    }
  }

  Future<void> onTapVerify(String email,String otp) async {
    setState(() {
      inProgress = true;
    });
    NetworkResponse response = await NetworkClient.getRequest(
        url: Urls.recoverVerifyEmailOtpUrl(email,otp));
    if (response.isSuccess) {
      if(mounted){
        showSnackBarMessage(context, 'OTP verification successful');
        _onTapSubmitButton();
      }
    } else {
      if(mounted){
        showSnackBarMessage(context, response.errorMessage ?? 'Request failed', true);      }
    }
    setState(() {
      inProgress = false;
    });
  }

  void _onTapSubmitButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ResetSetNewPasswordScreen(email: widget.email,otp: _pinCodeTEController.text.trim(),)),
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
    _pinCodeTEController.dispose();
    super.dispose();
  }
}
