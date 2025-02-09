import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:shop_user/screen/main_view_model.dart';
import 'package:shop_user/screen/kakao_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shop_user/model/user.dart';
import 'package:provider/provider.dart';

class KakaoLoginPage extends StatefulWidget {
  const KakaoLoginPage({super.key});


  @override
  State<KakaoLoginPage> createState() => _KakaoLoginPageState();
}

class _KakaoLoginPageState extends State<KakaoLoginPage> {
  final viewModel = MainViewModel(Kakaologin());


  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: [
              Expanded(child: Image.network("https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/product/몬스터볼10797" ,height: 50, width: 50,),),
              Expanded(child:Text(
              '${userInfoProvider.userInfo.userName ?? "로그인 해주세요."}',
              style: Theme.of(context).textTheme.headline4,
            ),),],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                  setState((){
                    userInfoProvider.setUserId('${viewModel.user?.id}');
                    userInfoProvider.setUserName("${viewModel.user?.kakaoAccount?.profile?.nickname ?? "몬스터볼"}");
                    userInfoProvider.setUserUrl("viewModel.user?.kakaoAccount?.profile?.profileImageUrl");
                  });
                },
                child: const Text('login')),
              ElevatedButton(
                  onPressed: () async {
                    await viewModel.logout();
                    setState((){
                      userInfoProvider.setUserId(null);
                      userInfoProvider.setUserName("로그인 해주세요.");
                      userInfoProvider.setUserUrl("https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/product/몬스터볼10797");
                    });
                  },
                  child: const Text('logout')),],),
            Image.network("https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/product/몬스터볼10797" ,height: 50, width: 50,),
            Text(
              '${viewModel.isLogined}',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '${userInfoProvider.userInfo.userName ?? "로그인 해주세요."}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: () async {
                  await viewModel.login();
                  setState((){
                    userInfoProvider.setUserId('${viewModel.user?.id}');
                    userInfoProvider.setUserName("${viewModel.user?.kakaoAccount?.profile?.nickname ?? "몬스터볼"}");
                    userInfoProvider.setUserUrl("viewModel.user?.kakaoAccount?.profile?.profileImageUrl");
                  });
                },
                child: const Text('login')),
            ElevatedButton(
                onPressed: () async {
                  await viewModel.logout();
                  setState((){
                    userInfoProvider.setUserId(null);
                    userInfoProvider.setUserName("로그인 해주세요.");
                    userInfoProvider.setUserUrl("https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/product/몬스터볼10797");
                  });
                },
                child: const Text('logout')),
          ],
        ),
      ),
    );
  }
}

