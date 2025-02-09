import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; //텍스트 복사
import 'package:url_launcher/url_launcher.dart'; //url 주소로 이동 pubspec url_launcher
import 'package:flutter/foundation.dart';//저장된 정보 따오기, provider에서 사용가능


class OrderProviderPage extends StatefulWidget {
  final String? uId;
  OrderProviderPage({required this.uId});

  @override
  State<OrderProviderPage> createState() => _OrderProviderPageState();
}

class _OrderProviderPageState extends State<OrderProviderPage> {
  String? orderId;
  String? name;
  String? statement;
  String? address;
  String? payment;
  final String deliveryTrackingUrl =
      'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=배송조회';


  Future<void> readProductsData() async {
    DocumentSnapshot orderSnapshot =
    await FirebaseFirestore.instance.collection('order').doc(widget.uId).get();

    if (orderSnapshot.exists) {
      Map<String, dynamic>? orderData = orderSnapshot.data() as Map<String, dynamic>?;
      if (orderData != null) {
        setState(() {
          orderId = orderData['orderId'];
          name = orderData['name'];
          statement = orderData['statement'];
          address = orderData['address'];
          payment = orderData['payment'];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    readProductsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child : Container(
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("배송 정보", style: TextStyle(fontSize: 30),),
            SizedBox(height: 16.0,),
            Text(
                "운송장 번호: ${orderId}" ?? "",style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),),
            Text(
                " 구매금액: ₩${payment}" ?? "",style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),),
            Text("배송 상태: ${statement}" ?? "",style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),),
            GestureDetector(
              child: Text(
                '배송 조회하러 가기',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                // 클립보드에 텍스트 복사
                Clipboard.setData(ClipboardData(text: '${orderId}'));
                // 복사되었음을 알리는 스낵바 표시
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('텍스트가 복사되었습니다.'),
                  ),
                );
                _launchDeliveryTrackingURL(deliveryTrackingUrl);
              },
            ),

          ],
        ),
      ),),
    );
  }

  _launchDeliveryTrackingURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

