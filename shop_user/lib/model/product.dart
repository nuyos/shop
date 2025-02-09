import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? productNo;
  String? productName;
  String? productDetails;
  String? productImageUrl; //대부분의 리스트 씀 List<String>
  double? price;

  Product({
    this.productNo,
    this.productName,
    this.productDetails,
    this.productImageUrl,
    this.price,
  });

  /**Product.fromJson(Map<String, dynamic> json) {
      productNo = json['productNo'];
      productName = json['productName'];
      productDetails = json['productDetails'];
      productImageUrl = json['productImageUrl'];
      price = double.parse(json['price']);
      }**/

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productNo : json['productNo'],
      productName : json['productName'],
      productDetails : json['productDetails'],
      productImageUrl : json['productImageUrl'],
      price : double.parse(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['productNo'] = productNo;
    data['productName'] = productName;
    data['productDetails'] = productDetails;
    data['productImageUrl'] = productImageUrl;
    data['price'] = price;
    return data;
  }
}
