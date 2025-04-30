import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_managemnt/data/service/network_client.dart';
import 'package:task_managemnt/data/utils/urls.dart';
import 'package:task_managemnt/ui/screens/main_screens/main_bottom_nav_screen';
import 'package:task_managemnt/ui/widgets/centered_circular_progressIndicator.dart';
import 'package:task_managemnt/ui/widgets/snack_bar_message.dart';
import 'package:task_managemnt/ui/widgets/tm_app_bar.dart';

import '../../../data/model/network_response.dart';
import '../../controlar/auth_controlar.dart';
import '../../widgets/screen_background.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool inProgress = false;
  XFile? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = AuthController.userModel!;
    _emailTEController.text = user.email;
    _firstNameTEController.text = user.firstName;
    _lastNameTEController.text = user.lastName;
    _mobileTEController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(
        fromProfileScreen: true,
      ),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey, // Moved here
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPickerWidget(),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    enabled: false,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'First name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: const InputDecoration(
                      hintText: 'Last name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
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
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      ),
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: inProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton, // Call method
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: pickedImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              alignment: Alignment.center,
              child: const Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _pickedImage?.name ?? 'Select your photo',
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSubmitButton() async {
    if (_formKey.currentState!.validate()) {
      await _updateProfile();
      // Handle profile update logic
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      inProgress = true;
    });
    Map<String,dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "photo": AuthController.userModel?.photo ?? "",
    };
    if (_passwordTEController.text.isNotEmpty) {
      requestBody["password"] = _passwordTEController.text;
    }
    if (_pickedImage != null) {
      List<int> image = await _pickedImage!.readAsBytes();
      String? base64EncodeImage = base64UrlEncode(image);
      requestBody['photo'] = base64EncodeImage;
    }

    NetworkResponse response = await NetworkClient.postRequest(
        url: Urls.profileUpdateUrl, body: requestBody);
    setState(() {
      inProgress= false;
    });
    if (response.isSuccess) {
      // ✅ নতুন ইউজার ডেটা তৈরি করো
      AuthController.userModel?.firstName = _firstNameTEController.text.trim();
      AuthController.userModel?.lastName = _lastNameTEController.text.trim();
      AuthController.userModel?.mobile = _mobileTEController.text.trim();
      if (_pickedImage != null) {
        List<int> image = await _pickedImage!.readAsBytes();
        AuthController.userModel?.photo = base64UrlEncode(image);
      }
      // ✅ নতুন ইউজার ডেটা আবার সেভ করো
      await AuthController.saveUserInformation(
        AuthController.token!, // আগের token
        AuthController.userModel!,
      );

      if (mounted) {
        showSnackBarMessage(context, 'information update successful');
        _tapToMainScreen();
      }
    }else {
      if(mounted){
      showSnackBarMessage(context, '${response.errorMessage}',true);
      }
    }

  }

  Future<void> pickedImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  void _tapToMainScreen() {
    _clearTextFields();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavScreen(),
        ),
        (c) => false);
  }

  _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
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
