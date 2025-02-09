import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shop_user/screen/root_screen.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/user.dart';
import 'package:shop_user/model/order.dart';





void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  kakao.KakaoSdk.init(
    nativeAppKey: '1f5245308f8c053129a99c67028dc9b9',
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        ChangeNotifierProvider(create: (context) => UserInfoProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true,),
      home: Builder(builder:(context) => RootScreen(),),
    );
  }
}

