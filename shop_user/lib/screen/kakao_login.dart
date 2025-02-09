import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart';
import 'package:shop_user/social_login.dart';




class Kakaologin implements SocialLogin {

  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공 ${token.accessToken}');
          return true;
        } catch (error) {
          var key = await KakaoSdk.origin;
          print("$key");
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }

}