import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OkScreen extends StatefulWidget {

  @override
  _OkScreenState createState() => _OkScreenState();
}

class _OkScreenState extends State<OkScreen> {
  String? orderId;



  Future<void> readProductsData() async {
    DocumentSnapshot orderSnapshot =
    await FirebaseFirestore.instance.collection('order').doc().get();

    if (orderSnapshot.exists) {
      Map<String, dynamic>? orderData = orderSnapshot.data() as Map<String, dynamic>?;
      if (orderData != null) {
        setState(() {
          orderId = orderData['orderId'];
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '주문 완료 ',
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '총 ${cartModel.totalPrice.toString()} 원',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '결제 되었습니다. ',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              child: Text(
                '주문번호:${cartModel.orderId}, 감사합니다',
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('완료하기'),
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
}
