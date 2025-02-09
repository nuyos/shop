import 'package:flutter/material.dart';

import 'package:shop_user/screen/main_view_model.dart';
import 'package:shop_user/screen/kakao_login.dart';
import 'package:shop_user/screen/mypage_screen.dart';

//임시로
import 'package:shop_user/screen/kakao_login_page.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/screens/cart_screen.dart';
import 'package:shop_user/screens/item_list.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:shop_user/screen/wish_list_page.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int currentPageIndex = 0;
  final viewModel = MainViewModel(Kakaologin());

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cartModel = Provider.of<CartModel>(context);
    final cartItems = cartModel.items;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt),
            icon: Icon(Icons.list_alt_outlined),
            label: 'item list',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.favorite_outlined),
            icon: Icon(Icons.favorite_border),
            label: 'Wish list',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people_alt),
            icon: Icon(Icons.people_alt_outlined),
            label: 'User Setting',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("송수현 팔아요"),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(cartItems: cartItems),
                ),
              ).then((value) {
                // Handle data returned from CartPage
                if (value != null && value is CartItem) {
                  addToCart(cartModel, value);
                }
              });

              print(cartItems.length);
            },
          ),
        ],
      ),
      body: <Widget>[
        ItemList(),
        WishListPage(),
        MyPage(title: 'mypage'),
        //KakaoLoginPage(),
      ][currentPageIndex],
    );
  }

  void addToCart(CartModel cartModel, CartItem item) {
    setState(() {
      cartModel.add(item);
    });
  }

}
