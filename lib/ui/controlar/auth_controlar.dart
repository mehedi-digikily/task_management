import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/user_model.dart';

class AuthController {
  static String? token;
  static UserModel? userModel;

  static const String _tokenKey = 'token';
  static const String _userDataKey = 'user-data';

  // Save user information
  static Future<void> saveUserInformation(String accessToken, UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, accessToken);
    sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));

    token = accessToken;
    userModel = user;
  }

  // Get user information
  static Future<void> getUserInformation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString(_tokenKey);
    String? savedUserModelString = sharedPreferences.getString(_userDataKey);
    if (savedUserModelString != null) {
      UserModel savedUserModel = UserModel.fromJson(jsonDecode(savedUserModelString));
      userModel = savedUserModel;
    }

    token = accessToken;
  }

  // Check if user already logged in
  static Future<bool> checkIfUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_tokenKey);
    if (userAccessToken != null) {
      await getUserInformation();
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
    userModel = null;
  }
}




// class AuthController{
//   static String? token;
//   static UserModel? userModel;
//
//   static final String _userTokenKey = 'token';
//   static final String _userDataModelKey = 'user-data';
//
//   static Future<void> saveUserData(String userGiveToken, UserModel giveUserDataModel)async{
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences.setString(_userTokenKey, userGiveToken);
//     await sharedPreferences.setString(_userDataModelKey, jsonEncode(giveUserDataModel.toJson(),),);
//     token = userGiveToken;
//     userModel = giveUserDataModel;
//   }
//
//   static Future<void> getUserData()async {
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     final String? accessToken = sharedPreferences.getString(_userTokenKey);
//     final String? userDataModelKey = sharedPreferences.getString(_userDataModelKey);
//
//     if(userDataModelKey != null){
//       UserModel savedUserModel  = UserModel.fromJson(jsonDecode(userDataModelKey));
//       userModel = savedUserModel;
//     }
//     token = accessToken;
//   }
//
//   static Future<bool> checkIfUserLoggedIn()async{
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? userAccessToken = sharedPreferences.getString(_userTokenKey);
//     if(userAccessToken != null){
//       await getUserData();
//       return true;
//     }
//     return false;
//   }
//
//   static Future<void> clearUserData()async{
//     final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     await sharedPreferences.clear();
//     token = null;
//     userModel = null;
//   }
//
// }