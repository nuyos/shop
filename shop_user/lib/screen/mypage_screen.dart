//mypagescreen //
import 'package:flutter/material.dart';
import 'package:shop_user/screen/main_view_model.dart';
import 'package:shop_user/screen/kakao_login.dart';
import 'package:shop_user/screen/kakao_login_page.dart';
import 'package:shop_user/screens/cart_screen.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/screens/order_list.dart';
import 'package:shop_user/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/screen/order_provider_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final viewModel = MainViewModel(Kakaologin());
  List<CartItem> cartItems = [];
  String? oId;


  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
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
          Divider(), //리스트 구분선
          TextField(
            onChanged: (value) {
              setState(() {
                oId = value;
              });
            },
            decoration: InputDecoration(
              labelText: '배송지 세부정보',
            ),
          ),
          ListTile(
            title: Text('주문조회'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (oId) => OrderProviderPage(uId: this.oId,)),
                //주문조회 페이지로 이동
              );
        },
          ),
        ],
      ),


    );
  }

}