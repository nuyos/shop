import 'package:flutter/material.dart';
import 'package:kpostal/kpostal.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:shop_user/screen/total_payment.dart';
import 'package:shop_user/screens/ok_screen.dart';
import 'package:shop_user/model/order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String postCode = '-';
  String address = '-';
  String Name = '';
  String deliveryDetails = '';

  List<CartItem> cartItem = [];
  List<OrderItem> order =[];

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context);
    final orderModel = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '주소 입력',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(

        child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KpostalView(
                      useLocalServer: true,
                      localPort: 1024,
                      callback: (Kpostal result) {
                        setState(() {
                          this.postCode = result.postCode;
                          this.address = result.address;
                        });
                      },
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: Text(
                '주소 검색',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              height: 500,
              padding: EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Text(
                    '우편번호: ${this.postCode}',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    '주소: ${this.address}',
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        deliveryDetails = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '배송지 세부정보',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        Name = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: '주문자 이름',
                    ),
                  ),

                  Text(
                    '결제 예정금액: ${cartModel.totalPrice} 원',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),

                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      addToWishList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TotalPayment(),
                        ),
                      );
                    },
                    child: Text('결제하기'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void addToWishList() async {
    int orderNum = Random().nextInt(10000)+10000;
    String orderId = "2023${orderNum}";
    CartModel CartModelProvider = Provider.of<CartModel>(context, listen: false);

    CartModelProvider.orderId=orderId;

    await FirebaseFirestore.instance.collection('order').doc("${orderId}").set(
        OrderItem(
          orderId: "${orderId}",
          name: "${this.Name}",
          payment: "${CartModelProvider.totalPrice}",
          address: "${this.postCode},${this.address}.${this.deliveryDetails}",
          statement: "입금 완료",
        ).toJson());

      for(int i = 0; i < CartModelProvider.items.length; i++){
      await FirebaseFirestore.instance.collection('order').doc("${orderId}").collection('orderlist').doc('${CartModelProvider.items[i].productNo}').set(
          CartItem(
            productNo: CartModelProvider.items[i].productNo,
            productName: CartModelProvider.items[i].productName,
            count: CartModelProvider.items[i].count,
            price: CartModelProvider.items[i].price,
          ).toJson());
      }
  }
  String? stringValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    }

    return null;
  }

}
