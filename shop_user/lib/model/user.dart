import 'package:flutter/material.dart';


class UserInfo {
  String? userId;
  String? userName;
  String? userImage;
  List<String> wishList;

  UserInfo({
    required this.userId,
    required this.userName,
    required this.userImage,
    List<String>? wishList,  // 수정된 코드
  }) : this.wishList = wishList ?? [];
}

class UserInfoProvider with ChangeNotifier {
  UserInfo _userInfo = UserInfo(userId: null, userName: "로그인 해주세요", userImage: "https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/product/몬스터볼10797" );

  UserInfo get userInfo => _userInfo;

  void setUserId(String? userId) {
    _userInfo.userId = userId;
    notifyListeners();
  }

  void setUserName(String? userName) {
    _userInfo.userName = userName;
    notifyListeners();
  }

  void setUserUrl(String? userUrl) {
    _userInfo.userImage = userUrl;
    notifyListeners();
  }

}
