class CartItem {
  final String productName;
  final String productNo;
  int count;
  final double price;

  CartItem({
    required this.productName,
    required this.productNo,
    required this.count,
    required this.price,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productNo : json['productNo'],
      productName : json['productName'],
      count : int.parse(json['count']),
      price : double.parse(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productNo'] = productNo;
    data['productName'] = productName;
    data['count'] = count;
    data['price'] = price;
    return data;
  }

}