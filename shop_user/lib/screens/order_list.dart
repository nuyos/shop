import 'package:flutter/material.dart';
import 'package:flutter/services.dart';//텍스트 복사
import 'package:url_launcher/url_launcher.dart';//url 주소로 이동 pubspec url_launcher

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);


  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final String deliveryTrackingUrl = 'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=배송조회';
  @override
  Widget build(BuildContext){
    return Scaffold(
      appBar: AppBar(
        title: Text("주문조회"),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // 클립보드에 텍스트 복사
            Clipboard.setData(ClipboardData(text: ' tagetNumber'));
            // 복사되었음을 알리는 스낵바 표시
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('텍스트가 복사되었습니다.'),
              ),
            );
            _launchDeliveryTrackingURL(deliveryTrackingUrl);
          },
          child: Text(
            '배송조회',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
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