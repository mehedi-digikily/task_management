import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_model.dart';

class AuthController{
  String? token;
  UserModel? userModel;

  static final String _userTokenKey = 'token';
  static final String _userDataModelKey = 'user-data';

  Future<void> saveUserData(String userGiveToken, UserModel newUserModel)async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userTokenKey, userGiveToken);
    await sharedPreferences.setString(_userDataModelKey, jsonEncode(newUserModel.toJson(),),);
    token = userGiveToken;
    userModel = newUserModel;
  }

  Future<void> getUserData()async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? accessToken = sharedPreferences.getString(_userTokenKey);
    final String? userDataModelKey = sharedPreferences.getString(_userDataModelKey);

    if(userDataModelKey != null){
      UserModel savedUserModel  = UserModel.fromJson(jsonDecode(userDataModelKey));
      userModel = savedUserModel;
    }
    token = accessToken;
  }

  Future<bool> userLoggTen()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_userTokenKey);
    if(userAccessToken != null){
      return true;
    }
    return false;
  }

  Future<void> clearUserData()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
    userModel = null;
  }

}