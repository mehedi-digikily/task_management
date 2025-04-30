import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_managemnt/ui/screens/onBoardingScreen/registration_screen.dart';

import '../../../data/model/login_model.dart';
import '../../../data/model/network_response.dart';
import '../../../data/service/network_client.dart';
import '../../../data/utils/urls.dart';
import '../../controlar/auth_controlar.dart';
import '../../widgets/centered_circular_progressIndicator.dart';
import '../../widgets/screen_background.dart';
import '../../widgets/snack_bar_message.dart';
import '../main_screens/main_bottom_nav_screen';
import 'forgot_verify_email_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loginInProgress = false;

  // TODO: Validate form(Email & password)
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
                  'Get Started With',
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
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordTEController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: _loginInProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child: ElevatedButton(
                    onPressed: _onTapSignInButton,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPasswordButton,
                        child: const Text('Forgot Password?'),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Don't have account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignUpButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    _loginInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.loginUrl,
      body: requestBody,
    );
    _loginInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.data!);
      AuthController.saveUserInformation(loginModel.token, loginModel.userModel);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MainBottomNavScreen(),
        ),
            (predicate) => false,
      );
    } else {
      if(mounted){
        showSnackBarMessage(context, '${response.errorMessage}', true);
      }    }
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordVerifyEmailScreen(),
      ),
    );
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}





// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:task_managemnt/data/model/login_model.dart';
// import 'package:task_managemnt/ui/controller/controller.dart';
// import 'package:task_managemnt/ui/screens/main_screens/main_bottom_nav_screen';
// import 'package:task_managemnt/ui/screens/onBoardingScreen/registration_screen.dart';
// import '../../../data/model/network_response.dart';
// import '../../../data/service/network_client.dart';
// import '../../../data/utils/urls.dart';
// import '../../widgets/screen_background.dart';
// import '../../widgets/snack_bar_message.dart';
// import 'forgot_verify_email_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _emailTEController = TextEditingController();
//   final TextEditingController _passwordTEController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   bool isSecure = true;
//   bool inProgress = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: ScreenBackground(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 80),
//                 Text(
//                   'Get Started With',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 24),
//                 TextFormField(
//                   textInputAction: TextInputAction.next,
//                   keyboardType: TextInputType.emailAddress,
//                   controller: _emailTEController,
//                   decoration: const InputDecoration(
//                     hintText: 'Email',
//                   ),
//                   validator: (String? value) {
//                     if (value?.trim().isEmpty ?? true) {
//                       return 'Enter your email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 TextFormField(
//                   obscureText: isSecure,
//                   controller: _passwordTEController,
//                   decoration: InputDecoration(
//                       hintText: 'Password',
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             isSecure = !isSecure;
//                           });
//                         },
//                         icon: isSecure
//                             ? Icon(Icons.visibility_off)
//                             : Icon(Icons.visibility),
//                       )),
//                   validator: (String? value) {
//                     if (value?.trim().isEmpty ?? true) {
//                       return 'Enter your password';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 Visibility(
//                   replacement: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                   visible: !inProgress,
//                   child: ElevatedButton(
//                     onPressed: () => _onTapLogin(),
//                     child: const Icon(Icons.arrow_circle_right_outlined),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 Center(
//                   child: Column(
//                     children: [
//                       TextButton(
//                         onPressed: _onTapForgotPasswordButton,
//                         child: const Text(
//                           'Forgot Password?',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ),
//                       RichText(
//                         text: TextSpan(
//                           style: const TextStyle(
//                             color: Colors.black54,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 14,
//                           ),
//                           children: [
//                             const TextSpan(text: "Don't have account? "),
//                             TextSpan(
//                               text: 'Sign Up',
//                               style: const TextStyle(
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               recognizer: TapGestureRecognizer()
//                                 ..onTap = _onTapSignUpButton,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _onTapForgotPasswordButton() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const ForgotPasswordVerifyEmailScreen(),
//       ),
//     );
//   }
//
//   void _onTapLogin() {
//     if (_formKey.currentState!.validate()) {
//       _loginData();
//     }
//   }
//
//   Future<void> _loginData() async {
//     setState(() {
//       inProgress = true;
//     });
//
//     Map<String,dynamic> loginBody = {
//       "email": _emailTEController.text.trim(),
//       "password": _passwordTEController.text,
//     };
//
//     final NetworkResponse response = await NetworkClient.postRequest(url: Urls.loginUls, body: loginBody);
//     setState(() {
//       inProgress = false;
//     });
//
//     if (response.isSuccess) {
//       LoginModel loginModel = LoginModel.fromJson(response.data!);
//       AuthController.saveUserInformation(loginModel.token, loginModel.userModel);
//
//       if(mounted) {
//         showSnackBarMessage(
//           context,
//           'LogIn Success',
//         );
//         Navigator.pushAndRemoveUntil(context,
//           MaterialPageRoute(builder: (context) => MainBottomNavScreen(),), (
//               route) => false,
//         );
//       }
//     } else {
//       if (mounted) {
//         showSnackBarMessage(context, 'LogIn Fail! please try again', true);
//       }
//     }
//   }
//
//   void _onTapSignUpButton() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const RegisterScreen(),
//       ),
//     );
//   }
//
//
//   @override
//   void dispose() {
//     _emailTEController.dispose();
//     _passwordTEController.dispose();
//     super.dispose();
//   }
// }
