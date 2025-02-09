//item/Ranking_list.dart
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shop_user/screens/item_detail.dart';
import 'package:shop_user/model/product.dart';
import 'package:shop_user/model/cart.dart';

class ItemList extends StatefulWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList>{
  List<Product> products = [];
  List<CartItem> cartItems =[];


  Future<void> readProductsData() async {
    QuerySnapshot productsSnapshot =
    await FirebaseFirestore.instance.collection('Product').get();

    if (productsSnapshot.docs.isEmpty) {
      print('!!!!!!!');
      return;
    }

    for (QueryDocumentSnapshot productDocument in productsSnapshot.docs) {
      Map<String, dynamic>? productData = productDocument.data() as Map<String, dynamic>?;
      String productName = productData!['productName'];
      String productDetails = productData['productDetails'];
      double price = productData['price']?.toDouble() ?? 0.0;
      String productNo = productDocument.id;
      String productImageUrl= productData!['productImageUrl'];


      products.add(
        Product(
          productNo: productNo,
          productName: productName,
          productDetails: productDetails,
          price: price,
          productImageUrl: productImageUrl,
        ),
      );

    }
  }

  @override
  void initState() {
    readProductsData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 3/5
      ),
      padding: EdgeInsets.all(16.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final image = products[index].productImageUrl ?? "";
        final productName = products[index].productName ?? "";
        final price = products[index].price.toString() ?? "";
        final productDetails = products[index].productDetails ?? "";
        final productNo = products[index].productNo ?? "";

        return GestureDetector(
          onTap: () {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(
                  image: image,
                  productName: productName,
                  price: price,
                  productDetails: productDetails,
                  cartItems: cartItems,
                  productNo : productNo,
                ),
              ),
            );
          },
          child: _buildRankingItem(image, productName, price),
        );
      },
    );
  }

  Widget _buildRankingItem(String image, String productName, String price) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(image, height: 100,),

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3.0),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
