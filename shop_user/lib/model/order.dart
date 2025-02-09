import 'package:flutter/material.dart';


class OrderItem {
  String orderId;
  String name;
  String? payment;
  String statement;
  String address;
  List<String>? orderList;

  OrderItem({
    required this.orderId,
    required this.name,
    required this.payment,
    required this.statement,
    required this.address,
    List<String>? orderList,  // 수정된 코드
  }) : this.orderList = orderList ?? [];

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      orderId : json['orderId'],
      name : json['name'],
      payment : json['payment'],
      statement : json['statement'],
      address : json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['orderId'] = orderId;
    data['name'] = name;
    data['payment'] = payment;
    data['statement'] = statement;
    data['address'] = address;
    return data;
  }

}

class OrderProvider with ChangeNotifier {
  OrderItem _order = OrderItem(orderId: "문의 부탁드립니다.",name: "문의 부탁드립니다.",payment: null,statement: "입금 확인 중",address: "문의 해 주세요");

  OrderItem get userInfo => _order;

  void setOrderId(String orderId) {
    _order.orderId = orderId;
    notifyListeners();
  }

  void setName(String name) {
    _order.name = name;
    notifyListeners();
  }
}
