import 'dart:ffi';

import 'package:bootpay/bootpay.dart';
import 'package:bootpay/model/extra.dart';
import 'package:bootpay/model/item.dart';
import 'package:bootpay/model/payload.dart';
import 'package:bootpay/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:shop_user/screens/ok_screen.dart';


class TotalPayment extends StatelessWidget {
  String androidApplicationId = '656c9fc3e57a7e001b59ff37'; // 이게 내키 안스만 쓰니까 나머지 키는 필요 없음

  @override
  Widget build(context) {
    final cartModel = Provider.of<CartModel>(context);
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: TextButton(
                    onPressed: () => bootpayTest(context),
                    child: const Text('결제창 넘어가기', style: TextStyle(fontSize: 16.0))
                )
            )
        )
    );
  }

  void bootpayTest(BuildContext context) {
    Payload payload = getPayload(context);
    if(kIsWeb) {
      payload.extra?.openType = "iframe";
    }

    Bootpay().requestPayment(
      context: context,
      payload: payload,
      showCloseButton: false,
      // closeButton: Icon(Icons.close, size: 35.0, color: Colors.black54),
      onCancel: (String data) {
        print('------- onCancel: $data');
      },
      onError: (String data) {
        print('------- onError: $data');
      },
      onClose: () {
        print('------- onClose');
        Bootpay().dismiss(context); //명시적으로 부트페이 뷰 종료 호출
        //TODO - 원하시는 라우터로 페이지 이동
      },
      onIssued: (String data) {
        print('------- onIssued: $data');
      },
      onConfirm: (String data) {
        print('------- onConfirm: $data');
        /**
            1. 바로 승인하고자 할 때
            return true;
         **/
        /***
            2. 비동기 승인 하고자 할 때
            checkQtyFromServer(data);
            return false;
         ***/
        /***
            3. 서버승인을 하고자 하실 때 (클라이언트 승인 X)
            return false; 후에 서버에서 결제승인 수행
         */
        // checkQtyFromServer(data);
        return true;
      },
      onDone: (String data) {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.push(context, MaterialPageRoute(builder: (context) => OkScreen()));
      },

    );
  }

  Payload getPayload(BuildContext context) {
    CartModel CartModelProvider = Provider.of<CartModel>(context, listen: false);
    Payload payload = Payload();
    Item item1 = Item();
    item1.name = "미키 '마우스"; // 주문정보에 담길 상품명
    item1.qty = 1; // 해당 상품의 주문 수량
    item1.id = "ITEM_CODE_MOUSE"; // 해당 상품의 고유 키
    item1.price = CartModelProvider.totalPrice; // 상품의 가격
    List<Item> itemList = [item1];

    payload.androidApplicationId = androidApplicationId; // android application id


    payload.pg = '나이스페이';
    //payload.method = '카드';
    //payload.methods = ['card', 'phone', 'vbank', 'bank', 'kakao','naver'];
    payload.orderName = "테스트 상품"; //결제할 상품명
    payload.price = CartModelProvider.totalPrice; //정기결제시 0 혹은 주석


    payload.orderId = DateTime.now().millisecondsSinceEpoch.toString(); //주문번호, 개발사에서 고유값으로 지정해야함


    payload.metadata = {
      "callbackParam1" : "value12",
      "callbackParam2" : "value34",
      "callbackParam3" : "value56",
      "callbackParam4" : "value78",
    }; // 전달할 파라미터, 결제 후 되돌려 주는 값
    payload.items = itemList; // 상품정보 배열

    User user = User(); // 구매자 정보
    user.username = "사용자 이름";
    user.email = "thqud8769@naver.com";
    user.area = "경기";
    user.phone = "010-9776-8769";
    user.addr = '경기 하남시 위례광장로 285';

    Extra extra = Extra(); // 결제 옵션
    extra.appScheme = 'bootpayFlutterExample';
    extra.cardQuota = '3';
    // extra.openType = 'popup';

    // extra.carrier = "SKT,KT,LGT"; //본인인증 시 고정할 통신사명
    // extra.ageLimit = 20; // 본인인증시 제한할 최소 나이 ex) 20 -> 20살 이상만 인증이 가능

    payload.user = user;
    payload.extra = extra;
    return payload;
  }
}
