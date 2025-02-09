import 'package:flutter/material.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/screen/root_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:shop_user/screens/address_screen.dart';
import 'package:shop_user/screens/home_screen.dart'; // 주소 입력 화면 파일 import

class CartPage extends StatefulWidget {
  final List<CartItem> cartItems;

  CartPage({required this.cartItems});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.cartItems.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(widget.cartItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '총 가격: ${cartModel.totalPrice}원',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // 결제하기 버튼이 눌리면 주소 입력 화면으로 이동
                final result = await _navigateToAddressInputScreen(context);
              },
              child: Text('구매하기'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black54,
                onPrimary: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${item.productName}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${item.price ?? 0} 원 / ${item.count} 개',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.cartItems.remove(item);
                });
              },
            ),
          ],
        ),
      ),
    );
  }



  Future<bool?> _navigateToAddressInputScreen(BuildContext context) async {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressScreen(),
      ),
    );
  }
}
