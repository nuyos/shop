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