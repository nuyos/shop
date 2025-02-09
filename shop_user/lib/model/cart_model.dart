import 'package:shop_user/model/cart.dart';
import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  final List<CartItem> _items = [];
  String? orderId;

  List<CartItem> get items => _items;

  double get totalPrice {
    double total = 0;
    _items.forEach((item) {
      total += item.price * item.count;
    });
    return total;
  }


  void add(CartItem item) {
    for(int i = 0; i<_items.length; i++) {
      if (item.productName == _items[i].productName) {
        item.count=_items[i].count+1;
        remove(_items[i]);
      }
    }
    _items.add(item);
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }
}
