import 'package:shop_admin/models/product.dart';

class User {
  String? id;
  List<Product>? cart;

  User({
    this.id,
    this.cart,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cart = json['cart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['cart'] = cart;
    return data;
  }
}
