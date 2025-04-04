import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managemnt/data/model/NetworkResponse.dart';
import 'package:task_managemnt/data/service/network_client.dart';

import '../../../data/utils/urls.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/snack_bar_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVisible = true;
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: isVisible,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isVisible = !isVisible;
                          });
                        },
                        icon: isVisible
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      hintText: 'Password',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: !inProgress,
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
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
                          const TextSpan(
                            text: "Already have an account? ",
                          ),
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
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registration();
    }
  }

  Future<void> _registration() async {

    setState(() {
      inProgress = true;
    });

    Map<String, dynamic>? body = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
      "photo": "",
    };

    print("Registration Body: $body"); //

    NetworkResponse response = await NetWorkClint.postRequest(url: Urls.registrationUls, body: body,);

    setState(() {
      inProgress = false;
    });

    if (response.isSuccess) {
      snackMessage(context, 'Registration Success',);
    } else {
      snackMessage(context, 'Registration Fail',true);

    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
